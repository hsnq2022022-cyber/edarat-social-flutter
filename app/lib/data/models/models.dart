/// Core domain models for the MAHALLI customer application.
///
/// These models mirror the shape of records returned by the MAHALLI backend.
/// Field names in `fromJson` follow a snake_case REST convention; adjust them
/// once the production API contract is finalized.
library;

enum LoyaltyCardStatus { active, completed, expired, suspended }

LoyaltyCardStatus loyaltyCardStatusFromString(String? value) {
  switch (value) {
    case 'completed':
      return LoyaltyCardStatus.completed;
    case 'expired':
      return LoyaltyCardStatus.expired;
    case 'suspended':
      return LoyaltyCardStatus.suspended;
    default:
      return LoyaltyCardStatus.active;
  }
}

enum RewardStatus { available, redeemed, expired }

RewardStatus rewardStatusFromString(String? value) {
  switch (value) {
    case 'redeemed':
      return RewardStatus.redeemed;
    case 'expired':
      return RewardStatus.expired;
    default:
      return RewardStatus.available;
  }
}

enum ActivityType { stampEarned, rewardRedeemed, programJoined }

ActivityType activityTypeFromString(String? value) {
  switch (value) {
    case 'reward_redeemed':
      return ActivityType.rewardRedeemed;
    case 'program_joined':
      return ActivityType.programJoined;
    default:
      return ActivityType.stampEarned;
  }
}

class Customer {
  const Customer({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.preferredLanguageCode,
  });

  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? preferredLanguageCode;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        fullName: json['full_name'] as String? ?? '',
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        preferredLanguageCode: json['preferred_language'] as String?,
      );
}

class Business {
  const Business({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.logoUrl,
    this.brandColorHex = '#0E7C61',
    this.address,
    this.phone,
  });

  final String id;
  final String name;
  final String category;
  final String? description;
  final String? logoUrl;
  final String brandColorHex;
  final String? address;
  final String? phone;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? '',
        description: json['description'] as String?,
        logoUrl: json['logo_url'] as String?,
        brandColorHex: json['brand_color'] as String? ?? '#0E7C61',
        address: json['address'] as String?,
        phone: json['phone'] as String?,
      );
}

class LoyaltyProgram {
  const LoyaltyProgram({
    required this.id,
    required this.businessId,
    required this.name,
    required this.stampsRequiredForReward,
    required this.rewardTitle,
    this.rewardDescription,
    this.stampRuleDescription,
    this.joinable = true,
  });

  final String id;
  final String businessId;
  final String name;

  /// Stamps required to unlock the reward. This always comes from the
  /// backend program configuration — never hardcoded in the UI.
  final int stampsRequiredForReward;
  final String rewardTitle;
  final String? rewardDescription;
  final String? stampRuleDescription;
  final bool joinable;

  factory LoyaltyProgram.fromJson(Map<String, dynamic> json) => LoyaltyProgram(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        name: json['name'] as String? ?? '',
        stampsRequiredForReward:
            (json['stamps_required'] as num?)?.toInt() ?? 0,
        rewardTitle: json['reward_title'] as String? ?? '',
        rewardDescription: json['reward_description'] as String?,
        stampRuleDescription: json['stamp_rule_description'] as String?,
        joinable: json['joinable'] as bool? ?? true,
      );
}

class LoyaltyCard {
  const LoyaltyCard({
    required this.id,
    required this.programId,
    required this.businessId,
    required this.earnedStamps,
    required this.status,
    this.walletObjectUrl,
    this.lastUsedAt,
  });

  final String id;
  final String programId;
  final String businessId;

  /// Authoritative stamp balance supplied by the backend.
  final int earnedStamps;
  final LoyaltyCardStatus status;

  /// Backend-generated signed "Save to Google Wallet" URL, when available.
  final String? walletObjectUrl;
  final DateTime? lastUsedAt;

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) => LoyaltyCard(
        id: json['id'] as String,
        programId: json['program_id'] as String,
        businessId: json['business_id'] as String,
        earnedStamps: (json['earned_stamps'] as num?)?.toInt() ?? 0,
        status: loyaltyCardStatusFromString(json['status'] as String?),
        walletObjectUrl: json['wallet_object_url'] as String?,
        lastUsedAt: json['last_used_at'] != null
            ? DateTime.tryParse(json['last_used_at'] as String)
            : null,
      );
}

class Stamp {
  const Stamp({
    required this.id,
    required this.cardId,
    required this.earnedAt,
    this.source,
    this.note,
  });

  final String id;
  final String cardId;
  final DateTime earnedAt;
  final String? source;
  final String? note;

  factory Stamp.fromJson(Map<String, dynamic> json) => Stamp(
        id: json['id'] as String,
        cardId: json['card_id'] as String,
        earnedAt: DateTime.tryParse(json['earned_at'] as String? ?? '') ??
            DateTime.now(),
        source: json['source'] as String?,
        note: json['note'] as String?,
      );
}

class Reward {
  const Reward({
    required this.id,
    required this.cardId,
    required this.title,
    required this.status,
    this.description,
    this.redemptionInfo,
    this.requiredStamps,
    this.earnedAt,
    this.redeemedAt,
  });

  final String id;
  final String cardId;
  final String title;
  final String? description;
  final RewardStatus status;

  /// Redemption instructions / code supplied by the backend, if any.
  final String? redemptionInfo;
  final int? requiredStamps;
  final DateTime? earnedAt;
  final DateTime? redeemedAt;

  bool get isAvailable => status == RewardStatus.available;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json['id'] as String,
        cardId: json['card_id'] as String,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        status: rewardStatusFromString(json['status'] as String?),
        redemptionInfo: json['redemption_info'] as String?,
        requiredStamps: (json['required_stamps'] as num?)?.toInt(),
        earnedAt: json['earned_at'] != null
            ? DateTime.tryParse(json['earned_at'] as String)
            : null,
        redeemedAt: json['redeemed_at'] != null
            ? DateTime.tryParse(json['redeemed_at'] as String)
            : null,
      );
}

class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.businessId,
    required this.type,
    required this.date,
    this.title,
    this.amount,
  });

  final String id;
  final String businessId;
  final ActivityType type;
  final DateTime date;
  final String? title;

  /// Stamp count for earn events (positive), unused for other event types.
  final int? amount;

  factory ActivityEntry.fromJson(Map<String, dynamic> json) => ActivityEntry(
        id: json['id'] as String,
        businessId: json['business_id'] as String,
        type: activityTypeFromString(json['type'] as String?),
        date: DateTime.tryParse(json['date'] as String? ?? '') ??
            DateTime.now(),
        title: json['title'] as String?,
        amount: (json['amount'] as num?)?.toInt(),
      );
}

/// Aggregated view used across screens: a card joined with its program and
/// business. Built by repositories, never persisted locally.
class CardBundle {
  const CardBundle({
    required this.card,
    required this.program,
    required this.business,
  });

  final LoyaltyCard card;
  final LoyaltyProgram program;
  final Business business;

  int get stampsRemaining =>
      (program.stampsRequiredForReward - card.earnedStamps).clamp(0, 1 << 30);

  double get progress => program.stampsRequiredForReward <= 0
      ? 0
      : (card.earnedStamps / program.stampsRequiredForReward).clamp(0.0, 1.0);
}
