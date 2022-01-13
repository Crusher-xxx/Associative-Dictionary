import 'package:flutter/material.dart';
import 'word_search.dart';
import 'add_word.dart';
import '/Logic/save.dart';
import '/Logic/localization.dart' as localization;

class DictionaryPage extends StatelessWidget {
  late final Function updateBody;
  String searchBarText = '';

  DictionaryPage({Key? key}) : super(key: key);
  Future<void> f = Future<void>(() => loadFromFiles());

  static DictionaryPage? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<DictionaryPage>();

  @override
  Widget build(BuildContext context) {
    f.whenComplete(() => updateBody(searchBarText));
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddWord(searchBarText)));
                updateBody(searchBarText); // Update to display new word
              },
              icon: const Icon(Icons.add_rounded),
              tooltip: localization.text['Add new word'],
            ),
          ],
          backgroundColor: Colors.indigoAccent,
          title: Text(
            localization.text['Dictionary'],
            style: const TextStyle(fontSize: 30),
          ),
        ),
        body: WordSearchWidget(this));
  }
}
