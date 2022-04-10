import 'package:english_words/english_words.dart';

class ParPalavra {
  String firstWord = '';
  String secondWord = '';

  ParPalavra(this.firstWord, this.secondWord);

//factory to create new words using the Word Pair base
  factory ParPalavra.constructor() {
    WordPair word = generateWordPairs().first;
    ParPalavra p = ParPalavra(word.first, word.second);
    return p;
  }

//function to LowerCase de second part of a word
  String lowerCase(String word) {
    return word.toLowerCase();
  }

//function to change a word to a pascal case
  String CreateAsPascalCase() {
    return "${firstWord[0].toUpperCase() + lowerCase(firstWord.substring(1))}${secondWord[0].toUpperCase() + lowerCase(secondWord.substring(1))}";
  }

//var that receive the pascal case create function
  late final asPascalCase = CreateAsPascalCase();
}
