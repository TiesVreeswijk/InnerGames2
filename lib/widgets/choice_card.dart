import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/story_card_data.dart';
import '../models/scenario_data.dart';


class ChoiceCard extends StatefulWidget {
  final List<ChoiceData> choices;
  final void Function(ChoiceData choice)? onChoiceSelected;
  final bool isLocked;
  final bool isHost;
  final int uniqueInterventionCount;
  final int maxInterventionCards;
  final List<ScenarioData> allScenarios;
  final int lostLifes;
  final void Function(int newLostLifes)? onLostLifesChanged;

  const ChoiceCard({
    Key? key,
    required this.allScenarios,
    required this.choices,
    this.onChoiceSelected,
    this.isLocked = false,
    required this.isHost,
    this.uniqueInterventionCount = 0,
    this.maxInterventionCards = 8,
    this.lostLifes = 0,
    this.onLostLifesChanged,
  }) : super(key: key);

  @override
  State<ChoiceCard> createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  // Controleer op eindantwoord zonder nextCardId en toon joker dialog na 1 seconde als er nog levens zijn
  void _checkEndScenarioAndShowJoker() async {
    // Vind of er een gekozen antwoord is zonder nextScenarioId
    final selected = _confirmedIndex;
    if (selected == null) return;
    final choice = widget.choices[selected];
    // Alleen host mag de joker dialog zien
    if (!widget.isHost) return;
    // Controleer of het een eindantwoord is
    if (choice.nextCardId.isEmpty && widget.lostLifes < 3) {
      // Wacht even voordat de jumpscare verschijnt
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && widget.lostLifes < 3) {
        _showJokerDialog();
      }
    }
  }
  int _jokersLeft = 2;
  int? _selectedIndex;
  int? _confirmedIndex;
  bool _wasEndScenario = false;

  bool get _isEndScenario {
    return widget.choices.isNotEmpty &&
        widget.choices.every((c) => c.nextCardId.isEmpty);
  }

  void _showJokerDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => _JokerJumpscareDialog(
        onContinue: _showScenarioSelectSheet,
      ),
    );
  }

  void _showScenarioSelectSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Kies een scenario om opnieuw te beantwoorden:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: ListView.separated(
                    itemCount: widget.allScenarios.length,
                    separatorBuilder: (context, i) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final scenario = widget.allScenarios[i];
                      return ListTile(
                        title: Text(scenario.title),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            if (_jokersLeft > 0) _jokersLeft--;
                          });
                          // Roep de parent callback aan zodat StoryScreen het scenario kan wisselen
                          if (widget.onChoiceSelected != null) {
                            final choice = widget.choices.firstWhere(
                              (c) => c.nextCardId == scenario.id,
                              orElse: () => ChoiceData(text: scenario.title, nextCardId: scenario.id),
                            );
                            widget.onChoiceSelected!(choice);
                          }
                          // Controleer of het gekozen scenario een eindscenario is (alle antwoorden hebben lege nextScenarioId)
                          final isEndScenario = scenario.answers.isNotEmpty && scenario.answers.every((a) => a.nextScenarioId == null);
                          if (isEndScenario && widget.onLostLifesChanged != null) {
                            widget.onLostLifesChanged!(widget.lostLifes + 1);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleChoiceTap(int index) {
    final choice = widget.choices[index];
    if (widget.isLocked) return;
    if (_selectedIndex == index) {
      setState(() => _confirmedIndex = index);
      widget.onChoiceSelected?.call(choice);
      // Controleer na keuze of het een eindantwoord is en toon eventueel joker
      _checkEndScenarioAndShowJoker();
    } else {
      setState(() {
        _selectedIndex = index;
        _confirmedIndex = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Detecteer overgang naar eindscenario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isEndScenario && !_wasEndScenario) {
        if (widget.onLostLifesChanged != null) {
          widget.onLostLifesChanged!(widget.lostLifes + 1);
        }
        setState(() {
          _wasEndScenario = true;
        });
      } else if (!_isEndScenario && _wasEndScenario) {
        setState(() {
          _wasEndScenario = false;
        });
      }
    });
    // print('Aantal failedAttempts: \\${widget.failedAttempts}'); // Verwijderd
    // Bepaal of er genoeg ruimte is voor padding onderaan
    // 80 is een ruwe schatting van de totale vaste ruimte (titel, marges, etc)
    // 70 is de hoogte van een knop, 10 marge, 32 padding
    final double buttonHeight = 70;
    final double buttonMargin = 10;
    final double bottomPadding = 32;
    final double reservedSpace = 8 + 36 + 8 + 20 + 12 + 20; // title, image, etc
    final int numChoices = widget.choices.length;
    final double estimatedNeeded = reservedSpace + numChoices * (buttonHeight + buttonMargin) + bottomPadding;
    final double screenHeight = MediaQuery.of(context).size.height * 0.48; // ongeveer flex:3 van het scherm

    bool showBottomPadding = estimatedNeeded < screenHeight;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xBFDBDBDB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Wat doe je?',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Jokers zijn niet zichtbaar voor host of speler
              // (de functionaliteit blijft behouden, alleen de weergave is verwijderd)
              const SizedBox(width: 8),
              Image.asset(
                widget.lostLifes >= 1
                    ? 'assets/images/noLifes.png'
                    : 'assets/images/lifes.png',
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 8),
              Image.asset(
                widget.lostLifes >= 2
                    ? 'assets/images/noLifes.png'
                    : 'assets/images/lifes.png',
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 8),
              Image.asset(
                widget.lostLifes >= 3
                    ? 'assets/images/noLifes.png'
                    : 'assets/images/lifes.png',
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 4),
          // Geen scroll, alle antwoorden zichtbaar maken
          ...widget.choices.asMap().entries.map(
            (entry) => _ChoiceButton(
              choice: entry.value,
              selected: _selectedIndex == entry.key,
              isLocked: widget.isLocked,
              onTap: () => _handleChoiceTap(entry.key),
              bottomPadding: showBottomPadding ? 40 : 16,
            ),
          ),
          if (showBottomPadding) const SizedBox(height: 32), // extra padding onderaan alleen als er ruimte is
        ],
      ),
    );
  }
}

