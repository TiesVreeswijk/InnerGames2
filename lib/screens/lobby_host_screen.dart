import 'package:flutter/material.dart';
import '../widgets/lobby_content.dart';
import '../widgets/custom_app_bar.dart';

class LobbyHostScreen extends StatefulWidget {
  final bool isHost;
  final String gameTitle;
  final List<String> players;
  
  const LobbyHostScreen({
    Key? key,
    required this.isHost,
    required this.gameTitle,
    this.players = const [],
  }) : super(key: key);

  @override
  State<LobbyHostScreen> createState() => _LobbyHostScreenState();
}

class _LobbyHostScreenState extends State<LobbyHostScreen> {
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
      appBar: const CustomAppBar(),
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
      home: const LobbyHostScreen(
        isHost: true,
        gameTitle: 'HET SKATEPARK',
        players: ['Tobias', 'Jean Pierre', 'Lucas', 'Bob', 'Yannick', 'Quan del Dingel'],
      ),
    );
  }
}