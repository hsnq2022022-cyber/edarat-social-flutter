import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../repositories/repository_contracts.dart';

/// ISOLATED DEMO FIXTURES — NOT REAL DATA.
///
/// No MAHALLI production backend is configured in this repository (verified:
/// the project contained no Supabase/Firebase/HTTP integration before this
/// rewrite). Until the real API exists, the app runs against these fixtures
/// through [DemoLoyaltyRepository]. Every screen shows a "demo mode" banner
/// so sample records are never mistaken for real customer or business data.
///
/// To go live: implement [LoyaltyRepository] against the real REST/GraphQL
/// contract and swap the binding in `lib/app/app_providers.dart`. No UI code
/// should need to change.
class DemoFixtures {
  const DemoFixtures._();

  static bool get enabled => true; // explicit demo-mode switch

  static final DateTime _now = DateTime.now();

  static DateTime daysAgo(int d) =>
      _now.subtract(Duration(days: d, hours: 3));

  static final Customer customer = Customer(
    id: 'demo-customer-1',
    fullName: 'Samia K.',
    email: 'samia@example.invalid',
    phone: '+000 000 0000',
    preferredLanguageCode: 'en',
  );

  static final List<Business> businesses = [
    Business(
      id: 'b1',
      name: 'Bloom Coffee House',
      category: 'Café',
      description:
          'Specialty coffee and fresh pastries roasted in the neighborhood every morning.',
      brandColorHex: '#6F4E37',
      address: '12 Garden Street',
      phone: '+000 555 0101',
    ),
    Business(
      id: 'b2',
      name: 'Green Basket Market',
      category: 'Grocery',
      description:
          'Local produce, pantry staples and zero-waste refills from independent farms.',
      brandColorHex: '#0E7C61',
      address: '48 Market Lane',
      phone: '+000 555 0102',
    ),
    Business(
      id: 'b3',
      name: 'Sole Fitness Studio',
      category: 'Fitness',
      description:
          'Small-group strength and mobility classes with certified coaches.',
      brandColorHex: '#2D4B8A',
      address: '5 Riverside Ave',
      phone: '+000 555 0103',
    ),
    Business(
      id: 'b4',
      name: 'Bookworm Corner',
      category: 'Bookstore',
      description:
          'Curated fiction, Arabic titles and weekly reading gatherings.',
      brandColorHex: '#8A3B3B',
      address: '77 Old Town Road',
      phone: '+000 555 0104',
    ),
    Business(
      id: 'b5',
      name: 'Wash & Wear Laundry',
      category: 'Services',
      description: 'Same-day wash, fold and press with free pickup.',
      brandColorHex: '#3D6AA8',
      address: '9 Cedar Square',
      phone: '+000 555 0105',
    ),
  ];

  /// Note: programs deliberately use different stamp counts (6, 10, 8, 5)
  /// to prove the card UI adapts to each program's configuration.
  static final Map<String, LoyaltyProgram> programsByBusiness = {
    'b1': LoyaltyProgram(
      id: 'p1',
      businessId: 'b1',
      name: 'Morning Rounds',
      stampsRequiredForReward: 6,
      rewardTitle: 'Free large latte',
      rewardDescription: 'Any size upgrade included, weekdays only.',
      stampRuleDescription: 'One stamp per coffee purchase over the counter.',
    ),
    'b2': LoyaltyProgram(
      id: 'p2',
      businessId: 'b2',
      name: 'Basket Points',
      stampsRequiredForReward: 10,
      rewardTitle: '\$10 off your basket',
      stampRuleDescription: 'One stamp for every \$15 spent in-store.',
    ),
    'b3': LoyaltyProgram(
      id: 'p3',
      businessId: 'b3',
      name: 'Class Streak',
      stampsRequiredForReward: 8,
      rewardTitle: 'Free personal training session',
      stampRuleDescription: 'One stamp per attended class.',
    ),
    'b4': LoyaltyProgram(
      id: 'p4',
      businessId: 'b4',
      name: 'Page Turners',
      stampsRequiredForReward: 5,
      rewardTitle: '15% off any book',
      joinable: false,
      stampRuleDescription: 'One stamp per purchase at the till.',
    ),
    'b5': LoyaltyProgram(
      id: 'p5',
      businessId: 'b5',
      name: 'Fresh Count',
      stampsRequiredForReward: 12,
      rewardTitle: 'One free load of laundry',
      stampRuleDescription: 'One stamp per standard load service.',
    ),
  };

  static LoyaltyProgram? programFor(String businessId) =>
      programsByBusiness[businessId];

  /// Cards the demo customer participates in. Stamp balances simulate an
  /// authoritative backend response (in production these come from the API).
  static final List<LoyaltyCard> cards = [
    LoyaltyCard(
      id: 'c1',
      programId: 'p1',
      businessId: 'b1',
      earnedStamps: 4,
      status: LoyaltyCardStatus.active,
      lastUsedAt: daysAgo(1),
    ),
    LoyaltyCard(
      id: 'c2',
      programId: 'p2',
      businessId: 'b2',
      earnedStamps: 7,
      status: LoyaltyCardStatus.active,
      lastUsedAt: daysAgo(2),
    ),
    LoyaltyCard(
      id: 'c3',
      programId: 'p3',
      businessId: 'b3',
      earnedStamps: 8,
      status: LoyaltyCardStatus.completed,
      lastUsedAt: daysAgo(4),
    ),
    LoyaltyCard(
      id: 'c4',
      programId: 'p5',
      businessId: 'b5',
      earnedStamps: 2,
      status: LoyaltyCardStatus.active,
      lastUsedAt: daysAgo(9),
    ),
  ];

