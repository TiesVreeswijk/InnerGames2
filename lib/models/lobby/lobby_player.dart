class LobbyPlayer {
  final String uid;
  final String displayName;
  final bool isHost;
  final bool isReady;
  final bool connected;

  LobbyPlayer({
    required this.uid,
    required this.displayName,
    required this.isHost,
    required this.isReady,
    required this.connected,
  });

  factory LobbyPlayer.fromMap(Map<String, dynamic> map) {
    return LobbyPlayer(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? 'Player',
      isHost: map['isHost'] ?? false,
      isReady: map['isReady'] ?? false,
      connected: map['connected'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'isHost': isHost,
      'isReady': isReady,
      'connected': connected,
    };
  }
}