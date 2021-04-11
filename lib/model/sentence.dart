

class Sentence {
  int id;

  String sentence;

  SentenceCategory category;

  Sentence(this.id, this.sentence, this.category);
}

enum SentenceCategory {
  psychology,
  spiritual,
  science,
  grammar,
  trivia,
  miscellaneous,
}