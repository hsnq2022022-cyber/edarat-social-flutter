import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/mahalli_theme.dart';
import '../../core/utils/widgets.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository_contracts.dart';
import '../../main.dart';
import '../cards/card_details_screen.dart';
import '../rewards/rewards_screen.dart';

/// Tab 1: personalized customer home. Loyalty cards overview, recently
/// accessed businesses, available rewards and a clear path to Discover.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LoyaltyRepository _repo;
  AsyncValue<Customer> _customer = const AsyncValue.loading();
  AsyncValue<List<CardBundle>> _cards = const AsyncValue.loading();
  AsyncValue<List<Reward>> _rewards = const AsyncValue.loading();

  @override
  void initState() {
    super.initState();
    _repo = AppServicesScope.of(context).services.loyalty;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _customer = const AsyncValue.loading();
      _cards = const AsyncValue.loading();
      _rewards = const AsyncValue.loading();
    });
    final c = await _customer.wrap(_repo.fetchCustomer);
    final b = await _cards.wrap(_repo.fetchMyCards);
    final r = await _rewards.wrap(_repo.fetchRewards);
    if (!mounted) return;
    setState(() {
      _customer = c;
      _cards = b;
      _rewards = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    final services = AppServicesScope.of(context).services;
    final name = _customer.data?.fullName ?? '';
    final bundles = _cards.data ?? const <CardBundle>[];
    final recent = bundles.where((b) => b.card.lastUsedAt != null).toList()
      ..sort((a, b) => b.card.lastUsedAt!.compareTo(a.card.lastUsedAt!));
    final availableRewards =
        (_rewards.data ?? const <Reward>[]).where((r) => r.isAvailable);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (services.demoMode) const DemoModeBanner(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.all(MahalliSpacing.lg),
                  children: [
                    Text(
                      l10n.t('home.greeting', params: {'name': name}),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    Text(l10n.t('home.subtitle'),
                        style: const TextStyle(
                            color: MahalliColors.textSecondary)),
                    const SizedBox(height: MahalliSpacing.xl),
                    SectionHeader(
                      titleKey: 'home.myCards',
                      trailing: TextButton(
                        onPressed: () {}, // Cards tab is one swipe away.
                        child: Text(l10n.t('home.viewAll')),
                      ),
                    ),
                    if (_cards.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: MahalliSpacing.xl),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (bundles.isEmpty)
                      MahalliEmptyState(
                        icon: Icons.credit_card_outlined,
                        titleKey: 'home.noCardsTitle',
                        bodyKey: 'home.noCardsBody',
                        action: FilledButton(
                          onPressed: () {},
                          child: Text(l10n.t('home.discoverPrograms')),
                        ),
                      )
                    else
                      SizedBox(
                        height: 210,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: bundles.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: MahalliSpacing.md),
                          itemBuilder: (context, index) {
                            final bundle = bundles[index];
                            return SizedBox(
                              width: 300,
                              child: LoyaltyCardWidget(
                                bundle: bundle,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        CardDetailsScreen(bundle: bundle),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: MahalliSpacing.xl),
                    SectionHeader(titleKey: 'home.recentlyUsed'),
                    ...recent
                        .take(3)
                        .map((b) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: MahalliColors.fromHex(
                                    b.business.brandColorHex),
                                child: Text(
                                  b.business.name.isEmpty
                                      ? '?'
                                      : b.business.name.characters.first
                                          .toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              title: Text(b.business.name),
                              subtitle: Text(formatLocalizedDate(
                                  b.card.lastUsedAt!, context)),
                              trailing: const Icon(
                                  Icons.chevron_right_rounded),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      CardDetailsScreen(bundle: b),
                                ),
                              ),
                            )),
                    const SizedBox(height: MahalliSpacing.lg),
                    SectionHeader(titleKey: 'home.availableRewards'),
                    ...availableRewards.map((r) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.redeem_rounded,
                              color: MahalliColors.accentDark),
                          title: Text(r.title),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const RewardsScreen(),
                            ),
                          ),
                        )),
                    const SizedBox(height: MahalliSpacing.xl),
                    FilledButton.icon(
                      onPressed: () => DefaultTabController.maybeOf(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: MahalliColors.accent,
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.explore_rounded),
                      label: Text(l10n.t('home.discoverPrograms')),
                    ),
                    const SizedBox(height: MahalliSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
