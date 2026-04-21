import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  }) async {
    final user = await _requireUser();

    final callable = _functions.httpsCallable('createLobby2');

    final response = await callable.call({
      'uid': user.uid,
      'displayName': playerName,
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
  }) async {
    final user = await _requireUser();

    final callable = _functions.httpsCallable('joinLobby');

    final response = await callable.call({
      'uid': user.uid,
      'joinCode': joinCode,
      'displayName': playerName,
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

  Stream<List<String>> listenToPlayerNames(String lobbyId) {
    return _firestore
        .collection('lobbies')
        .doc(lobbyId)
        .collection('players')
        .orderBy('joinedAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return data['displayName'] as String? ??
            data['name'] as String? ??
            'Unknown';
      }).toList();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToLobby(String lobbyId) {
    return _firestore.collection('lobbies').doc(lobbyId).snapshots();
  }

  Future<void> startGame(String lobbyId) async {
    await _firestore.collection('lobbies').doc(lobbyId).update({
      'status': 'started',
      'gamePhase': 'started',
      'startedAt': FieldValue.serverTimestamp(),
    });
  }
}