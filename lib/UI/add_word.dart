import 'package:flutter/material.dart';
import '/Logic/word.dart';
import '/Logic/localization.dart' as localization;
import '/Logic/save.dart';

class AddWord extends StatefulWidget {
  final String searchBarText;

  const AddWord(this.searchBarText, {Key? key}) : super(key: key);

  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  Language? language;
  String spelling = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      spelling = widget.searchBarText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: Word.noConflicts(spelling, language)
                ? () {
                    Word(spelling, language!);
                    saveToFiles();
                    Navigator.pop(context);
                  }
                : null,
            icon: const Icon(Icons.done_rounded),
            tooltip: localization.text['Confirm'],
          ),
        ],
        backgroundColor: Colors.indigoAccent,
        title: Text(
          localization.text['New word'],
          style: const TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.searchBarText,
              decoration: InputDecoration(
                  hintText: localization.text['Enter spelling'],
                  contentPadding:
                      const EdgeInsets.only(left: 3, right: 3, bottom: 5)),
              maxLines: null,
              onChanged: (text) => setState(() => spelling = text),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                hintText: localization.text['Select a language'],
                contentPadding: const EdgeInsets.only(left: 3, right: 3),
              ),
              onChanged: (Language? item) => setState(() => language = item),
              items: Language.values.map((Language value) {
                return DropdownMenuItem<Language>(
                  value: value,
                  child: Text(localization.text[value]),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
