import 'dart:html';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:startup_namer/edit_page.dart';

void main() {
  runApp(const MyApp());
}

class ParPalavra {
  String firstWord = '';
  String secondWord = '';

  ParPalavra(this.firstWord, this.secondWord);

  factory ParPalavra.constructor() {
    WordPair word = generateWordPairs().first;
    ParPalavra p = ParPalavra(word.first, word.second);
    return p;
  }

  String CreateAsPascalCase() {
    return "${firstWord[0].toUpperCase() + firstWord.substring(1)}${secondWord[0].toUpperCase() + secondWord.substring(1)}";
  }

  late final asPascalCase = CreateAsPascalCase();
}

// abstract class ParPalavraRepository {
//   final _suggestions = <ParPalavra>[];

//   List<ParPalavra> getAll();

// }

// class CallParPalavraRepository implements ParPalavraRepository {

//   CallParPalavraRepository(){
//     CreateParPalavra(20);
//   }

//   CreateParPalavra(int num) {
//     for (int i = 0; i < num; i++) {
//       _suggestions.add(ParPalavra.constructor());
//     }

//   @override
//   List<ParPalavra> getAll() {
//     return _suggestions;
//   }

// }
// }

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
    _suggestions.remove(word);
  }
}

//CallParPalavraRepository repositoryParPalavra = new CallParPalavraRepository();

RepositoryParPalavra repositoryParPalavra = new RepositoryParPalavra();

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
        RandomWords.routeName: (context) => RandomWords(),
        EditScreen.routeName: (context) => EditScreen()
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = <ParPalavra>[];
  bool cardMode = false;
  String nome = "Startup Name Generator";

  @override
  Widget build(BuildContext context) {
    print("widght state");
    return Scaffold(
        appBar: AppBar(
          title: Text(nome),
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
          (ParPalavra pair) {
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
          print("list view");
          final index = i ~/ 2;

          if (index >= repositoryParPalavra.getAll().length) {
            repositoryParPalavra.CreateParPalavra(10);
            print("create word");
          }
          return _buildRow(repositoryParPalavra.getByIndex(index));
        },
      );
    } else {
      return _cardVizualizaton();
    }
  }

//Building list Rows
  Widget _buildRow(ParPalavra pair) {
    print("build row");
    final alreadySaved = _saved.contains(pair);
    var color = Colors.transparent;
    return Dismissible(
        key: Key(pair.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            }
            repositoryParPalavra.removeParPalavra(pair);
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
            pair.asPascalCase,
            style: _biggerFont,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/edit', arguments: pair);
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
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
              }),
        ));
  }

//Building cards vizualization
  Widget _cardVizualizaton() {
    print('card mode changed');
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 8),
      //itemCount: repositoryParPalavra._suggestions.length,
      itemBuilder: (context, index) {
        if (index >= repositoryParPalavra.getAll().length) {
          repositoryParPalavra.CreateParPalavra(10);
        }
        return Column(
          children: [_buildRow(repositoryParPalavra.getByIndex(index))],
        );
      },
    );
  }
}

class EditScreen extends StatefulWidget {
  static const routeName = '/edit';
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    final word = ModalRoute.of(context)!.settings.arguments as ParPalavra;
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
                initialValue: word.firstWord,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Type First Word"),
                onChanged: (value) => word.firstWord = value.toString(),
              ),
              TextFormField(
                initialValue: word.secondWord,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Type Second Word"),
                onChanged: (value) => word.secondWord = value.toString(),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 81, 68, 255),
                          fixedSize: Size(100, 40)),
                      onPressed: () {
                        print(word.secondWord);
                        print(word.firstWord);
                        setState(() {
                          //word = ParPalavra(word.firstWord, word.secondWord);
                          print(word);
                          Navigator.pop(context, word);
                        });
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
