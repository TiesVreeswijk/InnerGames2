import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../services/lobby_service.dart';
import '../services/auth_service.dart';

class ChoosingStoryScreen extends StatelessWidget {
  const ChoosingStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    final String playerName = routeArgs['hostName'] ??
        routeArgs['playerName'] ??
        routeArgs['name'] ??
        'Host';

    final dynamic selectedAvatar = routeArgs['selectedAvatar'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  child: Text(
                    'Aanbevolen:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _buildStoryCard(
                  context,
                  title: '1ST STORY\nHET SKATEPARK',
                  imageUrl: 'assets/images/skatepark_story.png',
                  onTap: () {
                    _showStoryOptions(
                      context,
                      storyTitle: 'HET SKATEPARK',
                      playerName: playerName,
                      selectedAvatar: selectedAvatar,
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildStoryCard(
                  context,
                  title: '2ND STORY\nDE APOTHEKER ASSISTENTEN',
                  imageUrl: 'assets/images/apothekerAssistenten_story.png',
                  onTap: () {
                    _showStoryOptions(
                      context,
                      storyTitle: 'SPEELKAARTJES DE APOTHEKER ASSISTENTEN',
                      playerName: playerName,
                      selectedAvatar: selectedAvatar,
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildPlaceholderCard(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard(
      BuildContext context, {
        required String title,
        required String imageUrl,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE8E8E8),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.image_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStoryOptions(
      BuildContext context, {
        required String storyTitle,
        required String playerName,
        required dynamic selectedAvatar,
      }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext modalContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  storyTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 24),

                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.games,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Spel hosten',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Start een nieuw spel als host',
                  ),
                  onTap: () async {
                    await _createLobbyAndGoToHostLobby(
                      context: context,
                      modalContext: modalContext,
                      storyTitle: storyTitle,
                      playerName: playerName,
                      selectedAvatar: selectedAvatar,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createLobbyAndGoToHostLobby({
    required BuildContext context,
    required BuildContext modalContext,
    required String storyTitle,
    required String playerName,
    required dynamic selectedAvatar,
  }) async {
    final authService = AuthService();
    final lobbyService = LobbyService();

    try {
      final user = await authService.ensureSignedIn();

      debugPrint('UID before createLobby: ${user.uid}');
      debugPrint(
        'PROJECT ID FROM APP: ${FirebaseAuth.instance.app.options.projectId}',
      );

      final result = await lobbyService.createLobby2(
        playerName: playerName,
      );

      if (!context.mounted) return;

      Navigator.pop(modalContext);

      Navigator.pushReplacementNamed(
        context,
        '/lobby_host',
        arguments: {
          'lobbyId': result.lobbyId,
          'joinCode': result.joinCode,
          'pin': result.joinCode,
          'isHost': true,
          'gameTitle': storyTitle,
          'players': [playerName],
          'hostName': playerName,
          'selectedAvatar': selectedAvatar,
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lobby aanmaken mislukt: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}