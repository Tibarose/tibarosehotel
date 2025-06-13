import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading assets (e.g., ARB files)
import 'dart:convert'; // For parsing JSON

class AppLocalizations {
  // Instance variables to hold localized data (strings)
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  // Method to retrieve localized strings using keys
  String? translate(String key) {
    return _localizedStrings[key];
  }

  // Load the localized data for the specified locale (usually from ARB files)
  static Future<AppLocalizations> load(Locale locale) async {
    // Load the corresponding JSON file based on the locale from the lib folder
    String jsonString = await rootBundle.loadString('lib/l10n/${locale.languageCode}.json');

    // Parse the JSON string into a Map
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Create an instance of AppLocalizations with the loaded data
    AppLocalizations localizations = AppLocalizations(locale);
    localizations._localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return localizations;
  }

  // This function is used by LocalizationsDelegate to check if the locale is supported
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
