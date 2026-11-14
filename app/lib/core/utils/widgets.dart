import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/mahalli_theme.dart';

/// Shared UI building blocks: empty states, loading/error views, section
/// headers and the demo-mode banner.
class MahalliEmptyState extends StatelessWidget {
  const MahalliEmptyState({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.bodyKey,
    this.action,
  });

  final IconData icon;
  final String titleKey;
  final String bodyKey;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MahalliSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: MahalliColors.textSecondary),
            const SizedBox(height: MahalliSpacing.md),
            Text(
              l10n.t(titleKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: MahalliSpacing.sm),
            Text(
              l10n.t(bodyKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: MahalliColors.textSecondary, height: 1.4),
            ),
            if (action != null) ...[
              const SizedBox(height: MahalliSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class MahalliLoadingView extends StatelessWidget {
  const MahalliLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: MahalliColors.primary),
          const SizedBox(height: MahalliSpacing.md),
          Text(l10n.t('common.loading'),
              style: const TextStyle(color: MahalliColors.textSecondary)),
        ],
      ),
    );
  }
}

class MahalliErrorView extends StatelessWidget {
  const MahalliErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    return MahalliEmptyState(
      icon: Icons.cloud_off_rounded,
      titleKey: 'common.errorTitle',
      bodyKey: 'discover.joinFailed',
      action: FilledButton(onPressed: onRetry, child: Text(l10n.t('common.retry'))),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.titleKey,
    this.params,
    this.trailing,
  });

  final String titleKey;
  final Map<String, String>? params;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MahalliSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.t(titleKey, params: params),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Amber banner shown whenever the app is running against demo fixtures so
/// sample data is never mistaken for real customer records.
class DemoModeBanner extends StatelessWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    return Container(
      width: double.infinity,
      color: MahalliColors.demoBanner,
      padding:
          const EdgeInsets.symmetric(horizontal: MahalliSpacing.lg, vertical: MahalliSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.science_outlined,
              size: 18, color: MahalliColors.demoBannerText),
          const SizedBox(width: MahalliSpacing.sm),
          Expanded(
            child: Text(
              l10n.t('home.demoBanner'),
              style: const TextStyle(
                  color: MahalliColors.demoBannerText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

void showMahalliSnack(BuildContext context, String message,
    {bool isError = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? MahalliColors.danger : MahalliColors.textPrimary,
    ));
}

/// Formats a backend timestamp as `dd/MM/yyyy · HH:mm`, using Eastern Arabic
/// numerals when the active language is Arabic.
String formatLocalizedDate(DateTime date, BuildContext context) {
  final l10n = MahalliLocalizations.of(context);
  final two = (int v) => v.toString().padLeft(2, '0');
  final raw = '${two(date.day)}/${two(date.month)}/${date.year}'
      ' · ${two(date.hour)}:${two(date.minute)}';
  return l10n.isRtl ? _toEasternArabicDigits(raw) : raw;
}

String _toEasternArabicDigits(String value) => value.replaceAllMapped(
    RegExp('[0-9]'), (m) => String.fromCharCode(0x0660 + int.parse(m[0]!)));
