import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../core/theme/mahalli_theme.dart';
import '../core/utils/widgets.dart';
import '../data/models/models.dart';
import '../data/repositories/repository_contracts.dart';
import '../main.dart';

/// Tab 4: Rewards. Available vs redeemed rewards, always tied back to the
/// owning business/card. Redemption itself happens at the business — this
/// app never marks a reward as redeemed without backend confirmation.
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late final LoyaltyRepository _repo;
  AsyncValue<List<Reward>> _rewards = const AsyncValue.loading();
  AsyncValue<List<CardBundle>> _bundles = const AsyncValue.loading();

  @override
  void initState() {
    super.initState();
    _repo = AppServicesScope.of(context).services.loyalty;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _rewards = const AsyncValue.loading();
      _bundles = const AsyncValue.loading();
    });
    final r = await _rewards.wrap(_repo.fetchRewards);
    final b = await _bundles.wrap(_repo.fetchMyCards);
    if (!mounted) return;
    setState(() {
      _rewards = r;
      _bundles = b;
    });
  }

  CardBundle? _bundleFor(Reward reward) {
    for (final bundle in _bundles.data ?? const <CardBundle>[]) {
      if (bundle.card.id == reward.cardId) return bundle;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    final services = AppServicesScope.of(context).services;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('rewards.title'))),
      body: Column(
        children: [
          if (services.demoMode) const DemoModeBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: switch (_rewards.status) {
                AsyncStatus.loading => const MahalliLoadingView(),
                AsyncStatus.error => MahalliErrorView(onRetry: _load),
                _ => _list(context, l10n),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(BuildContext context, MahalliLocalizations l10n) {
    final rewards = _rewards.data ?? const <Reward>[];
    final available =
        rewards.where((r) => r.isAvailable).toList(growable: false);
    final others =
        rewards.where((r) => !r.isAvailable).toList(growable: false);

    if (rewards.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          MahalliEmptyState(
            icon: Icons.redeem_outlined,
            titleKey: 'rewards.emptyAvailable',
            bodyKey: 'home.noCardsBody',
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(MahalliSpacing.lg),
      children: [
        SectionHeader(titleKey: 'rewards.available'),
        ...available.map((r) => _rewardTile(context, l10n, r)),
        const SizedBox(height: MahalliSpacing.md),
        SectionHeader(titleKey: 'rewards.redeemed'),
        ...others.map((r) => _rewardTile(context, l10n, r)),
        const SizedBox(height: MahalliSpacing.md),
        Text(
          l10n.t('rewards.note'),
          style: const TextStyle(
              color: MahalliColors.textSecondary, fontSize: 12, height: 1.4),
        ),
      ],
    );
  }

  Widget _rewardTile(
      BuildContext context, MahalliLocalizations l10n, Reward reward) {
    final bundle = _bundleFor(reward);
    final brand = bundle != null
        ? MahalliColors.fromHex(bundle.business.brandColorHex)
        : MahalliColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: MahalliSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(MahalliSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.redeem_rounded, color: brand),
                  const SizedBox(width: MahalliSpacing.sm),
                  Expanded(
                    child: Text(
                      reward.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MahalliSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: reward.isAvailable
                          ? MahalliColors.success
                          : MahalliColors.surfaceAlt,
                      borderRadius:
                          BorderRadius.circular(MahalliRadius.pill),
                    ),
                    child: Text(
                      reward.isAvailable
                          ? l10n.t('rewards.available')
                          : l10n.t('rewards.redeemed'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: reward.isAvailable
                            ? Colors.white
                            : MahalliColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              if (bundle != null) ...[
                const SizedBox(height: MahalliSpacing.xs),
                Text(bundle.business.name,
                    style: const TextStyle(
                        color: MahalliColors.textSecondary, fontSize: 13)),
              ],
              if (reward.earnedAt != null) ...[
                const SizedBox(height: MahalliSpacing.xs),
                Text(
                  l10n.t(reward.isAvailable ? 'rewards.earnedAt' : 'rewards.redeemedAt',
                      params: {
                        'date': formatLocalizedDate(
                            reward.isAvailable
                                ? reward.earnedAt!
                                : (reward.redeemedAt ?? reward.earnedAt!),
                            context)
                      }),
                  style: const TextStyle(
                      color: MahalliColors.textSecondary, fontSize: 12),
                ),
              ],
              if (reward.redemptionInfo != null) ...[
                const SizedBox(height: MahalliSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(MahalliSpacing.md),
                  decoration: BoxDecoration(
                    color: MahalliColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(MahalliRadius.sm),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.t('rewards.redeemInfo'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(reward.redemptionInfo!,
                          style: const TextStyle(fontSize: 12.5, height: 1.35)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
