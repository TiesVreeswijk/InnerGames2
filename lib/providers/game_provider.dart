import 'package:flutter/foundation.dart';
import '../models/game_models.dart';
import '../data/game_data.dart';
import 'dart:math';

class GameProvider extends ChangeNotifier {
  GameSession? _currentSession;
  Player? _currentPlayer;

  GameSession? get currentSession => _currentSession;
  Player? get currentPlayer => _currentPlayer;
  bool get isHost => _currentPlayer?.isHost ?? false;

  // Create a new game session (Host)
  Future<GameSession> createGame(String storyId, String hostName) async {
    // Generate random PIN code
    final pinCode = _generatePinCode();
    
    // TODO: Replace with backend API call
    final story = GameData.getSkateparkStory();
    
    final host = Player(
      id: _generateId(),
      name: hostName,
      isHost: true,
    );

    _currentSession = GameSession(
      id: _generateId(),
      pinCode: pinCode,
      story: story,
      players: [host],
      currentCardId: story.cards.first.id,
      status: GameStatus.waiting,
      votingResults: {},
    );

    _currentPlayer = host;
    notifyListeners();
    
    return _currentSession!;
  }

  // Join existing game session (Participant)
  Future<bool> joinGame(String pinCode, String playerName) async {
    // TODO: Replace with backend API call to validate PIN and join
    // For now, simulate joining
    
    if (_currentSession == null || _currentSession!.pinCode != pinCode) {
      // In real implementation, fetch session from backend
      return false;
    }

    final newPlayer = Player(
      id: _generateId(),
      name: playerName,
      isHost: false,
    );

    _currentSession = _currentSession!.copyWith(
      players: [..._currentSession!.players, newPlayer],
    );
    
    _currentPlayer = newPlayer;
    notifyListeners();
    
    return true;
  }

  // Start the game
  void startGame() {
    if (_currentSession == null || !isHost) return;
    
    _currentSession = _currentSession!.copyWith(
      status: GameStatus.playing,
    );
    
    notifyListeners();
  }

  // Submit player's choice
  Future<void> submitChoice(String choiceId) async {
    if (_currentSession == null || _currentPlayer == null) return;

    // Update player's choice
    final updatedPlayers = _currentSession!.players.map((player) {
      if (player.id == _currentPlayer!.id) {
        return player.copyWith(currentChoice: choiceId);
      }
      return player;
    }).toList();

    // Update voting results
    final currentCard = getCurrentCard();
    if (currentCard == null) return;

    final votingResults = Map<String, Map<String, int>>.from(_currentSession!.votingResults);
    if (!votingResults.containsKey(currentCard.id)) {
      votingResults[currentCard.id] = {};
    }
    
    votingResults[currentCard.id]![choiceId] = 
        (votingResults[currentCard.id]![choiceId] ?? 0) + 1;

    _currentSession = _currentSession!.copyWith(
      players: updatedPlayers,
      votingResults: votingResults,
    );

    notifyListeners();

    // TODO: Send choice to backend
  }

  // Move to next card
  void nextCard(String nextCardId) {
    if (_currentSession == null || !isHost) return;

    // Clear player choices for new card
    final updatedPlayers = _currentSession!.players.map((player) {
      return player.copyWith(currentChoice: null);
    }).toList();

    _currentSession = _currentSession!.copyWith(
      currentCardId: nextCardId,
      players: updatedPlayers,
      status: GameStatus.playing,
    );

    notifyListeners();
  }

  // Show voting results
  void showResults() {
    if (_currentSession == null || !isHost) return;

    _currentSession = _currentSession!.copyWith(
      status: GameStatus.results,
    );

    notifyListeners();
  }

  // Calculate and update scores
  void calculateScores() {
    if (_currentSession == null) return;

    final currentCard = getCurrentCard();
    if (currentCard == null || currentCard.choices == null) return;

    final updatedPlayers = _currentSession!.players.map((player) {
      if (player.currentChoice == null) return player;

      final choice = currentCard.choices!.firstWhere(
        (c) => c.id == player.currentChoice,
        orElse: () => currentCard.choices!.first,
      );

      return player.copyWith(
        score: player.score + choice.points,
      );
    }).toList();

    _currentSession = _currentSession!.copyWith(
      players: updatedPlayers,
    );

    notifyListeners();
  }

  // Get current card
  GameCard? getCurrentCard() {
    if (_currentSession == null) return null;
    
    try {
      return _currentSession!.story.cards.firstWhere(
        (card) => card.id == _currentSession!.currentCardId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get voting results for current card
  Map<String, int> getCurrentVotingResults() {
    if (_currentSession == null) return {};
    
    final currentCard = getCurrentCard();
    if (currentCard == null) return {};
    
    return _currentSession!.votingResults[currentCard.id] ?? {};
  }

  // Check if all players have voted
  bool hasAllPlayersVoted() {
    if (_currentSession == null) return false;
    
    return _currentSession!.players.every((player) => player.currentChoice != null);
  }

  // Get number of players who voted for each choice
  int getVoteCount(String choiceId) {
    final results = getCurrentVotingResults();
    return results[choiceId] ?? 0;
  }

  // Helper methods
  String _generatePinCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }

  // Reset game
  void resetGame() {
    _currentSession = null;
    _currentPlayer = null;
    notifyListeners();
  }
}
