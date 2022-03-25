import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/main.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WordPair args = ModalRoute.of(context)!.settings.arguments as WordPair;
    ParPalavra word = ModalRoute.of(context)!.settings.arguments as ParPalavra;
    late WordPair _wordPair;
    late String newFirstWord;
    late String newSecondWord;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Second Screen'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: args.first,
                decoration: const InputDecoration(
                    hintText: "Ensira a primeira palavra"),
                onChanged: (newValue) => newFirstWord = newValue,
              ),
              TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: args.second,
                  decoration: const InputDecoration(
                      hintText: "Ensira a segunda palavra"),
                  onChanged: (newValue) => newSecondWord = newValue),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 81, 68, 255),
                          fixedSize: Size(100, 40)),
                      onPressed: () {
                        Navigator.pop(context);
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
