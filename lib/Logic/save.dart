import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'meaning.dart';
import 'word.dart';

void saveToFiles() async {
  final Directory? directory = await getExternalStorageDirectory();
  final File wordsFile = File('${directory?.path}/words.txt');
  final File meaningsFile = File('${directory?.path}/meanings.txt');
  String words = '';
  String meanings = '';
  for (Word w in Word.collection) {
    words += '${jsonEncode(w.toJson())}\n';
  }
  for (Meaning m in Meaning.collection) {
    meanings += '${jsonEncode(m.toJson())}\n';
  }
  await wordsFile.writeAsString(words, mode: FileMode.write);
  await meaningsFile.writeAsString(meanings, mode: FileMode.write);
}

void loadFromFiles() async {
  final Directory? directory = await getExternalStorageDirectory();
  final File wordsFile = File('${directory?.path}/words.txt');
  final File meaningsFile = File('${directory?.path}/meanings.txt');

  LineSplitter.split(await meaningsFile.readAsString()).forEach((line) {
    Meaning.fromJson(jsonDecode(line));
  });
  LineSplitter.split(await wordsFile.readAsString()).forEach((line) {
    Word.fromJson(jsonDecode(line));
  });
}
