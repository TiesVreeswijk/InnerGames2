import '../models/game_models.dart';

class GameData {
  static GameStory getSkateparkStory() {
    return GameStory(
      id: 'skatepark',
      title: 'HET SKATEPARK',
      subtitle: '1ST STORY',
      imagePath: 'assets/images/skatepark_story.jpg',
      cardNumber: 1,
      cards: [
        // Introduction card - Start
        GameCard(
          id: 'intro_start',
          cardCode: 'START',
          title: 'HET SKATEPARK: DE START',
          description: 
              'Vroeger hielp de gepensioneerde meester van de basisschool als burg tussen de jongeren en buurt, maar sinds zijn overlijden is dat contact verslechterd. Om wonenden durven de jongeren niet goed aan te spreken op hun gedrag. De gemeente neemt de wens van de jongeren serieus, maar wil eerst weten of er genoeg steun is vanuit de buurt.',
          type: CardType.intro,
          imagePath: 'assets/images/skatepark_story.png',
        ),
        
        // Card 1A - Begin bij de jongeren
        GameCard(
          id: 'card_1a',
          cardCode: '1A',
          title: 'BEGIN BIJ DE JONGEREN',
          description:
              'Jouw keuze gaat over Sociale Inclusie, het is formeel en collectief. Lees deze drie interventiekaarten en leg ze op het spelbord. Zet je pion op vakje 1.',
          type: CardType.intro,
        ),
        
        GameCard(
          id: 'card_1a_detail',
          cardCode: '1A',
          title: 'BEGIN BIJ DE JONGEREN',
          description:
              'Je richt je eerst op de jongeren. Je vindt dat er gesprekken moeten zijn om te horen wat er volgens hen nodig is in de wijk.',
          type: CardType.intro,
        ),

        // Show intervention cards for 1A
        GameCard(
          id: 'card_1a_interventions',
          cardCode: '1A',
          title: 'BEGIN BIJ DE JONGEREN',
          description: 'Interventiekaarten',
          type: CardType.intro,
        ),

        // Decision point after 1A intro
        GameCard(
          id: 'decision_1a',
          cardCode: '1A',
          title: 'HET SKATEPARK: DE START',
          description:
              'Vroeger hielp de gepensioneerde meester van de basisschool als burg tussen de jongeren en buurt, maar sinds zijn overlijden is dat contact verslechterd. Om wonenden durven de jongeren niet goed aan te spreken op hun gedrag. De gemeente neemt de wens van de jongeren serieus, maar wil eerst weten of er genoeg steun is vanuit de buurt.',
          type: CardType.decision,
          choices: [
            GameChoice(
              id: 'choice_1a_talk',
              text: 'Je richt je eerst op gesprekken met de jongeren. Speel kaart 1A.',
              nextCardId: 'card_1a',
              isCorrect: true,
              points: 4,
            ),
            GameChoice(
              id: 'choice_1a_support',
              text: 'Je gaat voor draagvlak en richt je op het verzet in de buurt. Speel kaart 1B.',
              nextCardId: 'card_1b',
              isCorrect: false,
              points: 2,
            ),
          ],
        ),

        // Card 1B - Begin bij de inwoners
        GameCard(
          id: 'card_1b',
          cardCode: '1B',
          title: 'BEGIN BIJ DE INWONERS',
          description:
              'Jouw keuze gaat over Sociale Cohesie, het is formeel en collectief. Lees deze drie interventiekaarten en leg ze op het spelbord. Zet je pion op vakje 1.',
          type: CardType.intro,
        ),

        GameCard(
          id: 'card_1b_detail',
          cardCode: '1B',
          title: 'BEGIN BIJ DE INWONERS',
          description:
              'Jij gaat in op de weerstand in de buurt, je vindt dat er gesprekken moeten zijn met de inwoners. Niet om te overtuigen, maar om echt te luisteren.',
          type: CardType.intro,
        ),

        // Show intervention cards for 1B
        GameCard(
          id: 'card_1b_interventions',
          cardCode: '1B',
          title: 'BEGIN BIJ DE INWONERS',
          description: 'Interventiekaarten',
          type: CardType.intro,
        ),

        // Decision point - organise meeting or individual talks
        GameCard(
          id: 'decision_1b',
          cardCode: '1B',
          title: 'BEGIN BIJ DE INWONERS',
          description:
              'Jij gaat in op de weerstand in de buurt, je vindt dat er gesprekken moeten zijn met de inwoners. Niet om te overtuigen, maar om echt te luisteren.',
          type: CardType.decision,
          choices: [
            GameChoice(
              id: 'choice_1b_meeting',
              text: 'Je organiseert een open inwonersavond voor de hele wijk. Speel kaart 2C.',
              nextCardId: 'card_2c',
              isCorrect: true,
              points: 4,
            ),
            GameChoice(
              id: 'choice_1b_individual',
              text: 'Je gaat de straat op en praat individueel met de inwoners om te horen wat er leeft. Speel kaart 2D.',
              nextCardId: 'card_2d',
              isCorrect: false,
              points: 2,
            ),
          ],
        ),

        // Question card - Why your choice?
        GameCard(
          id: 'question_why',
          cardCode: '?',
          title: 'Waarom jouw keuze?',
          description: '',
          type: CardType.question,
        ),

        // Situation intro - Skatepark expansion
        GameCard(
          id: 'situation_intro',
          cardCode: 'START',
          title: 'HET SKATEPARK: DE START',
          description:
              'Jongeren in een middelgroot dorp willen hun skatebaan uitbreiden met een overkapping en bankjes. De baan aan velden. Het is een populaire hangplek. Dat zorgt soms voor overlast door brommers, harde muziek en af en toe signalen van drugsgebruik of - dealen',
          type: CardType.intro,
          imagePath: 'assets/images/skatepark_situation.jpg',
        ),
      ],
    );
  }

  // Method to get card by ID - will be used with backend
  static GameCard? getCardById(String storyId, String cardId) {
    if (storyId == 'skatepark') {
      final story = getSkateparkStory();
      try {
        return story.cards.firstWhere((card) => card.id == cardId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
