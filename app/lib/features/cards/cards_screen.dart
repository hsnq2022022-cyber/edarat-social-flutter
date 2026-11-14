import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../core/theme/mahalli_theme.dart';
import '../core/utils/widgets.dart';
import '../data/models/models.dart';
import '../data/repositories/repository_contracts.dart';
import '../main.dart';
import 'card_details_screen.dart';
import 'widgets/loyalty_card_widget.dart';

/// Tab 3: all of the customer's loyalty cards across businesses.
class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  late final LoyaltyRepository _repo;
  AsyncValue<List<CardBundle>> _state = const AsyncValue.loading();

  @override
  void initState() {
    super.initState();
    _repo = AppServicesScope.of(context).services.loyalty;
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncValue.loading());
    final result = await _state.wrap(_repo.fetchMyCards);
    if (!mounted) return;
    setState(() => _state = result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    final services = AppServicesScope.of(context).services;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('home.myCards'))),
      body: Column(
        children: [
          if (services.demoMode) const DemoModeBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: switch (_state.status) {
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
    final bundles = _state.data ?? const <CardBundle>[];
    if (bundles.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          MahalliEmptyState(
            icon: Icons.credit_card_outlined,
            titleKey: 'home.noCardsTitle',
            bodyKey: 'home.noCardsBody',
          ),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(MahalliSpacing.lg),
      itemCount: bundles.length,
      itemBuilder: (context, index) {
        final bundle = bundles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: MahalliSpacing.lg),
          child: AspectRatio(
            // Fixed aspect keeps cards responsive across Android widths.
            aspectRatio: 16 / 9.4,
            child: LoyaltyCardWidget(
              bundle: bundle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CardDetailsScreen(bundle: bundle),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
