import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../repositories/repository_contracts.dart';

/// Google Wallet integration layer for MAHALLI.
///
/// SECURITY MODEL (non-negotiable):
///  * The Flutter client NEVER holds a service-account JSON, private key or
///    any signing secret. Nothing wallet-related is stored in assets, Dart
///    code or Gradle files.
///  * JWT / signed "Save to Google Wallet" URLs must be minted by the secure
///    MAHALLI backend using Google's recommended flow:
///      POST {MAHALLI_BACKEND}/v1/wallet/loyalty/save-url?cardId=...
///      -> { "signedJwt": "<JWT>", "saveUrl": "https://pay.google.com/gp/p/save?jwt=..." }
///    The client only ever opens `saveUrl` (or launches the Wallet app with
///    the `googlewallet:` intent on the returned JWT).
///  * Issuer ID, Class ID and Object ID are backend-owned configuration;
///    they are deliberately NOT invented in this client.
///
/// STATUS: The backend operation above is **not implemented yet**. Until it
/// ships, [HttpWalletService] finds no signed URL on the card and the UI
/// shows an honest "not available yet" state — it never simulates success.
class HttpWalletService implements GoogleWalletService {
  HttpWalletService({WalletSaveUrlResolver? resolver})
      : _resolver = resolver ?? const NoopWalletSaveUrlResolver();

  final WalletSaveUrlResolver _resolver;

  @override
  Future<String?> getSignedSaveUrl(LoyaltyCard card) async {
    // Prefer a URL already attached by the backend to the card record.
    if (card.walletObjectUrl != null && card.walletObjectUrl!.isNotEmpty) {
      return card.walletObjectUrl;
    }
    // Otherwise ask the (future) backend endpoint. Noop until configured.
    return _resolver.resolve(card.id);
  }

  @override
  Future<bool> addCardToWallet(LoyaltyCard card) async {
    final url = await getSignedSaveUrl(card);
    if (url == null) {
      debugPrint(
          '[MAHALLI][wallet] No signed save URL for card ${card.id}: '
          'backend Wallet endpoint not configured. Reporting unavailable.');
      return false;
    }
    // Launching the URL requires a platform launcher. The repository does
    // not currently include url_launcher; adding it is a one-line pubspec
    // change once the backend endpoint exists. Until then we cannot verify
    // the launch actually succeeded, so we report failure rather than a
    // fake success.
    debugPrint('[MAHALLI][wallet] Would open signed save URL: $url');
    return false;
  }
}

/// Resolves a backend-generated signed Save URL for a card id.
abstract class WalletSaveUrlResolver {
  Future<String?> resolve(String cardId);
}

/// Default resolver while the MAHALLI backend Wallet endpoint is missing.
class NoopWalletSaveUrlResolver implements WalletSaveUrlResolver {
  const NoopWalletSaveUrlResolver();

  @override
  Future<String?> resolve(String cardId) async => null;
}
