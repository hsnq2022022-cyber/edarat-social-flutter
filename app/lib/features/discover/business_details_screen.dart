import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/mahalli_theme.dart';
import '../../core/utils/widgets.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository_contracts.dart';
import '../../main.dart';
import '../cards/card_details_screen.dart';

/// Business details page: identity/branding, loyalty program explanation,
/// how stamps are earned, the configured reward + required stamp count, and
/// a Join button that calls the repository (backend operation). The client
/// never grants itself participation — joining goes through the repository.
class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key, required this.businessId});

  final String businessId;

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  late final LoyaltyRepository _repo;
  AsyncValue<Business>? _business;
  AsyncValue<LoyaltyProgram?> _program = const AsyncValue.loading();
  AsyncValue<List<CardBundle>> _myCards = const AsyncValue.loading();
  bool _joining = false;

  @override
  void initState() {
    super.initState();
    _repo = AppServicesScope.of(context).services.loyalty;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _business = const AsyncValue.loading();
      _program = const AsyncValue.loading();
      _myCards = const AsyncValue.loading();
    });
    final b = await _business!.wrap(() => _repo.fetchBusiness(widget.businessId));
    final p = await _program.wrap(() => _repo.fetchProgramForBusiness(widget.businessId));
    final c = await _myCards.wrap(_repo.fetchMyCards);
    if (!mounted) return;
    setState(() {
      _business = b;
      _program = p;
      _myCards = c;
    });
  }

  CardBundle? get _existingCard {
    final program = _program.data;
    if (program == null) return null;
    for (final bundle in _myCards.data ?? const <CardBundle>[]) {
      if (bundle.program.id == program.id) return bundle;
    }
    return null;
  }

  Future<void> _join() async {
    final program = _program.data;
    if (program == null) return;
    setState(() => _joining = true);
    final l10n = MahalliLocalizations.of(context);
    try {
      await _repo.joinProgram(program.id);
      if (!mounted) return;
      showMahalliSnack(context, l10n.t('discover.joined'));
      // Navigate the customer straight to their new digital card.
      final bundles = await _repo.fetchMyCards();
      if (!mounted) return;
      final bundle = bundles.where((x) => x.program.id == program.id).firstOrNull;
      if (bundle != null) {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => CardDetailsScreen(bundle: bundle),
        ));
      }
    } catch (_) {
      if (mounted) {
        showMahalliSnack(context, l10n.t('discover.joinFailed'), isError: true);
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);

    if (_business == null || _business!.isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const MahalliLoadingView(),
      );
    }
    if (_business!.hasError) {
      return Scaffold(
        appBar: AppBar(),
        body: MahalliErrorView(onRetry: _load),
      );
    }

    final business = _business!.data!;
    final program = _program.data;
    final brand = MahalliColors.fromHex(business.brandColorHex);
    final joined = _existingCard != null;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            backgroundColor: brand,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _Header(business: business, brand: brand),
            ),
          ),
        ],
        body: ListView(
          padding: const EdgeInsets.all(MahalliSpacing.lg),
          children: [
            if (program == null) ...[
              MahalliEmptyState(
                icon: Icons.info_outline_rounded,
                titleKey: 'business.program',
                bodyKey: 'discover.emptyBody',
              ),
            ] else ...[
              SectionHeader(titleKey: 'business.program'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(MahalliSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(program.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: MahalliSpacing.sm),
                      _labeledRow(l10n.t('business.howToEarn'),
                          program.stampRuleDescription ??
                              l10n.t('business.rewardNote')),
                      _labeledRow(
                          l10n.t('card.stampsProgress', params: {
                            'earned': '',
                            'required': '${program.stampsRequiredForReward}'
                          }).trim(),
                          l10n.t('discover.programSummary', params: {
                            'stamps': '${program.stampsRequiredForReward}',
                            'reward': program.rewardTitle,
                          })),
                      _labeledRow(l10n.t('business.reward'),
                          '${program.rewardTitle}'
                          '${program.rewardDescription != null ? '\n${program.rewardDescription}' : ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: MahalliSpacing.xl),
              if (joined)
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          CardDetailsScreen(bundle: _existingCard!),
                    ),
                  ),
                  icon: const Icon(Icons.credit_card_rounded),
                  label: Text(l10n.t('discover.joined')),
                )
              else if (!program.joinable)
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.lock_outline_rounded),
                  label: Text(l10n.t('discover.notJoinable')),
                )
              else
                FilledButton.icon(
                  onPressed: _joining ? null : _join,
                  icon: _joining
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.add_circle_outline_rounded),
                  label: Text(
                      _joining ? l10n.t('discover.joining') : l10n.t('discover.join')),
                ),
            ],
            const SizedBox(height: MahalliSpacing.xl),
            SectionHeader(titleKey: 'business.about'),
            Text(
              business.description ?? '',
              style: const TextStyle(height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: MahalliSpacing.lg),
            SectionHeader(titleKey: 'business.contact'),
            if (business.address != null)
              _infoRow(Icons.location_on_outlined,
                  l10n.t('business.address'), business.address!),
            if (business.phone != null)
              _infoRow(Icons.phone_outlined,
                  l10n.t('business.phone'), business.phone!),
          ],
        ),
      ),
    );
  }

  Widget _labeledRow(String label, String value) {
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MahalliSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: MahalliColors.textSecondary),
          const SizedBox(width: MahalliSpacing.sm),
          Expanded(
            child: Text('$label: $value',
                style: const TextStyle(fontSize: 13.5, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.business, required this.brand});

  final Business business;
  final Color brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [brand, Color.lerp(brand, Colors.black, 0.4)!],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
          MahalliSpacing.lg, 60, MahalliSpacing.lg, MahalliSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(MahalliRadius.md),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: Text(
              business.name.isEmpty
                  ? '?'
                  : business.name.characters.first.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Handicrafts'),
            ),
          ),
          const SizedBox(height: MahalliSpacing.md),
          Text(
            business.name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Handicrafts'),
          ),
          Text(
            business.category,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
