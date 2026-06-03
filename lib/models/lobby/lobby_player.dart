class LobbyPlayer {
  final String uid;
  final String displayName;
  final bool isHost;
  final bool isReady;
  final bool connected;
  final int? selectedAvatar;

  LobbyPlayer({
    required this.uid,
    required this.displayName,
    required this.isHost,
    required this.isReady,
    required this.connected,
    required this.selectedAvatar,
  });

  factory LobbyPlayer.fromMap(Map<String, dynamic> map) {
    return LobbyPlayer(
      uid: map['uid'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Player',
      isHost: map['isHost'] as bool? ?? false,
      isReady: map['isReady'] as bool? ?? false,
      connected: map['connected'] as bool? ?? false,
      selectedAvatar: map['selectedAvatar'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'isHost': isHost,
      'isReady': isReady,
      'connected': connected,
      'selectedAvatar': selectedAvatar,
    };
  }

  // Static method to parse a list of dynamic items into a list of LobbyPlayer instances
  // Why? Because when we fetch the list of players from Firestore, it might come as a List<dynamic> and we need to convert it to List<LobbyPlayer>.
  static List<LobbyPlayer> parseList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) {
        if (e is LobbyPlayer) return e;
        return LobbyPlayer(
          uid: '',
          displayName: e.toString(),
          isHost: false,
          isReady: false,
          connected: true,
          selectedAvatar: null,
        );
      }).toList();
    }
    return [];
  }
}