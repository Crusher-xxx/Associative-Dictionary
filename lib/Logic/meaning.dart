class Meaning {
  static List<Meaning> collection = [
    // Meaning._(0, 'A common writing instrument that applies ink to a surface, usually paper, for writing or drawing.'),
    // Meaning._(1, 'An enclosure for holding livestock.'),
    // Meaning._(2, 'An edged, bladed weapon intended for manual cutting or thrusting.'),
  ];

  // Make sure that meaning passes all checks
  static bool noConflicts(String description, String url) {
    // Is not (empty or consists only from spaces)
    // Doesn't have leading or trailing whitespaces
    if (description.replaceAll(' ', '').isEmpty ||
        description.trim() != description ||
        url.trim() != url) {
      return false;
    }

    // Doesn't have twins
    for (Meaning m in collection) {
      if (m.description == description && m.imageURL == url) {
        return false;
      }
    }
    return true;
  }

  String description;
  String imageURL;

  Meaning._(this.description, this.imageURL);

  Meaning.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        imageURL = json['URL'] {
    collection.add(this);
  }

  factory Meaning(String description, {String url = ''}) {
    // If this meaning already exist return it instead of creating a new one
    for (Meaning element in collection) {
      if (element.description == description) {
        return element;
      }
    }
    Meaning newInstance = Meaning._(description, url);
    collection.add(newInstance);
    return newInstance;
  }

  factory Meaning.fromIndex(int index) {
    return collection[index];
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'URL': imageURL,
      };

  @override
  String toString() {
    return description;
  }
}
