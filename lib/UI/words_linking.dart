import 'package:flutter/material.dart';
import 'word_search.dart';
import '/Logic/word.dart';
import '/Logic/localization.dart' as localization;

class WordsLinkingPage extends StatelessWidget {
  final Word callerWord;

  const WordsLinkingPage(this.callerWord, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: Text(
            localization.text['Linking'],
            style: const TextStyle(fontSize: 30),
          ),
        ),
        body: WordSearchWidget(this));
  }
}
