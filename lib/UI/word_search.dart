import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/Logic/word.dart';
import '/Logic/localization.dart' as localization;
import 'dictionary.dart';
import 'words_linking.dart';
import 'word_details.dart';
import 'select_meaning.dart';

class WordSearchWidget extends StatefulWidget {
  final Widget callerPage;

  const WordSearchWidget(this.callerPage, {Key? key}) : super(key: key);

  @override
  WordSearchState createState() => WordSearchState();
}

class WordSearchState extends State<WordSearchWidget> {
  List<Word> list = Word.getMatches('').reversed.toList();
  String searchBarText = '';

  updateMatchingWords(String wordToSearch) {
    setState(() {
      list = Word.getMatches(wordToSearch).reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // if (widget.caller.runtimeType == DictionaryPage) {
    //   (widget.caller as DictionaryPage).updateBody = updateMatchingWords;
    // }
    DictionaryPage.of(context)?.updateBody = updateMatchingWords;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: localization.text['Search for a word'],
          prefixIcon: const Icon(Icons.search),
        ),
        onChanged: (text) {
          searchBarText = text;
          // if (widget.caller.runtimeType == DictionaryPage) {
          //   (widget.caller as DictionaryPage).searchBarText = text;
          // }
          DictionaryPage.of(context)?.searchBarText = text;
          updateMatchingWords(searchBarText);
        },
      ),
      if (list.isEmpty)
        Text(
          Word.collection.isEmpty
              ? localization.text['The dictionary is empty']
              : localization.text['There is no such word in the dictionary'],
        ),
      Expanded(
          child: Scrollbar(
              interactive: true,
              child: ListView.separated(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 3, right: 3),
                    title: Text(list[index].spelling),
                    subtitle: Text(
                        '${localization.text[list[index].language]} — ${DateFormat('d MMM yyyy', 'ru').format(list[index].dateAdded)}',
                        style: const TextStyle(fontSize: 15)),
                    onTap: () async {
                      late Widget pageToNavigate;
                      switch (widget.callerPage.runtimeType) {
                        case DictionaryPage:
                          pageToNavigate = WordDetailsPage(list[index]);
                          break;
                        case WordsLinkingPage:
                          pageToNavigate = SelectMeaningPage(
                              (widget.callerPage as WordsLinkingPage)
                                  .callerWord,
                              list[index]);
                          break;
                      }
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pageToNavigate));
                      updateMatchingWords(searchBarText);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                    thickness: 2,
                  );
                },
              ))),
    ]);
  }
}
