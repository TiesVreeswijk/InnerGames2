// Game Story Model
class GameStory {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final int cardNumber;
  final List<GameCard> cards;

  GameStory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.cardNumber,
    required this.cards,
  });
}

// Game Card Model
class GameCard {
  final String id;
  final String cardCode; // e.g., "1A", "1B", "2A"
  final String title;
  final String description;
  final String? imagePath;
  final CardType type;
  final List<GameChoice>? choices;
  final int? timeLimit; // in seconds
  final String? correctChoiceId; // for scoring

  GameCard({
    required this.id,
    required this.cardCode,
    required this.title,
    required this.description,
    this.imagePath,
    required this.type,
    this.choices,
    this.timeLimit,
    this.correctChoiceId,
  });
}

enum CardType {
  intro,        // Introduction card
  decision,     // Decision card with choices
  outcome,      // Outcome card (result of choice)
  question,     // Question card (why your choice?)
}

// Game Choice Model
class GameChoice {
  final String id;
  final String text;
  final String nextCardId;
  final bool isCorrect;
  final int points;

  GameChoice({
    required this.id,
    required this.text,
    required this.nextCardId,
    this.isCorrect = false,
    this.points = 0,
  });
}

// Player Model
class Player {
  final String id;
  final String name;
  final bool isHost;
  final int score;
  final String? currentChoice;

  Player({
    required this.id,
    required this.name,
    this.isHost = false,
    this.score = 0,
    this.currentChoice,
  });

  Player copyWith({
    String? id,
    String? name,
    bool? isHost,
    int? score,
    String? currentChoice,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      isHost: isHost ?? this.isHost,
      score: score ?? this.score,
      currentChoice: currentChoice ?? this.currentChoice,
    );
  }
}

// Game Session Model
class GameSession {
  final String id;
  final String pinCode;
  final GameStory story;
  final List<Player> players;
  final String currentCardId;
  final GameStatus status;
  final Map<String, Map<String, int>> votingResults; // cardId -> choiceId -> count

  GameSession({
    required this.id,
    required this.pinCode,
    required this.story,
    required this.players,
    required this.currentCardId,
    required this.status,
    required this.votingResults,
  });

  GameSession copyWith({
    String? id,
    String? pinCode,
    GameStory? story,
    List<Player>? players,
    String? currentCardId,
    GameStatus? status,
    Map<String, Map<String, int>>? votingResults,
  }) {
    return GameSession(
      id: id ?? this.id,
      pinCode: pinCode ?? this.pinCode,
      story: story ?? this.story,
      players: players ?? this.players,
      currentCardId: currentCardId ?? this.currentCardId,
      status: status ?? this.status,
      votingResults: votingResults ?? this.votingResults,
    );
  }
}

enum GameStatus {
  waiting,    // Waiting for players
  playing,    // Game in progress
  voting,     // Players voting on choice
  results,    // Showing results
  completed,  // Game finished
}
