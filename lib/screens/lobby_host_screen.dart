import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/lobby_content.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/join_code_panel.dart';
import '../services/lobby_service.dart';
import '../models/lobby/lobby_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LobbyHostScreen extends StatefulWidget {
  final bool isHost;
  final String gameTitle;
  final String pin;
  final String lobbyId;
  final List<LobbyPlayer> players; // list of players with avatar data included
  final String? hostName;
  final int? selectedAvatar;

  const LobbyHostScreen({
    Key? key,
    required this.isHost,
    required this.gameTitle,
    required this.pin,
    required this.lobbyId,
    this.players = const [],
    this.hostName,
    this.selectedAvatar,
  }) : super(key: key);

  @override
  State<LobbyHostScreen> createState() => _LobbyHostScreenState();
}

class _LobbyHostScreenState extends State<LobbyHostScreen> {
  final LobbyService _lobbyService = LobbyService();

  late List<LobbyPlayer> _players;
  StreamSubscription<List<LobbyPlayer>>? _playersSubscription;
  bool _gameStarted = false;
  StreamSubscription? _lobbyStatusSubscription;

  @override
  void initState() {
    super.initState();


    if (widget.players.isNotEmpty) {
      _players = List.from(widget.players);
    } else if (widget.hostName != null) {
      _players = [
        LobbyPlayer(
          uid: '',
          displayName: widget.hostName!,
          isHost: true,
          isReady: false,
          connected: true,
          selectedAvatar: widget.selectedAvatar,
        ),
      ];
    } else {
      _players = [];
    }

    _playersSubscription =
        _lobbyService.listenToPlayers(widget.lobbyId).listen((players) {
          if (!mounted) return;
          setState(() {
            if (widget.hostName != null && players.isNotEmpty) {
              // default placeholders if Firestore doesn't have real data yet; but prefer Firestore values as soon as they exist
              final firstIsPlaceholder =
                  players[0].displayName == 'Host' ||
                  players[0].displayName == 'Unknown';
              if (firstIsPlaceholder) {
                _players = [
                  LobbyPlayer(
                    uid: players[0].uid,
                    displayName: widget.hostName!,
                    isHost: players[0].isHost,
                    isReady: players[0].isReady,
                    connected: players[0].connected,
                    selectedAvatar:
                        players[0].selectedAvatar ?? widget.selectedAvatar, // fallback to prevent erroring if can't find selectedavatar in Firestore yet
                  ),
                  ...players.skip(1),
                ];
              } else {
                _players = players;
              }
            } else {
              _players = players;
            }
          });
        });

    // Listen for the host-triggered game start so the screen transitions.
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    _lobbyStatusSubscription = firestore
        .collection('lobbies')
        .doc(widget.lobbyId)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      if (data != null && data['status'] == 'started') {
        if (mounted) {
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
        }
      }
    });
  }

  Future<void> _closeLobbyAndPop() async {
    await _lobbyService.closeLobby(widget.lobbyId);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _playersSubscription?.cancel();
    if (!_gameStarted) {
      _lobbyService.closeLobby(widget.lobbyId);
    }
    _lobbyStatusSubscription?.cancel();
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

    _gameStarted = true;

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _closeLobbyAndPop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          onBackPressed: _closeLobbyAndPop,
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildJoinCodeButton(),
              Expanded(
                child: LobbyContent(
                  isHost: widget.isHost,
                  gameTitle: widget.gameTitle,
                  players: _players,
                  hostName: widget.hostName,
                  selectedAvatar: widget.selectedAvatar,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildStartButton(),
      ),
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