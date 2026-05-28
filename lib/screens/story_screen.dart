import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/scenario_data.dart';
import '../models/story_card_data.dart';
import '../services/scenario_service.dart';
import '../widgets/choice_card.dart';
import '../widgets/intervention_card.dart';
import '../widgets/story_card.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final ScenarioService _scenarioService = ScenarioService();

  bool _choicesLocked = false;
  ScenarioData? _scenario;
  String _currentScenarioId = 'scenario_1';
  late Future<void> _gameFuture;
  StreamSubscription? _lobbyStatusSubscription;

  int _choiceClickCount = 0;
  String? _lastChoiceId;

  bool _showInterventionCards = false;
  StoryCardData? _interventionCardData;
  List<Map<String, String>> _interventionCardDetails = [];
  int _uniqueInterventionCount = 0;
  final int _maxInterventionCards = 8;

  List<ScenarioData> _allScenarios = [];
  int _lostLifes = 0;
  bool _gameOverDialogShown = false;

  @override
  void initState() {
    super.initState();

    _gameFuture = _loadScenario(_currentScenarioId);
    _loadAllScenarios();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final lobbyId = args?['lobbyId'];

      if (lobbyId != null) {
        _lobbyStatusSubscription = FirebaseFirestore.instance
            .collection('lobbies')
            .doc(lobbyId)
            .snapshots()
            .listen((snapshot) async {
          // ✅ Lobby deleted — host left, kick everyone back to home
          if (!snapshot.exists) {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcome',
                    (route) => false,
              );
            }
            return;
          }

          final data = snapshot.data();
          if (data == null) return;

          // ✅ Host explicitly closed the lobby
          final status = data['status'] as String?;
          if (status == 'closed' || status == 'finished') {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcome',
                    (route) => false,
              );
            }
            return;
          }

          // ✅ Scenario sync
          if (data['currentScenarioId'] != null &&
              data['currentScenarioId'] != _currentScenarioId) {
            await _loadScenario(data['currentScenarioId']);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _lobbyStatusSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadAllScenarios() async {
    final scenarios = await _scenarioService.getAllScenarios();
    if (!mounted) return;
    setState(() {
      _allScenarios = scenarios;
    });
  }

  Future<void> _loadScenario(String scenarioId) async {
    final scenario = await _scenarioService.getScenario(scenarioId);

    if (scenario == null) {
      throw Exception('No scenario found for id: $scenarioId');
    }

    if (!mounted) return;

    setState(() {
      _scenario = scenario;
      _choicesLocked = false;
      _currentScenarioId = scenarioId;
      _choiceClickCount = 0;
      _lastChoiceId = null;
    });

    print('Nieuw scenario geladen: $_currentScenarioId');
  }

  void _showGameOverDialogIfNeeded(BuildContext context) {
    if (_lostLifes >= 3 && !_gameOverDialogShown) {
      _gameOverDialogShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Je hebt het spel helaas niet gehaald'),
          content: const Text('Je wordt teruggestuurd naar het beginscherm...'),
        ),
      );
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final isHost = args?['isHost'] == true;
    final lobbyId = args?['lobbyId'] as String?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGameOverDialogIfNeeded(context);
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (isHost && lobbyId != null) {
          await _scenarioService.closeLobby(lobbyId);
        } else if (!isHost && lobbyId != null) {
          await _scenarioService.removePlayer(lobbyId);
        }

        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcome',
                (route) => false,
          );
        }
      },
      child: FutureBuilder<void>(
        future: _gameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Fout bij laden van game:\n${snapshot.error}'),
              ),
            );
          }

          if (_scenario == null) {
            return const Scaffold(
              body: Center(
                child: Text('No scenario found'),
              ),
            );
          }

          final storyCardData = StoryCardData(
            id: _scenario!.id,
            cardNumber: _scenario!.id,
            storyTag: '',
            storySubtitle: _scenario!.title,
            cardLabel: 'SITUATIE',
            timeLimit: 30,
            imageAsset: _scenario!.imageUrl ?? '',
            textTitle: _scenario!.title,
            textPages: [_scenario!.text],
            choices: _scenario!.answers
                .map(
                  (answer) => ChoiceData(
                text: answer.text,
                nextCardId: answer.nextScenarioId ?? '',
              ),
            )
                .toList(),
          );

          if (_currentScenarioId == 'scenario_6') {
            return Scaffold(
              backgroundColor: const Color(0xFFF7F7F7),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: StoryCard(
                        key: ValueKey(_currentScenarioId),
                        data: storyCardData,
                        showTimer: false,
                        onTimerFinished: () {
                          if (!mounted || isHost) return;
                          setState(() {
                            _choicesLocked = true;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32, top: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/welcome',
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A50A0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Ga terug naar het hoofdscherm'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F7),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Image.asset('assets/images/logo.png'),
                ),
                SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: AnimatedSlide(
                              offset: _showInterventionCards
                                  ? const Offset(0, -1.25)
                                  : Offset.zero,
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeInOut,
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(12, 16, 12, 0),
                                child: StoryCard(
                                  key: ValueKey(_currentScenarioId),
                                  data: storyCardData,
                                  showTimer: true,
                                  onTimerFinished: () {
                                    if (!mounted || isHost) return;
                                    setState(() {
                                      _choicesLocked = true;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            flex: 3,
                            child: AnimatedSlide(
                              offset: _showInterventionCards
                                  ? const Offset(0, 1.25)
                                  : Offset.zero,
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeInOut,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ChoiceCard(
                                        isHost: isHost,
                                        choices: storyCardData.choices,
                                        isLocked: _choicesLocked ||
                                            _showInterventionCards ||
                                            _lostLifes >= 3,
                                        uniqueInterventionCount:
                                        _uniqueInterventionCount,
                                        maxInterventionCards:
                                        _maxInterventionCards,
                                        allScenarios: _allScenarios,
                                        lostLifes: _lostLifes,
                                        onLostLifesChanged: (newLostLifes) {
                                          if (_lostLifes != newLostLifes) {
                                            setState(() {
                                              _lostLifes = newLostLifes;
                                            });
                                          }
                                        },
                                        onChoiceSelected: (choice) async {
                                          final isJoker =
                                          !_scenario!.answers.any((a) =>
                                          a.nextScenarioId ==
                                              choice.nextCardId);
                                          if (isJoker) {
                                            await _loadScenario(
                                                choice.nextCardId);
                                            return;
                                          }

                                          if (_lastChoiceId ==
                                              choice.nextCardId) {
                                            _choiceClickCount++;
                                          } else {
                                            _choiceClickCount = 1;
                                            _lastChoiceId = choice.nextCardId;
                                          }

                                          if (_choiceClickCount != 2) return;

                                          if (isHost &&
                                              choice.nextCardId.isNotEmpty) {
                                            final answer =
                                            _scenario?.answers.firstWhere(
                                                  (answer) =>
                                              answer.nextScenarioId ==
                                                  choice.nextCardId,
                                              orElse: () =>
                                                  AnswerData(id: '', text: ''),
                                            );

                                            final cardIds =
                                                answer?.cardIds ?? [];

                                            if (cardIds.isNotEmpty) {
                                              final kaartDetails =
                                              <Map<String, String>>[];

                                              for (final cardId in cardIds) {
                                                final doc =
                                                await FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                    'collectibleSituationCards')
                                                    .doc(cardId)
                                                    .get();

                                                final data = doc.data();

                                                kaartDetails.add({
                                                  'image':
                                                  (data?['imageUrl']
                                                  as String?) ??
                                                      'assets/images/interventie_placeholder.png',
                                                  'label':
                                                  (data?['title']
                                                  as String?) ??
                                                      cardId,
                                                });
                                              }

                                              if (lobbyId != null) {
                                                final lobbyRef =
                                                FirebaseFirestore.instance
                                                    .collection('lobbies')
                                                    .doc(lobbyId);

                                                final lobbySnap =
                                                await lobbyRef.get();

                                                final currentIds = lobbySnap
                                                    .data()?[
                                                'interventionCardIds'] ??
                                                    [];

                                                final updatedIds = {
                                                  ...currentIds.map(
                                                          (id) => id.toString()),
                                                  ...cardIds,
                                                };

                                                await lobbyRef.update({
                                                  'interventionCardIds':
                                                  updatedIds.toList(),
                                                });

                                                final refreshedSnap =
                                                await lobbyRef.get();

                                                final refreshedIds = refreshedSnap
                                                    .data()?[
                                                'interventionCardIds'] ??
                                                    [];

                                                if (!mounted) return;

                                                setState(() {
                                                  _uniqueInterventionCount =
                                                      refreshedIds.length;
                                                  _showInterventionCards = true;
                                                  _interventionCardData =
                                                      StoryCardData(
                                                        id: 'intervention_cards',
                                                        cardNumber:
                                                        choice.nextCardId,
                                                        storyTag: '',
                                                        storySubtitle:
                                                        'INTERVENTIEKAARTEN',
                                                        cardLabel:
                                                        'INTERVENTIEKAARTEN',
                                                        timeLimit: 0,
                                                        imageAsset: '',
                                                        textTitle:
                                                        'Deze interventiekaarten horen bij deze keuze, leg ze op het bord:',
                                                        textPages: cardIds,
                                                        choices: const [],
                                                      );
                                                  _interventionCardDetails =
                                                      kaartDetails;
                                                });
                                              } else {
                                                if (!mounted) return;

                                                setState(() {
                                                  _uniqueInterventionCount +=
                                                      cardIds.length;
                                                  _showInterventionCards = true;
                                                  _interventionCardData =
                                                      StoryCardData(
                                                        id: 'intervention_cards',
                                                        cardNumber:
                                                        choice.nextCardId,
                                                        storyTag: '',
                                                        storySubtitle:
                                                        'INTERVENTIEKAARTEN',
                                                        cardLabel:
                                                        'INTERVENTIEKAARTEN',
                                                        timeLimit: 0,
                                                        imageAsset: '',
                                                        textTitle:
                                                        'Deze interventiekaarten horen bij deze keuze, leg ze op het bord:',
                                                        textPages: cardIds,
                                                        choices: const [],
                                                      );
                                                  _interventionCardDetails =
                                                      kaartDetails;
                                                });
                                              }
                                            } else {
                                              if (lobbyId != null) {
                                                await FirebaseFirestore.instance
                                                    .collection('lobbies')
                                                    .doc(lobbyId)
                                                    .update({
                                                  'currentScenarioId':
                                                  choice.nextCardId,
                                                });
                                              } else {
                                                await _loadScenario(
                                                    choice.nextCardId);
                                              }
                                            }
                                          } else if (!isHost) {
                                            setState(() {
                                              _choicesLocked = true;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IgnorePointer(
                        ignoring: !_showInterventionCards,
                        child: AnimatedOpacity(
                          opacity: _showInterventionCards ? 1 : 0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          child: AnimatedSlide(
                            offset: _showInterventionCards
                                ? Offset.zero
                                : const Offset(0, 0.15),
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeOut,
                            child: _interventionCardData != null
                                ? InterventionCard(
                              subtitle:
                              _interventionCardData!.storySubtitle,
                              title: _interventionCardData!.textTitle,
                              kaartDetails: _interventionCardDetails,
                              onContinue: () async {
                                final nextCardId =
                                    _interventionCardData?.cardNumber;

                                setState(() {
                                  _showInterventionCards = false;
                                });

                                await Future.delayed(
                                  const Duration(milliseconds: 450),
                                );

                                if (isHost &&
                                    nextCardId != null &&
                                    nextCardId.isNotEmpty) {
                                  if (lobbyId != null) {
                                    await FirebaseFirestore.instance
                                        .collection('lobbies')
                                        .doc(lobbyId)
                                        .update({
                                      'currentScenarioId': nextCardId,
                                    });
                                  } else {
                                    await _loadScenario(nextCardId);
                                  }
                                }
                              },
                            )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}