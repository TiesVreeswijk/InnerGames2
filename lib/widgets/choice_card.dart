import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/story_card_data.dart';
import '../models/scenario_data.dart';
import '../models/lobby/lobby_player.dart';

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

  // ── Voting ──────────────────────────────────────────────────────────────
  /// Id of the scenario these choices belong to. Used to reset the local
  /// selection whenever the scenario changes.
  final String? scenarioId;

  /// When true, tapping an option casts a (re-)vote instead of immediately
  /// advancing. The host additionally gets a "make final" button. Disabled in
  /// the single-device/legacy flow (no lobby).
  final bool votingEnabled;

  /// Uid of the current user — used to highlight the player's own avatar.
  final String? currentUid;

  /// Option index -> the players who voted for it. Drives the avatar badges.
  final Map<int, List<LobbyPlayer>> votersByOption;

  /// Called when a player taps an option to cast or change their vote.
  final void Function(int index)? onVote;

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
    this.scenarioId,
    this.votingEnabled = false,
    this.currentUid,
    this.votersByOption = const {},
    this.onVote,
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
    if (choice.nextCardId.isEmpty && widget.lostLifes < 3 && _jokersLeft > 0) {
      // Wacht 1 seconde
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && widget.lostLifes < 3 && _jokersLeft > 0) {
        _showJokerDialog();
      }
    }
  }

  int _jokersLeft = 2;
  int? _selectedIndex;
  int? _confirmedIndex;
  bool _wasEndScenario = false;

  // GlobalKeys to locate each heart on screen for the overlay animation
  final List<GlobalKey> _heartKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  OverlayEntry? _heartOverlayEntry;

  bool get _isEndScenario {
    return widget.choices.isNotEmpty &&
        widget.choices.every((c) => c.nextCardId.isEmpty);
  }

  @override
  void didUpdateWidget(covariant ChoiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When a life is lost, play the break animation above all widgets via Overlay
    if (widget.lostLifes > oldWidget.lostLifes) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _playHeartBreakOverlay(widget.lostLifes - 1);
        }
      });
    }
    // A new scenario was loaded — drop any stale local selection so the new
    // options start unselected for this client.
    if (widget.scenarioId != oldWidget.scenarioId) {
      _selectedIndex = null;
      _confirmedIndex = null;
    }
  }

  void _playHeartBreakOverlay(int heartIndex) {
    final key = _heartKeys[heartIndex];
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    // Get the screen-space center of the heart icon
    final position = box.localToGlobal(box.size.center(Offset.zero));

    _heartOverlayEntry?.remove();
    _heartOverlayEntry = OverlayEntry(
      builder: (_) => HeartBreakOverlay(
        position: position,
        onDone: () {
          _heartOverlayEntry?.remove();
          _heartOverlayEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_heartOverlayEntry!);
  }

  @override
  void dispose() {
    // Clean up any active overlay when widget is removed
    _heartOverlayEntry?.remove();
    _heartOverlayEntry = null;
    super.dispose();
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
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      isScrollControlled: true,
      builder: (context) {
        String? selectedScenarioId;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final mediaQuery = MediaQuery.of(context);
            final double screenHeight = mediaQuery.size.height;
            final double sheetHeight = screenHeight * 0.72;

            return SafeArea(
              child: SizedBox(
                height: screenHeight,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: sheetHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 18, 14, 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Kies een scenario om\nopnieuw te beantwoorden:',
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.05,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFE4007D),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: widget.allScenarios.length,
                                separatorBuilder: (context, i) =>
                                const Divider(height: 1),
                                itemBuilder: (context, i) {
                                  final scenario = widget.allScenarios[i];
                                  final scenarioTitle =
                                  scenario.title.trim().isEmpty
                                      ? scenario.text.trim()
                                      : scenario.title.trim();
                                  final isSelected =
                                      selectedScenarioId == scenario.id;

                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () async {
                                        setModalState(() {
                                          selectedScenarioId = scenario.id;
                                        });

                                        await Future.delayed(
                                            const Duration(milliseconds: 180));
                                        if (!mounted) return;

                                        Navigator.of(context).pop();
                                        setState(() {
                                          if (_jokersLeft > 0) _jokersLeft--;
                                        });
                                        // Roep de parent callback aan zodat StoryScreen het scenario kan wisselen
                                        if (widget.onChoiceSelected != null) {
                                          final choice =
                                          widget.choices.firstWhere(
                                                (c) => c.nextCardId == scenario.id,
                                            orElse: () => ChoiceData(
                                                text: scenarioTitle,
                                                nextCardId: scenario.id),
                                          );
                                          widget.onChoiceSelected!(choice);
                                        }
                                        // Controleer of het gekozen scenario een eindscenario is (alle antwoorden hebben lege nextScenarioId)
                                        final isEndScenario =
                                            scenario.answers.isNotEmpty &&
                                                scenario.answers.every((a) =>
                                                a.nextScenarioId == null);
                                        if (isEndScenario &&
                                            widget.onLostLifesChanged != null) {
                                          widget.onLostLifesChanged!(
                                              widget.lostLifes + 1);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 14),
                                        child: Text(
                                          scenarioTitle,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: isSelected
                                                ? FontWeight.w900
                                                : FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleChoiceTap(int index) {
    if (widget.isLocked) return;

    if (widget.votingEnabled) {
      // Multiplayer voting: every player (host included) taps to cast or
      // change their vote. Re-tapping a different option moves the vote.
      setState(() => _selectedIndex = index);
      widget.onVote?.call(index);
      return;
    }

    // Legacy single-device flow: first tap selects, second tap confirms.
    final choice = widget.choices[index];
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

  /// Host-only: lock in the currently selected option as the group's final
  /// answer and trigger the advance logic in StoryScreen.
  void _confirmHostChoice() {
    final index = _selectedIndex;
    if (index == null || widget.isLocked) return;
    setState(() => _confirmedIndex = index);
    widget.onChoiceSelected?.call(widget.choices[index]);
    _checkEndScenarioAndShowJoker();
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
    final double estimatedNeeded = reservedSpace +
        numChoices * (buttonHeight + buttonMargin) +
        bottomPadding;
    final double screenHeight = MediaQuery.of(context).size.height *
        0.48; // ongeveer flex:3 van het scherm

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
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              // Jokers zijn niet zichtbaar voor host of speler
              // (de functionaliteit blijft behouden, alleen de weergave is verwijderd)
              const SizedBox(width: 8),
              _LifeHeart(
                heartKey: _heartKeys[0],
                isLost: widget.lostLifes >= 1,
              ),
              const SizedBox(width: 8),
              _LifeHeart(
                heartKey: _heartKeys[1],
                isLost: widget.lostLifes >= 2,
              ),
              const SizedBox(width: 8),
              _LifeHeart(
                heartKey: _heartKeys[2],
                isLost: widget.lostLifes >= 3,
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 4),
          // Choices fill the available space (scroll if there isn't enough
          // room once avatar badges are added), with the host's confirm
          // button pinned underneath.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.choices.asMap().entries.map(
                        (entry) {
                      final index = entry.key;
                      final voters =
                          widget.votersByOption[index] ?? const <LobbyPlayer>[];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ChoiceButton(
                            choice: entry.value,
                            selected: _selectedIndex == index,
                            isLocked: widget.isLocked,
                            onTap: () => _handleChoiceTap(index),
                            bottomPadding: showBottomPadding ? 40 : 16,
                          ),
                          if (voters.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, bottom: 10, top: 2),
                              child: _VoterAvatars(
                                voters: voters,
                                currentUid: widget.currentUid,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  if (showBottomPadding) const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (widget.votingEnabled && widget.isHost) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedIndex == null || widget.isLocked)
                    ? null
                    : _confirmHostChoice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4007D),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  const Color(0xFFE4007D).withOpacity(0.35),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Maak keuze definitief',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

// HeartBreakOverlay — renders the full grow + break + empty animation
class HeartBreakOverlay extends StatefulWidget {
  final Offset position; // screen-space center of the heart icon
  final VoidCallback onDone;

  const HeartBreakOverlay({
    Key? key,
    required this.position,
    required this.onDone,
  }) : super(key: key);

  @override
  State<HeartBreakOverlay> createState() => _HeartBreakOverlayState();
}

class _HeartBreakOverlayState extends State<HeartBreakOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _animationRun = 0;

  static const _filledHeart = 'assets/images/lifes.png';
  static const _emptyHeart = 'assets/images/noLifes.png';
  static const _heartBreak = 'assets/images/hearbreake.gif';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4300),
    );
    _animationRun++;
    _controller.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _intervalValue(double start, double end, Curve curve) {
    final value = ((_controller.value - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(value);
  }

  @override
  Widget build(BuildContext context) {
    // Position the animation centered on the original heart icon's screen location
    return Positioned(
      left: widget.position.dx - 18, // 18 = half of 36px icon width
      top: widget.position.dy - 18,
      child: IgnorePointer(
        child: SizedBox(
          width: 36,
          height: 36,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final firstGrow = _intervalValue(0, 0.16, Curves.easeOutBack);
              final firstSettle = _intervalValue(0.16, 0.25, Curves.easeInOut);
              final secondGrow = _intervalValue(0.25, 0.38, Curves.easeOutBack);
              final fullOut = _intervalValue(0.42, 0.48, Curves.easeIn);
              final breakIn = _intervalValue(0.46, 0.52, Curves.easeOut);
              final breakOut = _intervalValue(0.92, 0.96, Curves.easeIn);
              final emptyIn = _intervalValue(0.94, 1, Curves.easeOutBack);

              final firstPulseScale = 1 + (3.2 * firstGrow);
              final settledScale = firstPulseScale - (0.75 * firstSettle);
              final fullScale = settledScale + (1.05 * secondGrow);
              final fullOpacity = (1 - fullOut).clamp(0.0, 1.0);
              final heartBreakOpacity =
              (breakIn * (1 - breakOut)).clamp(0.0, 1.0);
              final emptyOpacity = emptyIn.clamp(0.0, 1.0);

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (fullOpacity > 0)
                    Opacity(
                      opacity: fullOpacity,
                      child: Transform.scale(
                        alignment: Alignment.center,
                        scale: fullScale,
                        child: Image.asset(
                          _filledHeart,
                          width: 36,
                          height: 36,
                        ),
                      ),
                    ),
                  if (heartBreakOpacity > 0)
                    Opacity(
                      opacity: heartBreakOpacity,
                      child: Transform.scale(
                        alignment: Alignment.center,
                        scale: 4.7,
                        child: Image.asset(
                          _heartBreak,
                          key: ValueKey('heart-break-$_animationRun'),
                          width: 36,
                          height: 36,
                        ),
                      ),
                    ),
                  if (emptyOpacity > 0)
                    Opacity(
                      opacity: emptyOpacity,
                      child: Transform.scale(
                        alignment: Alignment.center,
                        scale: 1,
                        child: Image.asset(
                          _emptyHeart,
                          width: 36,
                          height: 36,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// _LifeHeart — now only renders the static heart icon (filled or empty).
// The growing/breaking animation is handled by HeartBreakOverlay instead,
// so it can render above all other widgets via the Overlay layer.
class _LifeHeart extends StatelessWidget {
  final bool isLost;
  final GlobalKey heartKey;

  static const _filledHeart = 'assets/images/lifes.png';
  static const _emptyHeart = 'assets/images/noLifes.png';

  const _LifeHeart({
    required this.isLost,
    required this.heartKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: heartKey,
      width: 36,
      height: 36,
      child: Image.asset(
        isLost ? _emptyHeart : _filledHeart,
        width: 36,
        height: 36,
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
                  final pulse =
                      (math.sin(_controller.value * math.pi * 10) + 1) / 2;
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
                  final t = Curves.elasticOut
                      .transform(_controller.value.clamp(0.0, 1.0));
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: _continueToScenarioSelect,
                                    child: const Text(
                                      'Ja, joker inzetten',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  final pulse = (math.sin(
                                      _controller.value * math.pi * 12) +
                                      1) /
                                      2;
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
        padding:
        EdgeInsets.fromLTRB(18, 16, 18, 16), // minder padding rondom tekst
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

/// Row of overlapping avatar badges shown beneath an option, one per player
/// who voted for it. The current user's badge is outlined in pink.
class _VoterAvatars extends StatelessWidget {
  final List<LobbyPlayer> voters;
  final String? currentUid;

  const _VoterAvatars({
    required this.voters,
    this.currentUid,
  });

  static const List<String> _defaultAvatars = [
    'assets/images/3d_avatar_1.png',
    'assets/images/3d_avatar_2.png',
    'assets/images/3d_avatar_3.png',
    'assets/images/3d_avatar_4.png',
    'assets/images/3d_avatar_5.png',
    'assets/images/3d_avatar_6.png',
    'assets/images/3d_avatar_7.png',
    'assets/images/3d_avatar_8.png',
    'assets/images/3d_avatar_9.png',
  ];

  String _assetFor(LobbyPlayer player) {
    final avatar = player.selectedAvatar;
    if (avatar != null && avatar >= 0 && avatar < _defaultAvatars.length) {
      return _defaultAvatars[avatar];
    }
    return _defaultAvatars[0];
  }

  @override
  Widget build(BuildContext context) {
    const double size = 28;
    return Wrap(
      spacing: -8, // negative spacing makes the badges overlap slightly
      runSpacing: 4,
      children: voters.map((player) {
        final bool isMe = currentUid != null && player.uid == currentUid;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: isMe ? const Color(0xFFE4007D) : Colors.white,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(_assetFor(player)),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}