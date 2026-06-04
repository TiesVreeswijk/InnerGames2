import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/lobby_content.dart';
import '../widgets/custom_app_bar.dart';
import '../services/lobby_service.dart';
import '../models/lobby/lobby_player.dart';

class LobbyScreen extends StatefulWidget {
  final bool isHost;
  final String gameTitle;
  final String lobbyId;
  final String pin;
  // ✅ FIX: List<LobbyPlayer> instead of List<String> so avatar is preserved
  final List<LobbyPlayer> players;

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

  // Getting all player data instead of just displaynames, so we can show their avatars in the lobby UI and not lose that info when syncing with Firestore.
  late List<LobbyPlayer> _players;
  StreamSubscription<List<LobbyPlayer>>? _playersSubscription;
  StreamSubscription? _lobbySubscription;

  @override
  void initState() {
    super.initState();

    _players = List.from(widget.players);

    // use listenToPlayers() so selectedAvatar is included
    _playersSubscription =
        _lobbyService.listenToPlayers(widget.lobbyId).listen((players) {
          if (!mounted) return;
          setState(() {
            _players = players;
          });
        });

    _lobbySubscription = _lobbyService.listenToLobby(widget.lobbyId).listen(
          (snapshot) {
        if (!mounted) return;

        if (!snapshot.exists) {
          _showLobbyClosedAndGoHome();
          return;
        }

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

        if (status == 'closed') {
          _showLobbyClosedAndGoHome();
        }
      },
    );
  }

  Future<void> _leaveAndGoHome() async {
    _playersSubscription?.cancel();
    _lobbySubscription?.cancel();
    await _lobbyService.removePlayer(widget.lobbyId);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  void _showLobbyClosedAndGoHome() {
    _playersSubscription?.cancel();
    _lobbySubscription?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Lobby gesloten'),
        content: const Text('De host heeft de lobby gesloten.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _leaveAndGoHome();
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: CustomAppBar(
          onBackPressed: _leaveAndGoHome,
        ),
        body: SafeArea(
          child: LobbyContent(
            isHost: widget.isHost,
            gameTitle: widget.gameTitle,
            players: _players,
          ),
        ),
      ),
    );
  }
}