  static List<CardBundle> bundles() {
    return cards.map((card) {
      final program = programsByBusiness.values
          .firstWhere((p) => p.id == card.programId);
      final business =
          businesses.firstWhere((b) => b.id == card.businessId);
      return CardBundle(
          card: card, program: program, business: business);
    }).toList();
  }

  static final List<Reward> rewards = [
    Reward(
      id: 'r1',
      cardId: 'c3',
      title: 'Free personal training session',
      description: 'Sole Fitness Studio',
      status: RewardStatus.available,
      requiredStamps: 8,
      earnedAt: daysAgo(4),
      redemptionInfo:
          'Show this reward at the studio desk. Valid 30 days from issue.',
    ),
    Reward(
      id: 'r2',
      cardId: 'c1',
      title: 'Free large latte',
      description: 'Bloom Coffee House',
      status: RewardStatus.redeemed,
      requiredStamps: 6,
      earnedAt: daysAgo(40),
      redeemedAt: daysAgo(36),
    ),
  ];

  static final List<ActivityEntry> activity = [
    ActivityEntry(id: 'a1', businessId: 'b1', type: ActivityType.stampEarned, date: daysAgo(1), amount: 1),
    ActivityEntry(id: 'a2', businessId: 'b2', type: ActivityType.stampEarned, date: daysAgo(2), amount: 2),
    ActivityEntry(id: 'a3', businessId: 'b3', type: ActivityType.rewardRedeemed, date: daysAgo(3)),
    ActivityEntry(id: 'a4', businessId: 'b3', type: ActivityType.stampEarned, date: daysAgo(4), amount: 1),
    ActivityEntry(id: 'a5', businessId: 'b2', type: ActivityType.programJoined, date: daysAgo(20)),
    ActivityEntry(id: 'a6', businessId: 'b1', type: ActivityType.programJoined, date: daysAgo(30)),
  ];
}

/// In-memory demo implementation of [LoyaltyRepository]. Mutations (joining
/// a program) persist only for the app session and are clearly demo-only.
class DemoLoyaltyRepository implements LoyaltyRepository {
  final List<LoyaltyCard> _cards = List.of(DemoFixtures.cards);
  final List<ActivityEntry> _activity = List.of(DemoFixtures.activity);
  final List<Reward> _rewards = List.of(DemoFixtures.rewards);

  static const Duration _latency = Duration(milliseconds: 350);

  Future<T> _delayed<T>(T value) =>
      Future<T>.delayed(_latency, () => value);

  @override
  Future<Customer> fetchCustomer() => _delayed(DemoFixtures.customer);

  @override
  Future<List<Business>> fetchBusinesses({String? query}) {
    var list = DemoFixtures.businesses;
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list
          .where((b) =>
              b.name.toLowerCase().contains(q) ||
              b.category.toLowerCase().contains(q))
          .toList();
    }
    return _delayed(list);
  }

  @override
  Future<Business> fetchBusiness(String businessId) => _delayed(
      DemoFixtures.businesses.firstWhere((b) => b.id == businessId));

  @override
  Future<LoyaltyProgram?> fetchProgramForBusiness(String businessId) =>
      _delayed(DemoFixtures.programFor(businessId));

  @override
  Future<List<CardBundle>> fetchMyCards() {
    final bundles = _cards.map((card) {
      final program = DemoFixtures.programsByBusiness.values
          .firstWhere((p) => p.id == card.programId);
      final business =
          DemoFixtures.businesses.firstWhere((b) => b.id == card.businessId);
      return CardBundle(card: card, program: program, business: business);
    }).toList();
    return _delayed(bundles);
  }

  @override
  Future<Reward?> fetchReward(String rewardId) => _delayed(
      _rewards.where((r) => r.id == rewardId).firstOrNull);

  @override
  Future<List<Reward>> fetchRewards() => _delayed(List.of(_rewards));

  @override
  Future<List<ActivityEntry>> fetchActivity() =>
      _delayed(List.of(_activity));

  @override
  Future<LoyaltyCard> joinProgram(String programId) async {
    final program = DemoFixtures.programsByBusiness.values
        .firstWhere((p) => p.id == programId);
    if (!program.joinable) {
      throw StateError('Program $programId is not joinable');
    }
    final existing =
        _cards.where((c) => c.programId == programId).firstOrNull;
    if (existing != null) return _delayed(existing);
    final card = LoyaltyCard(
      id: 'demo-card-${DateTime.now().millisecondsSinceEpoch}',
      programId: programId,
      businessId: program.businessId,
      earnedStamps: 0,
      status: LoyaltyCardStatus.active,
      lastUsedAt: DateTime.now(),
    );
    _cards.add(card);
    _activity.insert(
      0,
      ActivityEntry(
        id: 'demo-act-${card.id}',
        businessId: program.businessId,
        type: ActivityType.programJoined,
        date: DateTime.now(),
      ),
    );
    debugPrint('[MAHALLI][demo] joined program $programId -> ${card.id}');
    return _delayed(card);
  }
}

/// Demo auth backend: there is no identity provider wired up yet, so guest
/// sessions simply end locally. A production AuthBackend must talk to the
/// real MAHALLI auth service — endpoints are intentionally not invented.
class DemoAuthBackend implements AuthBackend {
  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    debugPrint('[MAHALLI][demo] signed out (local-only session)');
  }
}
