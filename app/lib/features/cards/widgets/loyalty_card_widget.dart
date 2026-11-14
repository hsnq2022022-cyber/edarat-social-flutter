import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/mahalli_theme.dart';
import '../../../data/models/models.dart';

/// The signature MAHALLI component: an interactive digital loyalty card.
///
/// The stamp grid adapts to `program.stampsRequiredForReward` — nothing in
/// this widget assumes a fixed count such as 8. Filled positions reflect the
/// authoritative backend balance (`card.earnedStamps`) only.
class LoyaltyCardWidget extends StatelessWidget {
  const LoyaltyCardWidget({
    super.key,
    required this.bundle,
    this.onTap,
    this.compact = false,
  });

  final CardBundle bundle;
  final VoidCallback? onTap;

  /// Smaller variant used in horizontal carousels on the home screen.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    final brand = MahalliColors.fromHex(bundle.business.brandColorHex);
    final completed = bundle.program.stampsRequiredForReward > 0 &&
        bundle.card.earnedStamps >= bundle.program.stampsRequiredForReward;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MahalliRadius.card),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [brand, Color.lerp(brand, Colors.black, 0.35)!],
          ),
          boxShadow: [
            BoxShadow(
              color: brand.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.all(compact ? MahalliSpacing.md : MahalliSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _BusinessLogo(business: bundle.business, size: compact ? 34 : 44),
                const SizedBox(width: MahalliSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.business.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: compact ? 14 : 17,
                          fontFamily: 'Handicrafts',
                        ),
                      ),
                      Text(
                        bundle.program.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: compact ? 11 : 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(
                  label: l10n.t('card.status.${bundle.card.status.name}'),
                  positive: completed,
                ),
              ],
            ),
            SizedBox(height: compact ? MahalliSpacing.md : MahalliSpacing.lg),
            _StampGrid(
              earned: bundle.card.earnedStamps,
              required: bundle.program.stampsRequiredForReward,
              compact: compact,
            ),
            SizedBox(height: compact ? MahalliSpacing.sm : MahalliSpacing.md),
            if (!compact)
              ClipRRect(
                borderRadius: BorderRadius.circular(MahalliRadius.pill),
                child: LinearProgressIndicator(
                  value: bundle.progress,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: const AlwaysStoppedAnimation(MahalliColors.accent),
                ),
              ),
            if (!compact) const SizedBox(height: MahalliSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.t('card.stampsProgress', params: {
                      'earned': '${bundle.card.earnedStamps}',
                      'required': '${bundle.program.stampsRequiredForReward}',
                    }),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.8)),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: MahalliSpacing.xs),
              Text(
                completed
                    ? l10n.t('card.ready')
                    : l10n.t('card.remaining',
                        params: {'count': '${bundle.stampsRemaining}'}),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: MahalliSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.card_giftcard_rounded,
                      size: 16, color: MahalliColors.accent),
                  const SizedBox(width: MahalliSpacing.xs),
                  Expanded(
                    child: Text(
                      '${l10n.t('card.rewardLabel')}: ${bundle.program.rewardTitle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BusinessLogo extends StatelessWidget {
  const _BusinessLogo({required this.business, required this.size});

  final Business business;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Logos are served by the backend as URLs; rendering them requires a
    // network image, which is intentionally avoided here so demo fixtures
    // never depend on unreachable hosts. A monogram stands in until the
    // production image pipeline is wired up.
    final initial =
        business.name.isEmpty ? '?' : business.name.characters.first;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Text(
        initial.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.45,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.positive});

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: MahalliSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: positive
            ? MahalliColors.success
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(MahalliRadius.pill),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Renders exactly `required` positions; the first `earned` are filled.
class _StampGrid extends StatelessWidget {
  const _StampGrid({
    required this.earned,
    required this.required,
    required this.compact,
  });

  final int earned;
  final int required;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (required <= 0) return const SizedBox.shrink();
    final size = compact ? 22.0 : 30.0;
    final gap = compact ? 5.0 : 7.0;
    final filledCount = earned.clamp(0, required);

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (var i = 0; i < required; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filledCount
                  ? MahalliColors.accent
                  : Colors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: i < filledCount
                    ? MahalliColors.accent
                    : Colors.white.withValues(alpha: 0.55),
                width: 1.4,
              ),
            ),
            child: i < filledCount
                ? Icon(Icons.check_rounded,
                    size: size * 0.6, color: Colors.white)
                : Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: size * 0.38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
      ],
    );
  }
}
