import 'package:flutter/material.dart';
import '../widgets/lobby_content.dart';

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
          content: Text('wait until at least 1 player has joined'),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 219, 219, 219),
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
                    color: Color(0xFFE4007D),
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
        child: LobbyContent(
          isHost: widget.isHost,
          gameTitle: widget.gameTitle,
          players: _players,
        ),
      ),
      bottomNavigationBar: Container(
              margin: const EdgeInsets.symmetric(horizontal: 65,vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _players.isEmpty ? null : _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE4007D),
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
        isHost: true,
        gameTitle: 'HET SKATEPARK',
        players: ['Tobias', 'Jean Pierre', 'Lucas', 'Bob', 'Yannick', 'Quan del Dingel'],
      ),
    );
  }
}