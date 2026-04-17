import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../services/lobby_service.dart';
import '../services/auth_service.dart';

class ChoosingStoryScreen extends StatelessWidget {
  const ChoosingStoryScreen({super.key});

  Future<User> _ensureSignedInAndReady() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      user = credential.user;
    }

    if (user == null) {
      throw Exception('No Firebase user available');
    }

    await user.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Firebase user disappeared after reload');
    }

    await user.getIdToken(true);
    await FirebaseAuth.instance.authStateChanges().firstWhere((u) => u != null);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    final String playerName =
        routeArgs['hostName'] ??
            routeArgs['playerName'] ??
            routeArgs['name'] ??
            'Host';

    final dynamic selectedAvatar = routeArgs['selectedAvatar'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: const Text(
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
                        imageUrl:
                        'assets/images/apothekerAssistenten_story.png',
                        onTap: () {
                          _showStoryOptions(
                            context,
                            storyTitle:
                            'SPEELKAARTJES DE APOTHEKER ASSISTENTEN',
                            playerName: playerName,
                            selectedAvatar: selectedAvatar,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildPlaceholderCard(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {},
                  ),
                ),
              ),
              Container(
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

  Widget _buildPlaceholderCard(BuildContext context) {
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              storyTitle,
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
                child: const Icon(Icons.games, color: Colors.white),
              ),
              title: const Text(
                'Spel hosten',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Start een nieuw spel als host'),
              onTap: () async {
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

                  Navigator.pushNamed(
                    context,
                    '/host-share',
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
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kies een verhaal om te hosten',
              style: TextStyle(
                fontSize: 20,
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
                child: const Icon(Icons.skateboarding, color: Colors.white),
              ),
              title: const Text(
                'HET SKATEPARK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('1e verhaal'),
              onTap: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(context, '/host-share');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Deelnemen aan spel',
              style: TextStyle(
                fontSize: 20,
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
                child: const Icon(Icons.pin, color: Colors.white),
              ),
              title: const Text(
                'PIN invoeren',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Voer een 4-cijferige PIN in'),
              onTap: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(context, '/join-pin');
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E7E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.qr_code_scanner, color: Colors.white),
              ),
              title: const Text(
                'QR-code scannen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Scan de QR-code van de host'),
              onTap: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(context, '/join-qr');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createGame(BuildContext context, String storyTitle) {
    Navigator.pushNamed(
      context,
      '/create-join',
      arguments: {
        'storyTitle': storyTitle,
      },
    );
  }
}