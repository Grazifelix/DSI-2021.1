import 'package:english_words/english_words.dart';

class ParPalavra {
  String firstWord = '';
  String secondWord = '';

  ParPalavra(this.firstWord, this.secondWord);

  factory ParPalavra.constructor() {
    WordPair word = generateWordPairs().first;
    ParPalavra p = ParPalavra(word.first, word.second);
    return p;
  }

  String lowerCase(String word) {
    return word.toLowerCase();
  }

  String CreateAsPascalCase() {
    return "${firstWord[0].toUpperCase() + lowerCase(firstWord.substring(1))}${secondWord[0].toUpperCase() + lowerCase(secondWord.substring(1))}";
  }

  late final asPascalCase = CreateAsPascalCase();
}
