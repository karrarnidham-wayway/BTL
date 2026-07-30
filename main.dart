import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/localization/locale_provider.dart';
import 'core/localization/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TTSportApp()));
}

class TTSportApp extends ConsumerWidget {
  const TTSportApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'TT Sport & Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: locale,
      supportedLocales: const [Locale('tr'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        // RTL/LTR yönü dile göre otomatik ayarlanır (Directionality
        // MaterialApp.router içinde locale'e göre kendisi belirlenir,
        // burada ek olarak text scale sabitleniyor).
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
