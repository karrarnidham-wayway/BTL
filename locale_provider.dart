import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının seçtiği dili tutar (tr / ar) ve uygulama genelinde
/// anlık değişimi tetikler. SharedPreferences ile kalıcı hale getirilir.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('tr')) {
    _loadSavedLocale();
  }

  static const _prefKey = 'app_language';

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved != null) {
      state = Locale(saved);
    }
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, languageCode);
  }

  bool get isRtl => state.languageCode == 'ar';
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
