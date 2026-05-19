class ScenarioData {
  final String id;
  final String text;
  final String title;
  final String? lobbyId;
  final String? imageUrl;
  final List<AnswerData> answers;

  const ScenarioData({
    required this.id,
    required this.text,
    required this.title,
    this.lobbyId,
    this.imageUrl,
    required this.answers,
  });

  factory ScenarioData.fromFirestore(String docId, Map<String, dynamic> data, List<AnswerData> answers) {
    return ScenarioData(
      id: docId,
      text: data['text'] ?? '',
      title: data['title'] ?? '',
      lobbyId: data['lobbyId'],
      imageUrl: data['imageUrl'],
      answers: answers,
    );
  }
}

class AnswerData {
  final String id;
  final String text;
  final String? nextScenarioId;
  final List<String> cardIds;

  const AnswerData({
    required this.id,
    required this.text,
    this.nextScenarioId,
    this.cardIds = const [],
  });

  factory AnswerData.fromFirestore(String docId, Map<String, dynamic> data) {
    final List<String> cardIds = (data['cardIds'] as List?)?.map((e) => e.toString()).toList() ?? [];
    return AnswerData(
      id: docId,
      text: data['text'] ?? '',
      nextScenarioId: data['nextScenarioId'],
      cardIds: cardIds,
    );
  }
}