import 'package:flutter/material.dart';

class LobbyScreen extends StatefulWidget {
  final bool isHost;
  final String gameTitle;
  final List<String> players;
  
  const LobbyScreen({
    Key? key,
    required this.isHost,
    required this.gameTitle,
    this.players = const [],
  }) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late List<String> _players;

  @override
  void initState() {
    super.initState();
    _players = List.from(widget.players);
    
    // TODO: Listen to Firebase for real-time player updates
    // StreamSubscription _playersSubscription = FirebaseService
    //   .listenToPlayers(gameId)
    //   .listen((players) {
    //     setState(() {
    //       _players = players;
    //     });
    //   });
  }

  void _startGame() {
    if (_players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wacht tot spelers deelnemen'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Update game status in Firebase to 'started'
    Navigator.pushReplacementNamed(context, '/game');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD89B6A),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE91E63),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Sociality',
              style: TextStyle(
                color: Color(0xFF2C3E7E),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Game title card
            Container(
              margin: const EdgeInsets.all(16),
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
                    widget.gameTitle.toUpperCase(),
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
                          '${_players.length}/20',
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

            // Deelnemers header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E7E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Deelnemers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Players grid or empty state
            Expanded(
              child: _players.isEmpty
                  ? _buildEmptyState()
                  : _buildPlayersList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFD89B6A),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _players.isEmpty ? null : _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.play_arrow, color: Colors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            widget.isHost
                ? 'Wacht op spelers...'
                : 'Verbinding maken...',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isHost
                ? 'Deel de PIN met anderen'
                : 'Je komt zo in de lobby',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
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
      itemCount: _players.length,
      itemBuilder: (context, index) {
        final isHost = widget.isHost && index == 0;
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  _players[index],
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
              if (isHost)
                const Positioned(
                  top: 8,
                  left: 12,
                  child: Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Test runner - allows running this file directly
void main() {
  runApp(const _LobbyScreenTestApp());
}

class _LobbyScreenTestApp extends StatelessWidget {
  const _LobbyScreenTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LobbyScreen(
        isHost: false,
        gameTitle: 'HET SKATEPARK',
        players: ['Alice', 'Bob', 'Charlie'],
      ),
    );
  }
}