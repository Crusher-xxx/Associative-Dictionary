import 'package:flutter/material.dart';
import '/Logic/save.dart';
import '/Logic/meaning.dart';
import 'select_meaning.dart';
import '/Logic/localization.dart' as localization;

class AddMeaningPage extends StatefulWidget {
  final SelectMeaningPage _caller;

  const AddMeaningPage(this._caller, {Key? key}) : super(key: key);

  @override
  State<AddMeaningPage> createState() => _AddMeaningPageState();
}

class _AddMeaningPageState extends State<AddMeaningPage> {
  String _description = '';
  String _url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: Meaning.noConflicts(_description, _url)
                ? () {
                    saveToFiles();
                    Navigator.pop(context, Meaning(_description, url: _url));
                  }
                : null,
            icon: const Icon(Icons.done_rounded),
            tooltip: localization.text['Confirm'],
          ),
        ],
        backgroundColor: Colors.indigoAccent,
        title: FittedBox(
          child: Text(
            localization.text['New meaning'],
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  hintMaxLines: 3,
                  hintText: localization.text['Enter description'],
                  contentPadding:
                      const EdgeInsets.only(left: 3, right: 3, bottom: 5)),
              maxLines: null,
              onChanged: (text) => setState(() => _description = text),
            ),
            TextField(
              decoration: InputDecoration(
                  hintMaxLines: 3,
                  hintText: localization.text['Enter image URL (optional)'],
                  contentPadding:
                      const EdgeInsets.only(left: 3, right: 3, bottom: 5)),
              maxLines: null,
              onChanged: (text) => setState(() => _url = text),
            ),
          ],
        ),
      ),
    );
  }
}
