import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'messages.dart';

/// App-level localization delegate. English is the fallback locale.
class MahalliLocalizations {
  MahalliLocalizations(this.language);

  final AppLanguage language;

  static MahalliLocalizations of(BuildContext context) =>
      Localizations.required<MahalliLocalizations>(context);

  /// Translate [key], substituting `{param}` placeholders from [params].
  String t(String key, {Map<String, String>? params}) =>
      Messages.of(language, key, params);

  TextDirection get direction => language.direction;

  bool get isRtl => language == AppLanguage.ar;

  static const LocalizationsDelegate<MahalliLocalizations> delegate =
      _MahalliLocalizationsDelegate();
}

class _MahalliLocalizationsDelegate
    extends LocalizationsDelegate<MahalliLocalizations> {
  const _MahalliLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLanguage.values.any((l) => l.code == locale.languageCode);

  @override
  Future<MahalliLocalizations> load(Locale locale) =>
      SynchronousFuture<MahalliLocalizations>(
        MahalliLocalizations(AppLanguage.fromCode(locale.languageCode)),
      );

  @override
  bool shouldReload(_MahalliLocalizationsDelegate old) => false;
}

/// Convenience global accessor so non-widget code (services, snackbars built
/// outside of context) can still translate strings. Kept in sync by
/// `MahalliApp`.
MahalliLocalizations? _current;

void bindLocalizations(MahalliLocalizations? value) => _current = value;

String tr(String key, {Map<String, String>? params}) =>
    (_current ?? MahalliLocalizations(AppLanguage.en)).t(key, params: params);
