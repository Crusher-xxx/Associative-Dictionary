import 'localization.dart' as localization;
import 'meaning.dart';

class Word {
  static List<Word> collection = [
    // Word('ручка', Language.russian),
    // Word('загон', Language.russian),
    // Word('pen', Language.english),
    // Word('pinnacle', Language.english),
    // Word('apple', Language.english),
    // Word('head', Language.english),
    // Word('armor', Language.english),
    // Word('variable', Language.english),
    // Word('class', Language.english),
    // Word('create', Language.english),
    // Word('keyboard', Language.english),
    // Word('sand', Language.english),
    // Word('oil', Language.english),
    // Word('horse', Language.english),
    // Word('sword', Language.english),
    // Word('ash', Language.english),
    // Word('boil', Language.english),
    // Word('blade', Language.english),
    // Word('screen', Language.english),
    // Word('fan', Language.english),
    // Word('acquire', Language.english),
    // Word('produce', Language.english),
  ];

  // Make sure that word passes all checks
  static bool noConflicts(String spelling, Language? language) {
    // Is not (empty or consists only from spaces)
    // Language was provided from add_word
    // Doesn't have leading or trailing whitespaces
    if (spelling.replaceAll(' ', '').isEmpty ||
        language == null ||
        spelling.trim() != spelling) {
      return false;
    }

    // Doesn't have twins
    for (Word w in collection) {
      if (w.spelling == spelling.trim() && w.language == language) {
        return false;
      }
    }
    return true;
  }

  static List<Word> getMatches(String word) {
    RegExp pattern = RegExp(word.toLowerCase());
    return collection
        .where((word) => pattern.hasMatch(word.spelling.toLowerCase()))
        .toList();
  }

  String spelling;
  Language language;
  final DateTime _dateAdded;
  Set<Meaning> meanings = {};

  DateTime get dateAdded => _dateAdded;

  Word._(this.spelling, this.language) : _dateAdded = DateTime.now();

  factory Word(String spelling, Language language) {
    // If this word already exist return it instead of creating a new one
    for (Word w in collection) {
      if (w.spelling == spelling && w.language == language) {
        return w;
      }
    }
    Word newInstance = Word._(spelling, language);
    collection.add(newInstance);
    return newInstance;
  }

  Word.fromJson(Map<String, dynamic> json)
      : spelling = json['spelling'],
        language = Language.values[json['language']],
        _dateAdded = DateTime.parse(json['dateAdded']),
        meanings = List<int>.from(json['meanings'])
            .map((e) => Meaning.fromIndex(e))
            .toSet() {
    collection.add(this);
  }

  @override
  String toString() {
    String out = '$spelling — ${localization.text[language]} — $dateAdded\n';
    for (Meaning element in meanings) {
      out += '\t${element.description}\n';
    }
    return out;
  }

  Map<String, dynamic> toJson() => {
        'spelling': spelling,
        'language': language.index,
        'dateAdded': dateAdded.toString(),
        'meanings': meanings.map((e) => Meaning.collection.indexOf(e)).toList(),
      };
}

enum Language {
  english,
  russian,
  french,
  german,
}
