import 'dart:convert';

import 'package:disk_cached_image/disk_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/coin.dart';

class CoinImage extends StatelessWidget {
  const CoinImage({super.key, required this.coin, this.size});

  final Coin coin;
  final double? size;

  static final DiskImageCache _cache = DiskImageCache();

  static const String _cacheKeyPrefix = 'coin_';
  static const String _unknownStem = 'unknown';
  static const int _maxCacheKeyLength = 128;

  static final RegExp _invalidKeyCharacters = RegExp('[^A-Za-z0-9._-]');
  static final RegExp _trailingDotsOrSpaces = RegExp(r'[. ]+$');

  /// Builds a deterministic, file-system-safe cache key for [cryptoId].
  ///
  /// Characters outside `[A-Za-z0-9._-]` become `_`, trailing dots are
  /// removed, and a short FNV-1a hash of the original id is appended. The key
  /// is prefixed and truncated so that it is never a Windows reserved device
  /// name and never exceeds 128 characters. Distinct ids that sanitize to the
  /// same text still get distinct keys because the hash covers the original
  /// id.
  ///
  /// Public for testability; callers should treat the exact sanitization
  /// scheme as an implementation detail.
  static String cacheKeyFor(String cryptoId) {
    final suffix = '_${_fnv1aHex(cryptoId)}';
    var sanitized = cryptoId.replaceAll(_invalidKeyCharacters, '_');
    sanitized = sanitized.replaceAll(_trailingDotsOrSpaces, '');
    if (sanitized.isEmpty) sanitized = _unknownStem;
    final maxStemLength =
        _maxCacheKeyLength - _cacheKeyPrefix.length - suffix.length;
    if (sanitized.length > maxStemLength) {
      sanitized = sanitized.substring(0, maxStemLength);
      sanitized = sanitized.replaceAll(_trailingDotsOrSpaces, '');
    }
    return '$_cacheKeyPrefix$sanitized$suffix';
  }

  /// Returns the FNV-1a 32-bit hash of [value] as eight lowercase hex digits.
  static String _fnv1aHex(String value) {
    var hash = 0x811c9dc5;
    for (final byte in utf8.encode(value)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
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
