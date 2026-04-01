// TODO: align field names with the other group's database schema

class StoryCardData {
  final String id;
  final String cardNumber;   // e.g. "1"
  final String storyTag;     // e.g. "1ˢᵀ STORY"
  final String storySubtitle;// e.g. "HET SKATEPARK"
  final String cardLabel;    // e.g. "SPELKAART"
  final int timeLimit;       // seconds shown in badge
  final String imageAsset;   // path in assets/images/
  final String textTitle;    // pink title on text pages
  final List<String> textPages; // one entry per swipe page
  final List<ChoiceData> choices;

  const StoryCardData({
    required this.id,
    required this.cardNumber,
    required this.storyTag,
    required this.storySubtitle,
    required this.cardLabel,
    required this.timeLimit,
    required this.imageAsset,
    required this.textTitle,
    required this.textPages,
    required this.choices,
  });
}

class ChoiceData {
  final String text;
  final String nextCardId;

  const ChoiceData({
    required this.text,
    required this.nextCardId,
  });
}
