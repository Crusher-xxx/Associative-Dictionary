import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/Logic/meaning.dart';
import '/Logic/word.dart';
import '/Logic/localization.dart' as localization;
import '/Logic/save.dart';
import 'meaning_details.dart';
import 'words_linking.dart';

class WordDetailsPage extends StatefulWidget {
  final Word word;

  const WordDetailsPage(this.word, {Key? key}) : super(key: key);

  @override
  State<WordDetailsPage> createState() => _WordDetailsPageState();
}

class _WordDetailsPageState extends State<WordDetailsPage> {
  late final Word word;
  bool _editingEnabled = false;
  final TextEditingController _newSpelling = TextEditingController();
  late Language _newLanguage;
  final double _spaceBetweenRows = 5;
  final double _spaceBetweenColumns = 15;

  void delete() {
    Word.collection.remove(widget.word);

    // delete meanings without connections
    for (Meaning m in word.meanings) {
      bool hasConnections = false;
      for (Word w in Word.collection) {
        if (w.meanings.contains(m)) {
          hasConnections = true;
          break;
        }
      }
      if (!hasConnections) {
        Meaning.collection.remove(m);
      }
    }

    saveToFiles();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    word = widget.word;
    _newSpelling.text = word.spelling;
    _newLanguage = word.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            if (!_editingEnabled)
              IconButton(
                icon: const Icon(Icons.link_rounded),
                tooltip: localization.text['Link with another word'],
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WordsLinkingPage(widget.word)));
                  setState(() {});
                },
              ),
            if (!_editingEnabled)
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                tooltip: localization.text['Delete word from the dictionary'],
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(localization.text['Deletion']),
                          content: Text(localization.text[
                              'Are you sure you want to delete this word from the dictionary?']),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(localization.text['Cancel']),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                delete();
                              },
                              child: Text(localization.text['Delete']),
                            ),
                          ],
                        )),
              ),
            if (!_editingEnabled)
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                tooltip: localization.text['Edit word'],
                onPressed: () => setState(() => _editingEnabled = true),
              ),
            if (_editingEnabled)
              IconButton(
                icon: const Icon(Icons.cancel_rounded),
                tooltip: localization.text['Cancel changes'],
                onPressed: () => setState(() {
                  _editingEnabled = false;
                  _newSpelling.text = word.spelling;
                  _newLanguage = word.language;
                }),
              ),
            if (_editingEnabled)
              IconButton(
                icon: const Icon(Icons.save_rounded),
                tooltip: localization.text['Save changes'],
                onPressed: Word.noConflicts(_newSpelling.text, _newLanguage)
                    ? () => setState(() {
                          _editingEnabled = false;
                          word.spelling = _newSpelling.text;
                          word.language = _newLanguage;
                          saveToFiles();
                        })
                    : null,
              ),
          ],
          backgroundColor: Colors.indigoAccent,
          title: FittedBox(
            child: Text(
              localization.text['Details'],
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        body: Column(children: [
          Container(
            padding: const EdgeInsets.only(left: 3, bottom: 10),
            color: Colors.white,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: _spaceBetweenRows,
                                right: _spaceBetweenColumns),
                            child: Text(localization.text['Spelling:'])),
                        Padding(
                          padding: EdgeInsets.only(bottom: _spaceBetweenRows),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(5)),
                            onChanged: (text) => setState(() {
                              _newSpelling.text = text;
                              _newSpelling.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: _newSpelling.text.length));
                            }),
                            enabled: _editingEnabled,
                            controller: _newSpelling,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: _spaceBetweenRows,
                                right: _spaceBetweenColumns),
                            child: Text(localization.text['Language:'])),
                        Padding(
                          padding: EdgeInsets.only(bottom: _spaceBetweenRows),
                          child: IgnorePointer(
                            ignoring: !_editingEnabled,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 3, right: 3),
                              ),
                              value: _newLanguage,
                              onChanged: (Language? item) =>
                                  setState(() => _newLanguage = item!),
                              items: Language.values.map((Language value) {
                                return DropdownMenuItem<Language>(
                                  value: value,
                                  child: Text(localization.text[value]),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: _spaceBetweenRows,
                                right: _spaceBetweenColumns),
                            child: Text(localization.text['Added:'])),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(
                                DateFormat('hh:mm, EEEE, d MMMM yyyy', 'ru')
                                    .format(word.dateAdded))),
                      ]),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(localization.text['Meanings:'])),
              ],
            ),
          ),
          Expanded(
              child: ListView.separated(
            itemCount: word.meanings.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 3),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(word.meanings.toList()[index].description)),
                    if (word.meanings.toList()[index].imageURL.isNotEmpty)
                      Image.network(
                        word.meanings.toList()[index].imageURL,
                        width: 100,
                      ),
                  ],
                ),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MeaningDetailsPage(
                              word.meanings.toList()[index], word)));
                  if (!Word.collection.contains(word)) {
                    Navigator.pop(context);
                  }
                  setState(() {
                    _newSpelling.text = word.spelling;
                    _newLanguage = word.language;
                    saveToFiles();
                  });
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 0,
                thickness: 2,
              );
            },
          ))
        ]));
  }
}
