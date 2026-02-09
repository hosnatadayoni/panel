import 'dart:ui';
import 'package:flutter/material.dart';
import 'app-controller.dart';

class TranslationsDelegate extends LocalizationsDelegate<AppController> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fa', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppController> load(Locale locale) =>
      AppController.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}