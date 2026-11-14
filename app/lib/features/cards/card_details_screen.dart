import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/mahalli_theme.dart';
import '../../core/utils/widgets.dart';
import '../../data/models/models.dart';
import '../../main.dart';
import 'widgets/loyalty_card_widget.dart';

/// The full-screen digital loyalty card. This is the primary place where a
/// customer reads their stamp progress and can add the pass to Google
/// Wallet. All numbers come from the (backend-provided) [bundle] — the
/// required stamp count is never hardcoded here.
class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key, required this.bundle});

  final CardBundle bundle;

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

enum _WalletUiState { idle, loading, success, failed, unavailable }

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  _WalletUiState _walletState = _WalletUiState.idle;
  late CardBundle _bundle = widget.bundle;

  Future<void> _addToWallet() async {
    setState(() => _walletState = _WalletUiState.loading);
    final services = AppServicesScope.of(context).services;
    // Reload the freshest card record so we act on backend state, not a
    // stale navigation argument.
    try {
      final bundles = await services.loyalty.fetchMyCards();
      final fresh = bundles.where((b) => b.card.id == _bundle.card.id);
      if (fresh.isNotEmpty) _bundle = fresh.first;
    } catch (_) {
      // Keep the navigated bundle if refresh fails.
    }
    final ok = await services.wallet.addCardToWallet(_bundle.card);
    if (!mounted) return;
    setState(() {
      // Success requires BOTH a signed URL and a verified launch. Until the
      // backend mints save URLs, `ok` is false and we surface "unavailable"
      // when no URL exists at all.
      if (ok) {
        _walletState = _WalletUiState.success;
      } else {
        _walletState = _bundle.card.walletObjectUrl == null
            ? _WalletUiState.unavailable
            : _WalletUiState.failed;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    final brand = MahalliColors.fromHex(_bundle.business.brandColorHex);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('card.details')),
        backgroundColor: brand,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(MahalliSpacing.lg),
        children: [
          LoyaltyCardWidget(
            bundle: _bundle,
            onTap: () => showMahalliSnack(
                context, l10n.t('card.stampsProgress', params: {
              'earned': '${_bundle.card.earnedStamps}',
              'required': '${_bundle.program.stampsRequiredForReward}',
            })),
          ),
          const SizedBox(height: MahalliSpacing.xl),
          _walletSection(context, l10n),
          const SizedBox(height: MahalliSpacing.xl),
          SectionHeader(titleKey: 'business.program'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(MahalliSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row(l10n.t('business.howToEarn'),
                      _bundle.program.stampRuleDescription ??
                          l10n.t('business.rewardNote')),
                  _row(
                      l10n.t('card.rewardLabel'),
                      '${_bundle.program.rewardTitle}'
                      '${_bundle.program.rewardDescription != null ? ' — ${_bundle.program.rewardDescription}' : ''}'),
                  _row(
                      l10n.t('card.status.${_bundle.card.status.name}'),
                      l10n.t('card.stampsProgress', params: {
                        'earned': '${_bundle.card.earnedStamps}',
                        'required': '${_bundle.program.stampsRequiredForReward}',
                      })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletSection(BuildContext context, MahalliLocalizations l10n) {
    final eligible = _bundle.card.status == LoyaltyCardStatus.active ||
        _bundle.card.status == LoyaltyCardStatus.completed;

    if (!eligible) {
      return const SizedBox.shrink();
    }

    Widget button;
    switch (_walletState) {
      case _WalletUiState.loading:
        button = FilledButton.icon(
          onPressed: null,
          icon: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2)),
          label: Text(l10n.t('card.walletAdding')),
        );
      case _WalletUiState.success:
        button = FilledButton.icon(
          onPressed: _addToWallet,
          style: FilledButton.styleFrom(
              backgroundColor: MahalliColors.success),
          icon: const Icon(Icons.check_circle_rounded),
          label: Text(l10n.t('card.walletSuccess')),
        );
      default:
        button = OutlinedButton.icon(
          onPressed: _walletState == _WalletUiState.loading ? null : _addToWallet,
          icon: const Icon(Icons.account_balance_wallet_outlined),
          label: Text(l10n.t('card.addToWallet')),
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
        if (_walletState == _WalletUiState.unavailable) ...[
          const SizedBox(height: MahalliSpacing.sm),
          _notice(
            Icons.info_outline_rounded,
            MahalliColors.warning,
            // Honest state: integration layer ready, backend operation
            // missing (signed Save URL generation). See
            // lib/data/services/google_wallet_service.dart.
            l10n.t('card.walletUnavailable'),
          ),
        ],
        if (_walletState == _WalletUiState.failed) ...[
          const SizedBox(height: MahalliSpacing.sm),
          _notice(Icons.error_outline_rounded, MahalliColors.danger,
              l10n.t('card.walletFailed')),
        ],
      ],
    );
  }

  Widget _notice(IconData icon, Color color, String message) {
    return Container(
      padding: const EdgeInsets.all(MahalliSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(MahalliRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: MahalliSpacing.sm),
          Expanded(
            child: Text(message,
                style: const TextStyle(fontSize: 12.5, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MahalliSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: MahalliColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
