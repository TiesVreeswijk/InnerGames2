import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/scenario_data.dart';


class ScenarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'europe-west1',
  );

  Future<User> _requireUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_USER',
        message: 'No user is currently signed in.',
      );
    }
    return user;
  }

  // ── Scenario fetching ──────────────────────────────────────────────────────

  Future<ScenarioData?> getCurrentScenario(String lobbyId) async {
    final lobbyDoc = await _firestore.collection('lobbies').doc(lobbyId).get();
    if (!lobbyDoc.exists) return null;
    final currentScenarioId = lobbyDoc.data()?['currentScenarioId'] as String?;
    final scenarioId = currentScenarioId ?? 'scenario_1';
    return await getScenario(scenarioId);
  }

  Future<List<ScenarioData>> getAllScenarios() async {
    final scenarioDocs = await _firestore.collection('scenarios').get();
    List<ScenarioData> scenarios = [];
    for (final doc in scenarioDocs.docs) {
      final answersSnapshot = await _firestore
          .collection('scenarios')
          .doc(doc.id)
          .collection('answers')
          .get();

      final answers = answersSnapshot.docs
          .map((answerDoc) =>
          AnswerData.fromFirestore(answerDoc.id, answerDoc.data()))
          .toList();

      scenarios.add(ScenarioData.fromFirestore(doc.id, doc.data(), answers));
    }
    return scenarios;
  }

  Future<ScenarioData?> getScenario(String scenarioId) async {
    final scenarioDoc =
    await _firestore.collection('scenarios').doc(scenarioId).get();
    if (!scenarioDoc.exists) return null;

    final answersSnapshot = await _firestore
        .collection('scenarios')
        .doc(scenarioId)
        .collection('answers')
        .get();

    final answers = answersSnapshot.docs
        .map((doc) => AnswerData.fromFirestore(doc.id, doc.data()))
        .toList();

    return ScenarioData.fromFirestore(scenarioId, scenarioDoc.data()!, answers);
  }

  Future<void> moveToNextScenario(String lobbyId, String nextScenarioId) async {
    await _firestore.collection('lobbies').doc(lobbyId).update({
      'currentScenarioId': nextScenarioId,
      // Reset the vote tally so the new scenario starts clean.
      'votes': <String, dynamic>{},
    });
  }

  // ── Voting ─────────────────────────────────────────────────────────────────

  /// Records (or changes) the current user's vote for [optionIndex] on the
  /// active scenario.
  ///
  /// Uses a dotted field path (`votes.<uid>`) so only this player's entry in
  /// the `votes` map is written — everyone else's votes are left untouched.
  Future<void> castVote(String lobbyId, int optionIndex) async {
    final user = await _requireUser();
    await _firestore.collection('lobbies').doc(lobbyId).update({
      'votes.${user.uid}': optionIndex,
    });
  }

  /// Clears every vote for the lobby. Called when moving to a new scenario.
  Future<void> clearVotes(String lobbyId) async {
    await _firestore.collection('lobbies').doc(lobbyId).update({
      'votes': <String, dynamic>{},
    });
  }

  /// Advances the lobby to [scenarioId] and resets the votes in a single write,
  /// so listeners never briefly see new-scenario + stale-votes.
  Future<void> advanceToScenario(String lobbyId, String scenarioId) async {
    await _firestore.collection('lobbies').doc(lobbyId).update({
      'currentScenarioId': scenarioId,
      'votes': <String, dynamic>{},
    });
  }

  // ── Lobby listening ────────────────────────────────────────────────────────

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToLobby(String lobbyId) {
    return _firestore.collection('lobbies').doc(lobbyId).snapshots();
  }

  // ── Player management ──────────────────────────────────────────────────────

  Future<void> removePlayer(String lobbyId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('removePlayer: no current user!');
        return;
      }

      debugPrint('removePlayer: deleting uid=${user.uid} from lobby=$lobbyId');

      await _firestore
          .collection('lobbies')
          .doc(lobbyId)
          .collection('players')
          .doc(user.uid)
          .delete();

      debugPrint('removePlayer: delete successful');
    } catch (e) {
      debugPrint('removePlayer error: $e');
    }
  }

  /// Sets status to 'closed' first so all listeners can react,
  /// waits briefly, then deletes the lobby document.
  Future<void> closeLobby(String lobbyId) async {
    try {
      await _firestore.collection('lobbies').doc(lobbyId).update({
        'status': 'closed',
        'closedAt': FieldValue.serverTimestamp(),
      });
      // Give clients time to receive the status update before deletion
      await Future.delayed(const Duration(seconds: 2));
      await _firestore.collection('lobbies').doc(lobbyId).delete();
      debugPrint('closeLobby: deleted lobby $lobbyId');
    } catch (e) {
      debugPrint('closeLobby error: $e');
    }
  }

  Future<void> finishAndDeleteLobby(String lobbyId) async {
    try {
      await _firestore.collection('lobbies').doc(lobbyId).update({
        'status': 'finished',
        'finishedAt': FieldValue.serverTimestamp(),
      });
      await Future.delayed(const Duration(seconds: 3));
      await _firestore.collection('lobbies').doc(lobbyId).delete();
      debugPrint('finishAndDeleteLobby: deleted lobby $lobbyId');
    } catch (e) {
      debugPrint('finishAndDeleteLobby error: $e');
    }
  }
}