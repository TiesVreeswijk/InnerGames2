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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF2C3E7E),
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    '/name-entry',
                  ),
                ),
              ),
            ),
            Expanded(
              child: LobbyContent(
                isHost: widget.isHost,
                gameTitle: widget.gameTitle,
                players: _players,
              ),
            ),
          ],
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