import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/lobby_content.dart';
import '../widgets/custom_app_bar.dart';
import '../services/lobby_service.dart';

class LobbyScreen extends StatefulWidget {
  final bool isHost;
  final String gameTitle;
  final String lobbyId;
  final String pin;
  final List<String> players;

  const LobbyScreen({
    Key? key,
    required this.isHost,
    required this.gameTitle,
    required this.lobbyId,
    required this.pin,
    this.players = const [],
  }) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final LobbyService _lobbyService = LobbyService();

  late List<String> _players;
  StreamSubscription<List<String>>? _playersSubscription;
  StreamSubscription? _lobbySubscription;

  @override
  void initState() {
    super.initState();

    _players = List.from(widget.players);

    _playersSubscription =
        _lobbyService.listenToPlayerNames(widget.lobbyId).listen((players) {
          if (!mounted) return;

          setState(() {
            _players = players;
          });
        });

    _lobbySubscription = _lobbyService.listenToLobby(widget.lobbyId).listen(
          (snapshot) {
        if (!mounted) return;

        final data = snapshot.data();
        if (data == null) return;

        final status = data['status'] as String?;
        final gamePhase = data['gamePhase'] as String?;

        if (status == 'started' || gamePhase == 'started') {
          Navigator.pushReplacementNamed(
            context,
            '/game',
            arguments: {
              'lobbyId': widget.lobbyId,
              'pin': widget.pin,
              'gameTitle': widget.gameTitle,
              'players': _players,
              'isHost': false,
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _playersSubscription?.cancel();
    _lobbySubscription?.cancel();
    super.dispose();
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
    return const MaterialApp(
      home: LobbyScreen(
        isHost: false,
        gameTitle: 'HET SKATEPARK',
        lobbyId: 'test-lobby-id',
        pin: '1234',
        players: [
          'Tobias',
          'Jean Pierre',
          'Lucas',
          'Bob',
          'Yannick',
          'Quan del Dingel',
        ],
      ),
    );
  }
}