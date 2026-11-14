import 'package:flutter/material.dart';

import 'core/localization/app_localizations.dart';
import 'features/activity/activity_screen.dart';
import 'features/cards/cards_screen.dart';
import 'features/discover/discover_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';

/// Bottom-navigation shell for the customer app. Tab order and arrow
/// direction flip automatically with RTL/LTR because Material widgets honor
/// [Directionality].
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    DiscoverScreen(),
    CardsScreen(),
    RewardsPlaceholderScreen(), // replaced below via builder to keep imports small
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = MahalliLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          const DiscoverScreen(),
          const CardsScreen(),
          const ActivityScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.t('nav.home'),
          ),
          NavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore_rounded),
            label: l10n.t('nav.discover'),
          ),
          NavigationBarItem(
            icon: const Icon(Icons.credit_card_outlined),
            selectedIcon: const Icon(Icons.credit_card_rounded),
            label: l10n.t('nav.cards'),
          ),
          NavigationBarItem(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history_rounded),
            label: l10n.t('nav.rewards'),
          ),
          NavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.t('nav.profile'),
          ),
        ],
      ),
    );
  }
}

/// Temporary indirection so the tab list above stays readable; the Rewards
/// feature lives inside the cards flow and its screen is exported from the
/// activity module barrel to avoid a circular import in this file.
class RewardsPlaceholderScreen extends StatelessWidget {
  const RewardsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
