import 'package:associative_dictionary/UI/word_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/Logic/save.dart';
import '/Logic/meaning.dart';
import '/Logic/word.dart';
import '/Logic/localization.dart' as localization;

class MeaningDetailsPage extends StatefulWidget {
  final Meaning meaning;
  final Word word;

  const MeaningDetailsPage(this.meaning, this.word, {Key? key})
      : super(key: key);

  @override
  _MeaningDetailsPageState createState() => _MeaningDetailsPageState();
}

class _MeaningDetailsPageState extends State<MeaningDetailsPage> {
  bool _editingEnabled = false;
  final TextEditingController _newDescription = TextEditingController();
  final TextEditingController _newURL = TextEditingController();
  late List<Word> relatedWords;

  @override
  void initState() {
    super.initState();
    _newDescription.text = widget.meaning.description;
    _newURL.text = widget.meaning.imageURL;
    relatedWords = Word.collection
        .where((w) => w.meanings.contains(widget.meaning))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!_editingEnabled)
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              tooltip: localization.text['Delete meaning from word'],
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(localization.text['Deletion']),
                        content: Text(localization.text[
                            'Are you sure you want to remove this meaning from this word?']),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(localization.text['Cancel']),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.word.meanings.remove(widget.meaning);
                              // delete meanings without connections
                              bool hasConnections = false;
                              for (Word w in Word.collection) {
                                if (w.meanings.contains(widget.meaning)) {
                                  hasConnections = true;
                                  break;
                                }
                              }
                              if (!hasConnections) {
                                Meaning.collection.remove(widget.meaning);
                              }
                              saveToFiles();
                              Navigator.pop(context);
                            },
                            child: Text(localization.text['Delete']),
                          ),
                        ],
                      )),
            ),
          if (!_editingEnabled)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              tooltip: localization.text['Edit meaning'],
              onPressed: () => setState(() => _editingEnabled = true),
            ),
          if (_editingEnabled)
            IconButton(
              icon: const Icon(Icons.cancel_rounded),
              tooltip: localization.text['Cancel changes'],
              onPressed: () => setState(() {
                _editingEnabled = false;
                _newDescription.text = widget.meaning.description;
                _newURL.text = widget.meaning.imageURL;
              }),
            ),
          if (_editingEnabled)
            IconButton(
              icon: const Icon(Icons.save_rounded),
              tooltip: localization.text['Save changes'],
              onPressed: Meaning.noConflicts(_newDescription.text, _newURL.text)
                  ? () => setState(() {
                        _editingEnabled = false;
                        widget.meaning.description = _newDescription.text;
                        widget.meaning.imageURL = _newURL.text;
                        saveToFiles();
                      })
                  : null,
            ),
        ],
        backgroundColor: Colors.indigoAccent,
        title: Text(
          localization.text['Details'],
          style: const TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              maxLines: null,
              decoration: InputDecoration(
                  hintText: localization.text['Enter description'],
                  isDense: false,
                  contentPadding: const EdgeInsets.only(
                      left: 3, right: 3, bottom: 5, top: 5)),
              onChanged: (text) {
                setState(() => _newDescription.text = text);
                _newDescription.selection = TextSelection.fromPosition(
                    TextPosition(offset: _newDescription.text.length));
              },
              enabled: _editingEnabled,
              //initialValue: widget.meaning.description,
              controller: _newDescription,
            ),
            if (_editingEnabled)
              TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                    hintText: localization.text['Enter image URL (optional)'],
                    hintMaxLines: 3,
                    isDense: false,
                    contentPadding: const EdgeInsets.only(
                        left: 3, right: 3, bottom: 5, top: 5)),
                onChanged: (text) => setState(() {
                  _newURL.text = text;
                  _newURL.selection = TextSelection.fromPosition(
                      TextPosition(offset: _newURL.text.length));
                }),
                controller: _newURL,
              ),
            if (widget.meaning.imageURL.isNotEmpty && !_editingEnabled)
              Image.network(widget.meaning.imageURL),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: relatedWords.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(relatedWords[index].spelling),
                subtitle: Text(
                    '${localization.text[relatedWords[index].language]} — ${DateFormat('d MMM yyyy', 'ru').format(relatedWords[index].dateAdded)}',
                    style: const TextStyle(fontSize: 15)),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WordDetailsPage(relatedWords[index])));
                  if (!Meaning.collection.contains(widget.meaning)) {
                    Navigator.pop(context);
                  }
                  setState(() {
                    _newDescription.text = widget.meaning.description;
                    _newURL.text = widget.meaning.imageURL;
                    relatedWords = Word.collection
                        .where((w) => w.meanings.contains(widget.meaning))
                        .toList();
                    saveToFiles();
                  });
                },
              ),
              separatorBuilder: (context, index) => const Divider(
                height: 0,
                thickness: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
