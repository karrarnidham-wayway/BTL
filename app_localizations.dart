import 'package:flutter/material.dart';

/// Basit, bağımlılıksız (arb/gen-l10n gerektirmeyen) çeviri sistemi.
/// Küçük/orta ölçekli uygulamalar için hızlı ve bakımı kolay bir yaklaşımdır.
/// Uygulama büyüdükçe flutter gen-l10n (.arb) sistemine geçilebilir.
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _tr = {
    'app_name': 'TT Spor & Mağaza',
    'login_title': 'Giriş Yap',
    'username': 'Kullanıcı Adı',
    'password': 'Şifre',
    'login_button': 'Giriş Yap',
    'forgot_password': 'Şifremi Unuttum',
    'store': 'Mağaza',
    'my_panel': 'Panelim',
    'notifications': 'Bildirimler',
    'profile': 'Profil',
    'products': 'Ürünler',
    'add_to_cart': 'Sepete Ekle',
    'cart': 'Sepetim',
    'place_order': 'Sipariş Talebi Oluştur',
    'weekly_training_plan': 'Haftalık Antrenman Planı',
    'nutrition_plan': 'Beslenme Planı',
    'daily_calorie_goal': 'Günlük Kalori Hedefi',
    'progress': 'Gelişimim',
    'pt_notes': 'PT Notları',
    'weight': 'Kilo',
    'height': 'Boy',
    'body_fat': 'Yağ Oranı',
    'language': 'Dil',
    'logout': 'Çıkış Yap',
  };

  static const _ar = {
    'app_name': 'تي تي رياضة ومتجر',
    'login_title': 'تسجيل الدخول',
    'username': 'اسم المستخدم',
    'password': 'كلمة المرور',
    'login_button': 'تسجيل الدخول',
    'forgot_password': 'نسيت كلمة المرور',
    'store': 'المتجر',
    'my_panel': 'لوحتي',
    'notifications': 'الإشعارات',
    'profile': 'الملف الشخصي',
    'products': 'المنتجات',
    'add_to_cart': 'أضف إلى السلة',
    'cart': 'سلتي',
    'place_order': 'إنشاء طلب',
    'weekly_training_plan': 'خطة التمرين الأسبوعية',
    'nutrition_plan': 'الخطة الغذائية',
    'daily_calorie_goal': 'هدف السعرات اليومي',
    'progress': 'تقدمي',
    'pt_notes': 'ملاحظات المدرب',
    'weight': 'الوزن',
    'height': 'الطول',
    'body_fat': 'نسبة الدهون',
    'language': 'اللغة',
    'logout': 'تسجيل الخروج',
  };

  String t(String key) {
    final map = locale.languageCode == 'ar' ? _ar : _tr;
    return map[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Kısayol: context.t('key')
extension AppLocalizationsX on BuildContext {
  String t(String key) => AppLocalizations.of(this).t(key);
}
