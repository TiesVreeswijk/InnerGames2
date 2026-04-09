import 'package:flutter/material.dart';
import '../widgets/lobby_content.dart';
import '../widgets/custom_app_bar.dart';

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
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: LobbyContent(
          isHost: widget.isHost,
          gameTitle: widget.gameTitle,
          players: _players,
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