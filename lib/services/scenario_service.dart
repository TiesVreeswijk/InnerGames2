import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<ScenarioData?> getCurrentScenario(String lobbyId) async {
    final lobbyDoc = await _firestore.collection('lobbies').doc(lobbyId).get();
    if (!lobbyDoc.exists) return null;
    final currentScenarioId = lobbyDoc.data()?['currentScenarioId'] as String?;
    // Als currentScenarioId niet gezet is, begin altijd met 'scenario_1'
    final scenarioId = currentScenarioId ?? 'scenario_1';
    return await getScenario(scenarioId);
  }

  Future<ScenarioData?> getScenario(String scenarioId) async {
    final scenarioDoc = await _firestore.collection('scenarios').doc(scenarioId).get();

    if (!scenarioDoc.exists) return null;

    // Laad de antwoorden uit de subcollectie
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
    });
  }
}