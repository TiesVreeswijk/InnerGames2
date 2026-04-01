import 'package:flutter/material.dart';
import '../models/story_card_data.dart';

class ChoiceCard extends StatefulWidget {
  final List<ChoiceData> choices; // in the future from the database
  final void Function(ChoiceData choice)? onChoiceSelected;
  final bool isLocked;

  const ChoiceCard({ // initial data for choice card
    Key? key,
    required this.choices, // this will be passed in from the parent widget
    this.onChoiceSelected, // this callback will be called when a choice is selected, passing the selected choice data back to the parent widget
    this.isLocked = false,
  }) : super(key: key);

  @override
  State<ChoiceCard> createState() => _ChoiceCardState(); // makes the stateful widget work, allowing us to update the UI when a choice is selected and to disable choices when the timer finishes
}

class _ChoiceCardState extends State<ChoiceCard> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // make the card take the full width of its parent
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
          const Text(
            'Wat doe je?',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.choices.asMap().entries.map( // create a button for each choice, using the index to determine if it's selected and to pass the correct choice data back to the parent widget when tapped
            (entry) => _ChoiceButton(
              choice: entry.value,
              selected: _selectedIndex == entry.key,
              isLocked: widget.isLocked,
              onTap: () {
                if (widget.isLocked) {
                  return;
                }
                setState(() => _selectedIndex = entry.key);
                widget.onChoiceSelected?.call(entry.value);
              },
            ),
          ),
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

  const _ChoiceButton({
    required this.choice,
    required this.selected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
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