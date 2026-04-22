class CreateLobbyResult {
  final String lobbyId;
  final String joinCode;

  CreateLobbyResult({
    required this.lobbyId,
    required this.joinCode,
  });

  factory CreateLobbyResult.fromMap(Map<String, dynamic> map) {
    return CreateLobbyResult(
      lobbyId: map['lobbyId'] ?? '',
      joinCode: map['joinCode'] ?? '',
    );
  }
}