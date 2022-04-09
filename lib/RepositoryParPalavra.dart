import 'package:startup_namer/ParPalavra.dart';

class RepositoryParPalavra {
  final _suggestions = <ParPalavra>[];

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
