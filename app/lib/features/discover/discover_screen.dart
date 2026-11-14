import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/mahalli_theme.dart';
import '../../core/utils/widgets.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository_contracts.dart';
import '../../main.dart';
import 'business_details_screen.dart';

/// Tab 2: searchable list of participating businesses with their loyalty
/// program summary. Tapping opens the business details page, where the
/// customer can join the program (a backend operation).
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final LoyaltyRepository _repo;
  final TextEditingController _search = TextEditingController();
  AsyncValue<List<Business>> _state = const AsyncValue.loading();

  @override
  void initState() {
    super.initState();
    _repo = AppServicesScope.of(context).services.loyalty;
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncValue.loading());
    final result = await _state.wrap(
        () => _repo.fetchBusinesses(query: _search.text));
    if (!mounted) return;
    setState(() => _state = result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    final services = AppServicesScope.of(context).services;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('discover.title'))),
      body: Column(
        children: [
          if (services.demoMode) const DemoModeBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                MahalliSpacing.lg, MahalliSpacing.md, MahalliSpacing.lg, 0),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
              decoration: InputDecoration(
                hintText: l10n.t('discover.searchHint'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.north_west_rounded),
                  onPressed: _load,
                  tooltip: MaterialLocalizations.of(context)
                      .searchBarWidgetSearchIconTooltip,
                ),
              ),
            ),
          ),
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
    final businesses = _state.data ?? const <Business>[];
    if (businesses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 60),
          MahalliEmptyState(
            icon: Icons.storefront_outlined,
            titleKey: 'discover.emptyTitle',
            bodyKey: 'discover.emptyBody',
          ),
        ],
      );
    }

    // Load programs for each business once, then cache in a map for tiles.
    return FutureBuilder<Map<String, LoyaltyProgram?>>(
      future: _programsFor(businesses),
      builder: (context, snapshot) {
        final programs = snapshot.data ?? const <String, LoyaltyProgram?>{};
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(MahalliSpacing.lg),
          itemCount: businesses.length,
          itemBuilder: (context, index) {
            final business = businesses[index];
            return BusinessTile(
              business: business,
              program: programs[business.id],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BusinessDetailsScreen(businessId: business.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, LoyaltyProgram?>> _programsFor(
      List<Business> businesses) async {
    final map = <String, LoyaltyProgram?>{};
    for (final b in businesses) {
      try {
        map[b.id] = await _repo.fetchProgramForBusiness(b.id);
      } catch (_) {
        map[b.id] = null;
      }
    }
    return map;
  }
}

/// Reusable tile: logo monogram, name, category and program summary.
class BusinessTile extends StatelessWidget {
  const BusinessTile({
    super.key,
    required this.business,
    required this.program,
    this.onTap,
  });

  final Business business;
  final LoyaltyProgram? program;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    final brand = MahalliColors.fromHex(business.brandColorHex);

    return Card(
      margin: const EdgeInsets.only(bottom: MahalliSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MahalliRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(MahalliSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: brand,
                  borderRadius: BorderRadius.circular(MahalliRadius.md),
                ),
                child: Text(
                  business.name.isEmpty
                      ? '?'
                      : business.name.characters.first.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
              const SizedBox(width: MahalliSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      business.category,
                      style: const TextStyle(
                          color: MahalliColors.textSecondary, fontSize: 12.5),
                    ),
                    if (program != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MahalliSpacing.sm, vertical: 3),
                        decoration: BoxDecoration(
                          color: MahalliColors.surfaceAlt,
                          borderRadius:
                              BorderRadius.circular(MahalliRadius.pill),
                        ),
                        child: Text(
                          l10n.t('discover.programSummary', params: {
                            'stamps':
                                '${program!.stampsRequiredForReward}',
                            'reward': program!.rewardTitle,
                          }),
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: MahalliColors.primaryDark),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: MahalliColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
