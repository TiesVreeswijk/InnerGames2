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
    // Controleer op eindantwoord zonder nextScenarioId en toon joker dialog na 5 seconden als er nog levens zijn
    void _checkEndScenarioAndShowJoker() async {
      // Vind of er een gekozen antwoord is zonder nextScenarioId
      final selected = _confirmedIndex;
      if (selected == null) return;
      final choice = widget.choices[selected];
      // Alleen host mag de joker dialog zien
      if (!widget.isHost) return;
      // Controleer of het een eindantwoord is
      if (choice.nextCardId.isEmpty && widget.lostLifes < 3) {
        // Wacht 5 seconden
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
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Joker inzetten'),
        content: const Text('Wil je deze joker inzetten om een scenario opnieuw te beantwoorden?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _showScenarioSelectSheet();
                }
              });
            },
            child: const Text('Ja, joker inzetten'),
          ),
        ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                                separatorBuilder: (context, i) => const Divider(height: 1),
                                itemBuilder: (context, i) {
                                  final scenario = widget.allScenarios[i];
                                  final scenarioTitle = scenario.title.trim().isEmpty
                                      ? scenario.text.trim()
                                      : scenario.title.trim();
                                  final isSelected = selectedScenarioId == scenario.id;

                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () async {
                                        setModalState(() {
                                          selectedScenarioId = scenario.id;
                                        });

                                        await Future.delayed(const Duration(milliseconds: 180));
                                        if (!mounted) return;

                                        Navigator.of(context).pop();
                                        setState(() {
                                          if (_jokersLeft > 0) _jokersLeft--;
                                        });
                                        // Roep de parent callback aan zodat StoryScreen het scenario kan wisselen
                                        if (widget.onChoiceSelected != null) {
                                          final choice = widget.choices.firstWhere(
                                            (c) => c.nextCardId == scenario.id,
                                            orElse: () => ChoiceData(text: scenarioTitle, nextCardId: scenario.id),
                                          );
                                          widget.onChoiceSelected!(choice);
                                        }
                                        // Controleer of het gekozen scenario een eindscenario is (alle antwoorden hebben lege nextScenarioId)
                                        final isEndScenario = scenario.answers.isNotEmpty && scenario.answers.every((a) => a.nextScenarioId == null);
                                        if (isEndScenario && widget.onLostLifesChanged != null) {
                                          widget.onLostLifesChanged!(widget.lostLifes + 1);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        child: Text(
                                          scenarioTitle,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
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
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
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