class _JokerJumpscareDialog extends StatefulWidget {
  final VoidCallback onContinue;

  const _JokerJumpscareDialog({required this.onContinue});

  @override
  State<_JokerJumpscareDialog> createState() => _JokerJumpscareDialogState();
}

class _JokerJumpscareDialogState extends State<_JokerJumpscareDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 420), () {
      if (mounted) {
        setState(() {
          _showActions = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continueToScenarioSelect() {
    Navigator.of(context).pop();
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        color: Colors.transparent,
        child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = Curves.easeOut.transform(_controller.value);
                final pulse = (math.sin(_controller.value * math.pi * 10) + 1) / 2;
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.red.withOpacity(0.16 + (0.2 * pulse)),
                        Colors.black.withOpacity(0.78 + (0.06 * t)),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = Curves.elasticOut.transform(_controller.value.clamp(0.0, 1.0));
                final shakeX = math.sin(_controller.value * 32) * (1.0 - t) * 14;
                final shakeY = math.cos(_controller.value * 25) * (1.0 - t) * 8;
                return Transform.translate(
                  offset: Offset(shakeX, shakeY),
                  child: Transform.scale(
                    scale: lerpDouble(0.55, 1.0, t) ?? 1.0,
                    child: child,
                  ),
                );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF180E1F),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFFF4040), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.55),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.35),
                        blurRadius: 80,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/joker.png',
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.red.withOpacity(0.28),
                                    Colors.red.withOpacity(0.68),
                                  ],
                                  stops: const [0.45, 0.78, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Joker verschijnt!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Kies een scenario om opnieuw te beantwoorden.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              opacity: _showActions ? 1 : 0,
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF4040),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: _continueToScenarioSelect,
                                  child: const Text(
                                    'Ja, joker inzetten',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                final pulse = (math.sin(_controller.value * math.pi * 12) + 1) / 2;
                                return Opacity(
                                  opacity: 0.45 + (0.55 * pulse),
                                  child: child,
                                );
                              },
                              child: const Text(
                                '!!!',
                                style: TextStyle(
                                  color: Color(0xFFFF3B3B),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final ChoiceData choice;
  final bool selected;
  final bool isLocked;
  final VoidCallback onTap;
  final double bottomPadding;

  const _ChoiceButton({
    required this.choice,
    required this.selected,
    required this.isLocked,
    required this.onTap,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.fromLTRB(18, 16, 18, 16), // minder padding rondom tekst
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF273583) : const Color(0xFF5F699F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          choice.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}