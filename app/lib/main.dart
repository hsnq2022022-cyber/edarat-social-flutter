import 'package:flutter/material.dart';

import 'core/localization/app_localizations.dart';
import 'core/theme/mahalli_theme.dart';
import 'data/repositories/repository_contracts.dart';
import 'data/services/demo_fixtures.dart';
import 'data/services/google_wallet_service.dart';
import 'root_shell.dart';

void main() {
  runApp(const MahalliApp());
}

class MahalliApp extends StatefulWidget {
  const MahalliApp({super.key});

  @override
  State<MahalliApp> createState() => _MahalliAppState();
}

class _MahalliAppState extends State<MahalliApp> {
  late final AppServices _services;

  /// Active UI language. English is default/primary, Arabic second.
  AppLanguage _language = AppLanguage.en;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _services = AppServices.create(demoMode: true);
    // Persisted preference would be restored here via SharedPreferences in a
    // future iteration; for now the demo session starts in English and any
    // switch made in Profile applies immediately and survives navigation.
  }

  void _setLanguage(AppLanguage language) {
    setState(() {
      _language = language;
      _locale = language.locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations(_language);
    bindLocalizations(l10n);

    return AppServicesScope(
      services: _services,
      languageController: LanguageController(
        current: _language,
        onChanged: _setLanguage,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MAHALLI',
        theme: mahalliTheme(),
        locale: _locale,
        localizationsDelegates: const [
          MahalliLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
        builder: (context, child) => Directionality(
          textDirection: AppLanguage.fromCode(Localizations.localeOf(context).languageCode)
              .direction,
          child: child ?? const SizedBox.shrink(),
        ),
        home: const RootShell(),
      ),
    );
  }
}

/// Exposes repositories/services and localization state down the tree
/// without adding external state-management packages.
class AppServices {
  AppServices({
    required this.loyalty,
    required this.auth,
    required this.wallet,
    required this.demoMode,
  });

  factory AppServices.create({required bool demoMode}) {
    // Backend verification result: no production API exists in this repo,
    // so demo fixtures are wired explicitly and labelled as such. When the
    // MAHALLI backend ships, replace DemoLoyaltyRepository with an HTTP
    // implementation here — nothing else needs to change.
    if (demoMode && !DemoFixtures.enabled) {
      throw StateError('Demo mode requested but fixtures disabled');
    }
    return AppServices(
      loyalty: DemoLoyaltyRepository(),
      auth: DemoAuthBackend(),
      wallet: HttpWalletService(),
      demoMode: demoMode,
    );
  }

  final LoyaltyRepository loyalty;
  final AuthBackend auth;
  final GoogleWalletService wallet;
  final bool demoMode;
}

class LanguageController extends ChangeNotifier {
  LanguageController({required this.current, required void Function(AppLanguage) onChanged})
      : _onChanged = onChanged;

  AppLanguage current;
  final void Function(AppLanguage) _onChanged;

  void select(AppLanguage language) {
    if (language == current) return;
    current = language;
    notifyListeners();
    _onChanged(language);
  }
}

class AppServicesScope extends InheritedWidget {
  const AppServicesScope({
    super.key,
    required this.services,
    required this.languageController,
    required super.child,
  });

  final AppServices services;
  final LanguageController languageController;

  static AppServicesScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppServicesScope>()!;

  @override
  bool updateShouldNotify(AppServicesScope oldWidget) =>
      services != oldWidget.services ||
      languageController != oldWidget.languageController;
}
