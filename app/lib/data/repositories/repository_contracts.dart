import 'package:flutter/foundation.dart';
import '../../data/models/models.dart';

/// Contract for the MAHALLI customer-facing backend.
///
/// IMPORTANT: stamp balances and reward eligibility are ALWAYS authoritative
/// from the backend. This application never issues stamps or redeems rewards
/// locally; it only requests backend operations and reflects their results.
abstract class LoyaltyRepository {
  Future<Customer> fetchCustomer();

  Future<List<Business>> fetchBusinesses({String? query});

  Future<Business> fetchBusiness(String businessId);

  Future<LoyaltyProgram?> fetchProgramForBusiness(String businessId);

  /// Cards the customer participates in, joined with program + business.
  Future<List<CardBundle>> fetchMyCards();

  Future<Reward?> fetchReward(String rewardId);

  Future<List<Reward>> fetchRewards();

  Future<List<ActivityEntry>> fetchActivity();

  /// Requests the backend to enroll the customer in a program. Returns the
  /// created card, or throws if the backend rejects/does not support joining.
  Future<LoyaltyCard> joinProgram(String programId);
}

/// Contract for authentication. No real identity provider is configured in
/// this repository yet — see `DemoAuthBackend`. A production implementation
/// (e.g. OAuth/SMS OTP against the MAHALLI backend) must be added server-side
/// first; endpoints are intentionally NOT invented here.
abstract class AuthBackend {
  Future<void> signOut();
}

/// Wallet pass service contract. Implementations must only ever launch
/// backend-generated signed Save URLs; they must never mint JWTs locally.
abstract class GoogleWalletService {
  /// Returns null when no signed save URL exists for [card] (the normal case
  /// until the backend Wallet integration ships).
  Future<String?> getSignedSaveUrl(LoyaltyCard card);

  /// Attempts to open the signed save URL. Completes with true ONLY if the
  /// platform actually launched the Wallet app.
  Future<bool> addCardToWallet(LoyaltyCard card);
}

/// Simple result wrapper used by controllers to distinguish loading/error.
enum AsyncStatus { idle, loading, ready, error }

class AsyncValue<T> {
  const AsyncValue._(this.status, this.data, this.error);

  const AsyncValue.idle() : this._(AsyncStatus.idle, null, null);
  const AsyncValue.loading() : this._(AsyncStatus.loading, null, null);
  const AsyncValue.data(T value) : this._(AsyncStatus.ready, value, null);
  const AsyncValue.error(Object exception)
      : this._(AsyncStatus.error, null, exception);

  final AsyncStatus status;
  final T? data;
  final Object? error;

  bool get isLoading => status == AsyncStatus.loading;
  bool get hasError => status == AsyncStatus.error;
  bool get hasData => status == AsyncStatus.ready;

  Future<AsyncValue<T>> wrap(Future<T> Function() operation) async {
    try {
      return AsyncValue.data(await operation());
    } on Object catch (e) {
      return AsyncValue.error(e);
    }
  }
}

/// Minimal ChangeNotifier-based controller helper so feature controllers stay
/// uniform without pulling in extra packages.
class MahalliController extends ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
