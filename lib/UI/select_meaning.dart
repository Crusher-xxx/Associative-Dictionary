import 'package:flutter/material.dart';
import '/Logic/save.dart';
import '/Logic/meaning.dart';
import '/Logic/word.dart';
import 'add_meaning.dart';
import '/Logic/localization.dart' as localization;

class SelectMeaningPage extends StatelessWidget {
  final Word word1, word2;
  final List<Meaning> union;

  const SelectMeaningPage._(this.word1, this.word2, this.union, {Key? key})
      : super(key: key);

  factory SelectMeaningPage(word1, word2) {
    return SelectMeaningPage._(
        word1, word2, word1.meanings.union(word2.meanings).toList());
  }

  void linkWords(Meaning meaning, context) {
    word1.meanings.add(meaning);
    word2.meanings.add(meaning);
    // Go back to details page
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: Text(
            localization.text['Linking'],
            style: const TextStyle(fontSize: 30),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final meaning = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMeaningPage(this)));
                if (meaning != null) {
                  linkWords(meaning, context);
                }
              },
              icon: const Icon(Icons.add_rounded),
              tooltip: localization.text['Add new meaning'],
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      union.isNotEmpty
                          ? localization.text['Select one of the meanings below or add a new one']
                          : localization.text['These words do not have any meaning. Add it yourself.'],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                  itemCount: union.length,
                  itemBuilder: (context, index) => ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 3, right: 3),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(union[index].description)),
                            if (union[index].imageURL.isNotEmpty)
                              Image.network(
                                union[index].imageURL,
                                width: 100,
                              ),
                          ],
                        ),
                        onTap: () {
                          linkWords(union[index], context);
                          saveToFiles();
                        },
                      ),
                  separatorBuilder: (context, index) => const Divider(
                        height: 0,
                        thickness: 2,
                      )),
            )
          ],
        ));
  }
}
