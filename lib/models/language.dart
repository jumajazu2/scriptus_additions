// import '../services/database.dart';
// import '../services/constants.dart' as Constants;

/// Represents a Language.
class Language {
  final int id;
  final String title;
  final String fp_lang_alias;
  final String? translation;
  final int? production;

  Language({
    required this.id,
    required this.title,
    required this.fp_lang_alias,
    this.translation,
    this.production,
  });

  factory Language.fromMap(Map<String, dynamic> json) => Language(
        id: json["ID"],
        title: json["title"],
        fp_lang_alias: json["fp_lang_alias"],
        translation: json["translation"],
        production: json["production"],
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "title": title,
        "fp_lang_alias": fp_lang_alias,
        "translation": translation,
        "production": production,
      };
}
