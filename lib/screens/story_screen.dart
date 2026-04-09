import 'package:flutter/material.dart';
import '../widgets/story_card.dart';
import '../widgets/choice_card.dart';
import '../models/story_card_data.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key); //keeping the constructor simple for now, until we know what data we need to pass in

  // fake data for now, until we have the backend hooked up
  static const _fakeCard = StoryCardData(
    id: '1',
    cardNumber: '1',
    storyTag: '1ˢᵀ STORY',
    storySubtitle: 'HET SKATEPARK',
    cardLabel: 'SPELKAART',
    timeLimit: 30,
    imageAsset: 'assets/images/skatepark_story.png',
    textTitle: 'HET SKATEPARK:\nDE START',
    textPages: [
      'Jongeren in een middelgroot drop willen hun skatebaan uitbreiden met een '
      'overkapping en bankjes. De baan is een populaire hangplek. Dat zorgt soms '
      'voor overlast door brommers, harde muziek en af en toe signalen van '
      'drugsgebruik of -dealen.',
      'Vroeger hielp de gepensioneerde meester van de basisschool als brug '
      'tussen jongeren en buurt, maar sinds zijn overlijden is dat contact '
      'verslechterd. Omwonenden durven de jongeren niet goed aan te spreken op '
      'hun gedrag. De gemeente neemt de wens van de jongeren serieus, maar wil '
      'eerst weten of er genoeg steun is vanuit de buurt.',
    ],
    choices: [
      ChoiceData(
        text: 'Je richt je eerst op gesprekken met de jongeren. Speel kaart 1A.',
        nextCardId: '1A',
      ),
      ChoiceData(
        text: 'Je gaat voor draagvlak en richt je op het verzet in de buurt. Speel kaart 1B.',
        nextCardId: '1B',
      ),
    ],
  );

  @override
  State<StoryScreen> createState() => _StoryScreenState(); // makes the stateful widget work, allowing us to update the UI when the timer finishes and locks the choices
}

class _StoryScreenState extends State<StoryScreen> { // this state will manage the timer and choice locking for the current story card
  bool _choicesLocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold( // column layout
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // make children take full width
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: StoryCard(
                  data: StoryScreen._fakeCard, // pass the fake data to the story card, need to update this once we have real data coming in from the backend
                  onTimerFinished: () {
                    if (!mounted) { // check if the widget is still in the widget tree before trying to update state
                      return;
                    }
                    setState(() => _choicesLocked = true);
                  },
                ),
              ),
            ),
            const SizedBox(height: 35),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ChoiceCard(
                  choices: StoryScreen._fakeCard.choices, // pass the choices from the fake data to the choice card, need to update this once we have real data coming in from the backend
                  isLocked: _choicesLocked,
                  onChoiceSelected: (choice) {
                    // TODO: navigate to next card based on choice.nextCardId
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}