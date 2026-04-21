import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/lobby_content.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/join_code_panel.dart';
import '../services/lobby_service.dart';

class LobbyHostScreen extends StatefulWidget {
  final bool isHost;
  final String gameTitle;
  final String pin;
  final String lobbyId;
  final List<String> players;
  final String? hostName;

  const LobbyHostScreen({
    Key? key,
    required this.isHost,
    required this.gameTitle,
    required this.pin,
    required this.lobbyId,
    this.players = const [],
    this.hostName,
  }) : super(key: key);

  @override
  State<LobbyHostScreen> createState() => _LobbyHostScreenState();
}

class _LobbyHostScreenState extends State<LobbyHostScreen> {
  final LobbyService _lobbyService = LobbyService();

  late List<String> _players;
  StreamSubscription<List<String>>? _playersSubscription;

  @override
  void initState() {
    super.initState();

    // Tijdelijke startwaarde, zodat de UI niet leeg is voordat Firebase reageert.
    _players = List.from(widget.players);

    // Dit is nu de echte bron van waarheid.
    // Zodra een speler joined in Firestore, update de host-lobby automatisch.
    _playersSubscription =
        _lobbyService.listenToPlayerNames(widget.lobbyId).listen((players) {
          if (!mounted) return;

          setState(() {
            _players = players;
          });
        });
  }

  @override
  void dispose() {
    _playersSubscription?.cancel();
    super.dispose();
  }

  bool get _canStartGame => _players.isNotEmpty;

  void _showJoinCodeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBottomSheetHandle(),

                const SizedBox(height: 20),

                JoinCodePanel(
                  pin: widget.pin,
                  showCloseButton: true,
                  compact: true,
                  onClose: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetHandle() {
    return Container(
      width: 48,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }

  Future<void> _startGame() async {
    if (!_canStartGame) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wacht tot minstens 1 speler is gejoined'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await _lobbyService.startGame(widget.lobbyId);

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/game',
        arguments: {
          'lobbyId': widget.lobbyId,
          'pin': widget.pin,
          'gameTitle': widget.gameTitle,
          'players': _players,
          'isHost': true,
        },
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kon het spel niet starten: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildJoinCodeButton(),

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
      bottomNavigationBar: _buildStartButton(),
    );
  }

  Widget _buildJoinCodeButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: _showJoinCodeBottomSheet,
          icon: const Icon(Icons.qr_code),
          label: const Text('Toon pin / QR-code'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2C3E7E),
            side: const BorderSide(
              color: Color(0xFF2C3E7E),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 65,
        vertical: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _canStartGame ? _startGame : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE4007D),
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
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
      debugShowCheckedModeBanner: false,
      home: LobbyHostScreen(
        isHost: true,
        gameTitle: 'HET SKATEPARK',
        pin: '3786',
        lobbyId: 'test-lobby-id',
        hostName: 'Host',
        players: [
          'Host',
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