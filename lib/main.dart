import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:startup_namer/edit_page.dart';

void main() {
  runApp(const MyApp());
}

class ParPalavra {
  String firstWord;
  String secondWord;

  ParPalavra(this.firstWord, this.secondWord);
}

class ParPalavraRepository {}

ParPalavraRepository repository = ParPalavraRepository();

List palavraConstrutor() {
  var result = [];
  for (var i = 0; i < 20; i++) {
    WordPair word = WordPair.random();
    ParPalavra p = ParPalavra(word.first, word.second);
    result.add(p);
  }
  return result;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color.fromARGB(255, 81, 68, 255)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RandomWords(),
        '/Edit': (context) => EditScreen()
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = <WordPair>[];
  bool cardMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
            IconButton(
              onPressed: (() {
                setState(() {
                  if (cardMode == false) {
                    cardMode = true;
                    debugPrint('$cardMode');
                  } else if (cardMode == true) {
                    cardMode = false;
                    debugPrint('$cardMode');
                  }
                });
              }),
              tooltip:
                  cardMode ? 'List Vizualization' : 'Card Mode Vizualization',
              icon: Icon(Icons.auto_fix_normal_outlined),
            ),
          ],
        ),
        body: _buildSuggestions(cardMode));
  }

//Favorites Screen
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        final tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
      }),
    );
  }

//Building Suggestions
  Widget _buildSuggestions(bool cardMode) {
    print('list mode changed');

    if (cardMode == false) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index], index);
        },
      );
    } else {
      return _cardVizualizaton();
    }
  }

//Building list Rows
  Widget _buildRow(WordPair pair, int index) {
    final alreadySaved = _saved.contains(_suggestions[index]);
    var color = Colors.transparent;
    final item = pair
        .asPascalCase; //variável que verifica se o par de palavras já está dentro do conjunto _saved.
    return Dismissible(
        key: Key(item),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            if (alreadySaved) {
              _saved.remove(_suggestions[index]);
            }
            _suggestions.removeAt(index);
          });
        },
        background: Container(
          color: Color.fromARGB(255, 81, 68, 255),
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: Text(
            "Excluir",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        child: ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/Edit',
                arguments: _suggestions[index]);
          },
          trailing: IconButton(
              icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Color.fromARGB(255, 81, 68, 255) : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save'),
              tooltip: "Favorite",
              hoverColor: color,
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                    debugPrint(_suggestions[index].first);
                    debugPrint(_suggestions[index].second);
                  }
                });
              }),
        ));
  }

//Building cards vizualization
  Widget _cardVizualizaton() {
    print('card mode changed');
    return GridView.builder(
      padding: EdgeInsets.all(12),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 8),
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        //final index = i ~/ 2;
        final int index = _suggestions.length;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return Column(
          children: [_buildRow(_suggestions[index], index)],
        );
      },
    );
  }
}

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Word'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "Ensira a primeira palavra"),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(hintText: "Ensira a segunda palavra"),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 81, 68, 255),
                          fixedSize: Size(100, 40)),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              ),
            ],
          )),
        ));
  }
}
