import 'package:flutter/material.dart';
import '../widgets/story_card.dart';
import '../widgets/choice_card.dart';
import '../services/lobby_service.dart';
import '../models/scenario_data.dart';
import '../models/story_card_data.dart';
import '../services/scenario_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/intervention_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

// the state of the StoryScreen
class _StoryScreenState extends State<StoryScreen> {
  bool _choicesLocked = false;
  ScenarioData? _scenario;
  final LobbyService _lobbyService = LobbyService();
  final ScenarioService _scenarioService = ScenarioService();
  String _currentScenarioId = 'scenario_1';
  late Future<void> _gameFuture;
  StreamSubscription? _lobbyStatusSubscription;
  int _choiceClickCount = 0;
  String? _lastChoiceId;

  // for the intervention cards
  bool _showInterventionCards = false;
  StoryCardData? _interventionCardData;
  List<Map<String, String>> _interventionCardDetails = [];

  @override
  void initState() {
    super.initState();
    _gameFuture = _loadScenario(_currentScenarioId);

    // Firestore listener for scenario synchronization
    // Retrieve lobbyId from ModalRoute arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final lobbyId = args != null ? args['lobbyId'] : null;
      if (lobbyId != null) {
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        _lobbyStatusSubscription = _firestore.collection('lobbies').doc(lobbyId).snapshots().listen((snapshot) async {
          final data = snapshot.data();
          if (data != null && data['currentScenarioId'] != null && data['currentScenarioId'] != _currentScenarioId) {
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

  Future<void> _loadScenario(String scenarioId) async {
    final scenario = await _scenarioService.getScenario(scenarioId);
    if (scenario == null) throw Exception('No scenario found for id: $scenarioId');
    setState(() {
      _scenario = scenario;
      _choicesLocked = false;
      _currentScenarioId = scenarioId;
    });
    print('Nieuw scenario geladen: $_currentScenarioId');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('StoryScreen arguments: $args');
    return FutureBuilder<void>(
      future: _gameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Fout bij laden van game:\n${snapshot.error}')),
          );
        }
        if (_scenario == null) {
          return const Scaffold(
            body: Center(child: Text('No scenario found')),
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
              .map((a) => ChoiceData(text: a.text, nextCardId: a.nextScenarioId ?? ''))
              .toList(),
        );

      return Scaffold(
  backgroundColor: const Color(0xFFF7F7F7),

  body: Stack(
    alignment: Alignment.center,
    children: [

      // Background logo
      Opacity(
        opacity: 0.1,
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),

      SafeArea(
        child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: AnimatedSlide(
                        offset: _showInterventionCards ? const Offset(0, -1.25) : Offset.zero,
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                          child: StoryCard(
                            key: ValueKey(_currentScenarioId),
                            data: storyCardData,
                            
                            onTimerFinished: () {
                              if (!mounted) return;
                              setState(() => _choicesLocked = true);
                              
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Expanded(
                      flex: 2,
                      child: AnimatedSlide(
                        offset: _showInterventionCards ? const Offset(0, 1.25) : Offset.zero,
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ChoiceCard(
                            choices: storyCardData.choices,
                            isLocked: _choicesLocked || _showInterventionCards,
                            onChoiceSelected: (choice) async {
                              final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                              final isHost = args?['isHost'] == true;
                              final lobbyId = args != null ? args['lobbyId'] : null;

                              // Dubbelklik detectie per keuze
                              if (_lastChoiceId == choice.nextCardId) {
                                _choiceClickCount++;
                              } else {
                                _choiceClickCount = 1;
                                _lastChoiceId = choice.nextCardId;
                              }

                              if (_choiceClickCount == 2) {
                                if (isHost && choice.nextCardId.isNotEmpty) {
                                  // Zoek de gekozen answer op basis van nextCardId
                                  final answer = _scenario?.answers.firstWhere(
                                    (a) => a.nextScenarioId == choice.nextCardId,
                                    orElse: () => AnswerData(id: '', text: ''),
                                  );
                                  final cardIds = answer?.cardIds ?? [];
                                  if (cardIds.isNotEmpty) {
                                    // retreive card details for each cardId from Firestore
                                    List<Map<String, String>> kaartDetails = [];
                                    for (final cardId in cardIds) {
                                      final doc = await FirebaseFirestore.instance
                                          .collection('collectibleSituationCards')
                                          .doc(cardId)
                                          .get();
                                      final data = doc.data();
                                      kaartDetails.add({
                                        'image': (data?['imageUrl'] as String?) ?? 'assets/images/interventie_placeholder.png',
                                        'label': (data?['title'] as String?) ?? cardId,
                                      });
                                    }
                                    setState(() {
                                      _showInterventionCards = true;
                                      _interventionCardData = StoryCardData(
                                        id: 'intervention_cards',
                                        cardNumber: choice.nextCardId ?? '',
                                        storyTag: '',
                                        storySubtitle: 'INTERVENTIEKAARTEN',
                                        cardLabel: 'INTERVENTIEKAARTEN',
                                        timeLimit: 0,
                                        imageAsset: '',
                                        textTitle: 'Deze interventiekaarten horen bij deze keuze, leg ze op het bord:',
                                        textPages: cardIds,
                                        choices: const [],
                                      );
                                      _interventionCardDetails = kaartDetails;
                                    });
                                  } else {
                                    if (lobbyId != null) {
                                      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                                      await _firestore.collection('lobbies').doc(lobbyId).update({
                                        'currentScenarioId': choice.nextCardId,
                                      });
                                    } else {
                                      await _loadScenario(choice.nextCardId);
                                    }
                                  }
                                } else if (!isHost) {
                                  setState(() {
                                    _choicesLocked = true;
                                  });
                                }
                              }
                            },
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
                      offset: _showInterventionCards ? Offset.zero : const Offset(0, 0.15),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOut,
                      child: _interventionCardData != null
                          ? InterventionCard(
                              subtitle: _interventionCardData!.storySubtitle,
                              title: _interventionCardData!.textTitle,
                              kaartDetails: _interventionCardDetails,
                              onContinue: () async {
                                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                                final isHost = args?['isHost'] == true;
                                final lobbyId = args != null ? args['lobbyId'] : null;
                                final nextCardId = _interventionCardData?.cardNumber;
                                setState(() {
                                  _showInterventionCards = false;
                                });
                                await Future.delayed(const Duration(milliseconds: 450));
                                if (isHost == true && nextCardId != null && nextCardId.isNotEmpty) {
                                  if (lobbyId != null) {
                                    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                                    await _firestore.collection('lobbies').doc(lobbyId).update({
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
    );
  }
}