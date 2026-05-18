import 'package:flutter/material.dart';

class LobbyContent extends StatelessWidget {
  final bool isHost;
  final String gameTitle;
  final List<String> players;
  final String? hostName;       // ✅ FIX: added hostName
  final int? selectedAvatar;    // ✅ FIX: added selectedAvatar

  const LobbyContent({
    Key? key,
    required this.isHost,
    required this.gameTitle,
    required this.players,
    this.hostName,
    this.selectedAvatar,
  }) : super(key: key);

  // ✅ FIX: matches AvatarData.getDefaultAvatars() in avatar_select.dart
  static const List<String> _defaultAvatars = [
    'assets/images/3d_avatar_1.png',
    'assets/images/3d_avatar_2.png',
    'assets/images/3d_avatar_3.png',
    'assets/images/3d_avatar_4.png',
    'assets/images/3d_avatar_5.png',
    'assets/images/3d_avatar_6.png',
    'assets/images/3d_avatar_7.png',
    'assets/images/3d_avatar_8.png',
    'assets/images/3d_avatar_9.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E7E),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                gameTitle.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${players.length}/20',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 80),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E7E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Players',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: players.isEmpty ? _buildEmptyState() : _buildPlayersList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isHost ? 'Wait for players to join...' : 'Connecting...',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isHost
                ? 'Share the PIN with others'
                : 'You will join the lobby shortly',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final playerName = players[index];

        // ✅ FIX: identify host by name, not by index 0
        final isHostPlayer = playerName == hostName;

        // ✅ FIX: use real selected avatar for host; fallback for others
        final avatarAssetPath = _avatarAssetForPlayer(index, isHostPlayer);

        final playerBoxColor =
        isHostPlayer ? const Color(0xFFF18F02) : const Color(0xFFE4007D);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 48,
                padding: const EdgeInsets.only(left: 34, right: 18),
                decoration: BoxDecoration(
                  color: playerBoxColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    playerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: -2,
              child: Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatarAssetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF2F2F2),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF2C3E7E),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _avatarAssetForPlayer(int index, bool isHostPlayer) {
    // ✅ FIX: host gets their chosen avatar; others cycle through defaults
    if (isHostPlayer && selectedAvatar != null) {
      if (selectedAvatar! >= 0 && selectedAvatar! < _defaultAvatars.length) {
        return _defaultAvatars[selectedAvatar!];
      }
    }

    // Fallback: cycle through the list for non-host players
    return _defaultAvatars[index % _defaultAvatars.length];
  }
}