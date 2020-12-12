import 'dart:ui';

import 'package:cofein/generated/intl/messages_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:localized_string/localized_string.dart';

class AppStrings {
  static Future<AppStrings> load(Locale locale) {
    final name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    debugPrint('local: $locale');

    return initializeMessages(localeName).then((_) => AppStrings());
  }

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings);
  }

  static LocalizedString string(String Function(AppStrings strings) factory) =>
      LocalizedString.fromFactory((context) => factory(AppStrings.of(context)));

  String get title => Intl.message(
        'title',
        name: 'title',
        desc: 'title',
      );
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) {
    return AppStrings.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppStrings> old) {
    return false;
  }
}
