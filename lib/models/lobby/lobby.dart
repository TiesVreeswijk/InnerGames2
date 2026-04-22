class Lobby {
  final String id;
  final String joinCode;
  final String hostUid;
  final String status;
  final String gamePhase;
  final int maxPlayers;
  final int playerCount;
  final bool allReady;

  Lobby({
    required this.id,
    required this.joinCode,
    required this.hostUid,
    required this.status,
    required this.gamePhase,
    required this.maxPlayers,
    required this.playerCount,
    required this.allReady,
  });

  factory Lobby.fromMap(String id, Map<String, dynamic> map) {
    return Lobby(
      id: id,
      joinCode: map['joinCode'] ?? '',
      hostUid: map['hostUid'] ?? '',
      status: map['status'] ?? '',
      gamePhase: map['gamePhase'] ?? '',
      maxPlayers: (map['maxPlayers'] ?? 0) as int,
      playerCount: (map['playerCount'] ?? 0) as int,
      allReady: map['allReady'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'joinCode': joinCode,
      'hostUid': hostUid,
      'status': status,
      'gamePhase': gamePhase,
      'maxPlayers': maxPlayers,
      'playerCount': playerCount,
      'allReady': allReady,
    };
  }
}