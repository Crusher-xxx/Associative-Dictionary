import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Logic/save.dart';
import 'UI/dictionary.dart';

void main() {
  initializeDateFormatting();
  // Word.collection.toList()[0].meanings.add(Meaning.collection[0]);
  // Word.collection.toList()[0].meanings.add(Meaning.collection[1]);
  // Word.collection.toList()[1].meanings.add(Meaning.collection[2]);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
      theme: ThemeData(
          textTheme: const TextTheme(
            subtitle1: TextStyle(fontSize: 20),
            bodyText2: TextStyle(fontSize: 20),
          )),
      title: 'Associative Dictionary',
      home: DictionaryPage()));
  //saveToFiles();
  //loadFromFiles();
}