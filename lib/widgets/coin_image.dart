import 'package:disk_cached_image/disk_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/coin.dart';

class CoinImage extends StatelessWidget {
  const CoinImage({super.key, required this.coin, this.size});

  final Coin coin;
  final double? size;

  static final DiskImageCache _cache = DiskImageCache();

  static const String _cacheKeyPrefix = 'coin_';
  static const String _fallbackCacheKey = 'coin_unknown';
  static const int _maxCacheKeyLength = 128;

  static final RegExp _invalidKeyCharacters = RegExp('[^A-Za-z0-9._-]');
  static final RegExp _trailingDotsOrSpaces = RegExp(r'[. ]+$');

  /// Builds a deterministic, file-system-safe cache key for [cryptoId].
  ///
  /// Characters outside `[A-Za-z0-9._-]` become `_`, trailing dots are
  /// removed, and the key is prefixed and truncated so that it is never a
  /// Windows reserved device name and never exceeds 128 characters.
  ///
  /// Public for testability; callers should treat the exact sanitization
  /// scheme as an implementation detail.
  static String cacheKeyFor(String cryptoId) {
    var sanitized = cryptoId.replaceAll(_invalidKeyCharacters, '_');
    sanitized = sanitized.replaceAll(_trailingDotsOrSpaces, '');
    if (sanitized.isEmpty) return _fallbackCacheKey;
    var key = '$_cacheKeyPrefix$sanitized';
    if (key.length > _maxCacheKeyLength) {
      key = key.substring(0, _maxCacheKeyLength);
      key = key.replaceAll(_trailingDotsOrSpaces, '');
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    final smallImageId = coin.imageSmallid;
    final cryptoId = coin.cryptoId;
    if (smallImageId == null || cryptoId == null) {
      return SizedBox(width: size, height: size);
    }
    return DiskCachedImage(
      url: 'https://app.rocketbot.pro/Image?imageId=$smallImageId',
      cacheKey: cacheKeyFor(cryptoId),
      cache: _cache,
      width: size,
      height: size,
      fit: BoxFit.scaleDown,
    );
  }
}
