import '../models/game_models.dart';

/// Complete Skatepark Story with ALL cards
class CompleteGameData {
  
  /// Get complete skatepark story with all 68 cards
  static GameStory getCompleteSkateparkStory() {
    return GameStory(
      id: 'skatepark_complete',
      title: 'HET SKATEPARK',
      subtitle: '1ST STORY',
      imagePath: 'assets/images/skatepark_story.jpg',
      cardNumber: 1,
      cards: _getAllCards(),
    );
  }

  static List<GameCard> _getAllCards() {
    return [
      // Main story cards (01-03)
      _createCard('01', '1ST STORY\nHET SKATEPARK\n\nSPELKAART 1', 
        'Story introduction card with background image', CardType.intro),
      _createCard('02', 'HET SKATEPARK: DE START', 
        'Vroeger hielp de gepensioneerde meester...', CardType.intro),
      _createCard('03', 'HET SKATEPARK: DE START',
        'Jongeren in een middelgroot dorp willen hun skatebaan uitbreiden...',  CardType.intro),
      
      // Card 1B variations
      _createCard('1b', 'BEGIN BIJ DE INWONERS',
        'Jouw keuze gaat over Sociale Cohesie...', CardType.intro),
      _createCard('1b1', 'BEGIN BIJ DE INWONERS', 
        'Jij gaat in op de weerstand in de buurt...', CardType.intro),
      _createCard('1b2', 'BEGIN BIJ DE INWONERS',
        'Je organiseert gesprekken met inwoners...', CardType.intro),
      
      // Direction/Richting cards
      _createCard('richting', 'KIES JE RICHTING',
        'Welke aanpak kies je?', CardType.decision),
      _createCard('richting1', 'RICHTING 1', 
        'Focus op de jongeren', CardType.decision),
      _createCard('richting2', 'RICHTING 2',
        'Focus op de buurt', CardType.decision),
      _createCard('richting_1a', 'RICHTING 1A',
        'Begin bij de jongeren', CardType.decision),
      _createCard('richting_1a1', 'RICHTING 1A - DEEL 1',
        'Eerste gesprekken met jongeren', CardType.decision),
      _createCard('richting_1a2', 'RICHTING 1A - DEEL 2', 
        'Vervolg gesprekken', CardType.decision),
      
      // Numbered cards 48-59
      _createCard('48', 'KAART 48', 'Story progression', CardType.intro),
      _createCard('49', 'KAART 49', 'Story progression', CardType.intro),
      _createCard('50', 'KAART 50', 'Story progression', CardType.intro),
      _createCard('51', 'KAART 51', 'Story progression', CardType.intro),
      _createCard('52', 'KAART 52', 'Story progression', CardType.intro),
      _createCard('53', 'KAART 53', 'Story progression', CardType.intro),
      _createCard('54', 'KAART 54', 'Story progression', CardType.intro),
      _createCard('55', 'KAART 55', 'Story progression', CardType.intro),
      _createCard('56', 'KAART 56', 'Story progression', CardType.intro),
      _createCard('57', 'KAART 57', 'Story progression', CardType.intro),
      _createCard('58', 'KAART 58', 'Story progression', CardType.intro),
      _createCard('59', 'KAART 59', 'Story progression', CardType.intro),
      
      // Answer cards (1-15)
      ..._createAnswerCards(),
      
      // Empty cards (1-15)
      ..._createEmptyCards(),
      
      // Error cards (1-15)
      ..._createErrorCards(),
    ];
  }

  static GameCard _createCard(String id, String title, String description, CardType type) {
    return GameCard(
      id: 'card_$id',
      cardCode: id,
      title: title,
      description: description,
      type: type,
      imagePath: 'assets/images/screens/skatepark_kaart_$id.png',
    );
  }

  static List<GameCard> _createAnswerCards() {
    List<GameCard> cards = [];
    
    // Cards with special naming (1, 02, 03, 4-15)
    cards.add(_createAnswerCard('1', 'ANTWOORD 1'));
    cards.add(_createAnswerCard('02', 'ANTWOORD 2'));
    cards.add(_createAnswerCard('03', 'ANTWOORD 3'));
    
    for (int i = 4; i <= 15; i++) {
      cards.add(_createAnswerCard(i.toString(), 'ANTWOORD $i'));
    }
    
    return cards;
  }

  static GameCard _createAnswerCard(String num, String title) {
    return GameCard(
      id: 'answer_$num',
      cardCode: 'A$num',
      title: title,
      description: 'Correct answer revealed',
      type: CardType.outcome,
      imagePath: 'assets/images/screens/skatepark_kaart_antwoord_$num.png',
      choices: [], // Answers shown, no more choices
    );
  }

  static List<GameCard> _createEmptyCards() {
    List<GameCard> cards = [];
    
    cards.add(_createEmptyCard('01', 'VRAAG 1'));
    cards.add(_createEmptyCard('02', 'VRAAG 2'));
    cards.add(_createEmptyCard('03', 'VRAAG 3'));
    
    for (int i = 4; i <= 15; i++) {
      cards.add(_createEmptyCard(i.toString(), 'VRAAG $i'));
    }
    
    return cards;
  }

  static GameCard _createEmptyCard(String num, String title) {
    return GameCard(
      id: 'empty_$num',
      cardCode: 'E$num',
      title: title,
      description: 'Waiting for votes...',
      type: CardType.decision,
      imagePath: 'assets/images/screens/skatepark_kaart_leeg_$num.png',
      choices: _getChoicesForCard(num),
    );
  }

  static List<GameCard> _createErrorCards() {
    List<GameCard> cards = [];
    
    cards.add(_createErrorCard('01', 'FOUT 1'));
    cards.add(_createErrorCard('02', 'FOUT 2'));
    cards.add(_createErrorCard('03', 'FOUT 3'));
    
    for (int i = 4; i <= 15; i++) {
      cards.add(_createErrorCard(i.toString(), 'FOUT $i'));
    }
    
    return cards;
  }

  static GameCard _createErrorCard(String num, String title) {
    return GameCard(
      id: 'error_$num',
      cardCode: 'F$num',
      title: title,
      description: 'Wrong answer - educational feedback',
      type: CardType.outcome,
      imagePath: 'assets/images/screens/skatepark_kaart_fout_$num.png',
      choices: [],
    );
  }

  static List<GameChoice> _getChoicesForCard(String cardNum) {
    // Default choices - customize per card as needed
    return [
      GameChoice(
        id: 'choice_${cardNum}_a',
        text: 'Je richt je eerst op gesprekken met de jongeren. Speel kaart 1A.',
        nextCardId: 'answer_$cardNum',
        isCorrect: true,
        points: 4,
      ),
      GameChoice(
        id: 'choice_${cardNum}_b',
        text: 'Je gaat voor draagvlak en richt je op het verzet in de buurt. Speel kaart 1B.',
        nextCardId: 'error_$cardNum',
        isCorrect: false,
        points: 2,
      ),
    ];
  }

  /// Get card by ID
  static GameCard? getCardById(String cardId) {
    try {
      return _getAllCards().firstWhere((card) => card.id == cardId);
    } catch (e) {
      return null;
    }
  }

  /// Get all card IDs
  static List<String> getAllCardIds() {
    return _getAllCards().map((card) => card.id).toList();
  }
}
