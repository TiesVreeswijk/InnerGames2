import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/scenario_data.dart';
import '../models/lobby/lobby_player.dart';

class CreateLobbyResult {
  final String lobbyId;
  final String joinCode;

  const CreateLobbyResult({
    required this.lobbyId,
    required this.joinCode,
  });
}

class JoinLobbyResult {
  final String lobbyId;
  final String joinCode;

  const JoinLobbyResult({
    required this.lobbyId,
    required this.joinCode,
  });
}

class LobbyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'europe-west1',
  );

  Future<User> _requireUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      user = credential.user;
    }

    if (user == null) {
      throw Exception('No Firebase user available');
    }

    return user;
  }

  Future<CreateLobbyResult> createLobby2({
    required String playerName,
    required int selectedAvatar,
  }) async {
    final user = await _requireUser();

    final callable = _functions.httpsCallable('createLobby2');

    final response = await callable.call({
      'uid': user.uid,
      'displayName': playerName,
      'selectedAvatar': selectedAvatar,
    });

    final data = Map<String, dynamic>.from(response.data as Map);

    final success = data['success'] as bool? ?? false;

    if (!success) {
      throw Exception('createLobby2 failed');
    }

    return CreateLobbyResult(
      lobbyId: data['lobbyId'] as String,
      joinCode: data['joinCode'] as String,
    );
  }

  Future<JoinLobbyResult> joinLobby({
    required String joinCode,
    required String playerName,
    required int selectedAvatar,
  }) async {
    final user = await _requireUser();

    final callable = _functions.httpsCallable('joinLobby');

    final response = await callable.call({
      'uid': user.uid,
      'joinCode': joinCode,
      'displayName': playerName,
      'selectedAvatar': selectedAvatar,
    });

    final data = Map<String, dynamic>.from(response.data as Map);

    final success = data['success'] as bool? ?? false;

    if (!success) {
      throw Exception('joinLobby failed');
    }

    return JoinLobbyResult(
      lobbyId: data['lobbyId'] as String,
      joinCode: data['joinCode'] as String,
    );
  }

  // This handles both players and their avatars together, so the UI can get all the data it needs from one stream instead of syncing two separate ones.
  Stream<List<LobbyPlayer>> listenToPlayers(String lobbyId) {
    return _firestore
        .collection('lobbies')
        .doc(lobbyId)
        .collection('players')
        .orderBy('joinedAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        // Ensure uid is always set, even if the cloud function didn't write it
        data['uid'] = doc.id;
        return LobbyPlayer.fromMap(data);
      }).toList();
    });
  }

  // so both streams stay in sync from the same Firestore query.
  Stream<List<String>> listenToPlayerNames(String lobbyId) {
    return listenToPlayers(lobbyId).map(
      (players) => players.map((p) => p.displayName).toList(),
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToLobby(
    String lobbyId,
  ) {
    return _firestore.collection('lobbies').doc(lobbyId).snapshots();
  }

  Future<void> removePlayer(String lobbyId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('removePlayer: no current user!');
        return;
      }

      debugPrint(
        'removePlayer: deleting uid=${user.uid} from lobby=$lobbyId',
      );

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

  Future<void> closeLobby(String lobbyId) async {
    try {
      await _firestore.collection('lobbies').doc(lobbyId).delete();

      debugPrint('closeLobby: deleted lobby $lobbyId');
    } catch (e) {
      debugPrint('closeLobby error (ignored): $e');
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
      debugPrint('finishAndDeleteLobby error (ignored): $e');
    }
  }

  Future<void> startGame(String lobbyId) async {
    await startGameWithScenario(lobbyId, 'scenario_1');
  }

  Future<void> startGameWithScenario(
    String lobbyId,
    String firstScenarioId,
  ) async {
    await _firestore.collection('lobbies').doc(lobbyId).update({
      'status': 'started',
      'gamePhase': 'story',
      'currentScenarioId': firstScenarioId,
      'startedAt': FieldValue.serverTimestamp(),
    });
  }
}