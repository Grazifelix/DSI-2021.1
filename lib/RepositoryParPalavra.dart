import 'package:startup_namer/ParPalavra.dart';

class RepositoryParPalavra {
  final _suggestions = <ParPalavra>[]; //list of par palavra type words

//constructor of repository that initialize with a function call to create twenty new words.
  RepositoryParPalavra() {
    CreateParPalavra(20);
  }

  void CreateParPalavra(int num) {
    for (int i = 0; i < num; i++) {
      _suggestions.add(ParPalavra.constructor());
    }
  }

  List getAll() {
    return _suggestions;
  }

  ParPalavra getByIndex(int index) {
    return _suggestions[index];
  }

  void removeParPalavra(ParPalavra word) {
    _suggestions.removeAt(_suggestions.indexOf(word));
  }
}
