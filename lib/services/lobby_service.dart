import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lobby/create_lobby_result.dart';

class LobbyService {
  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(region: 'europe-west1');

  Future<CreateLobbyResult> createLobby2({
    required String playerName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No Firebase user found.');
    }

    final result = await _functions.httpsCallable('createLobby2').call({
      'displayName': playerName,
      'uid': user.uid,
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    return CreateLobbyResult.fromMap(data);
  }

  Future<String> joinLobby({
    required String playerName,
    required String joinCode,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No Firebase user found.');
    }

    final result = await _functions.httpsCallable('joinLobby').call({
      'displayName': playerName,
      'joinCode': joinCode,
      'uid': user.uid,
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    return data['lobbyId'] as String;
  }
}