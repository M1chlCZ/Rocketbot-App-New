import 'package:flutter_test/flutter_test.dart';
import 'package:rocketbot/widgets/coin_image.dart';

final RegExp _keyPattern = RegExp(r'^[A-Za-z0-9][A-Za-z0-9._-]*$');

void main() {
  group('CoinImage.cacheKeyFor', () {
    test('replaces invalid characters with underscores and appends a hash', () {
      expect(CoinImage.cacheKeyFor('we!rd*id'), 'coin_we_rd_id_686e00e1');
      expect(CoinImage.cacheKeyFor('a b/c'), 'coin_a_b_c_570e31cc');
    });

    test('keeps reserved device names safe via the coin_ prefix', () {
      expect(CoinImage.cacheKeyFor('CON'), 'coin_CON_3367e86b');
      expect(CoinImage.cacheKeyFor('con'), 'coin_con_f08dd14b');
      expect(CoinImage.cacheKeyFor('NUL'), 'coin_NUL_4fad0f80');
      expect(CoinImage.cacheKeyFor('COM1'), 'coin_COM1_4e9510dd');
    });

    test('strips trailing dots and never returns a key ending with "."', () {
      expect(CoinImage.cacheKeyFor('bitcoin.'), 'coin_bitcoin_a73d68a9');
      expect(CoinImage.cacheKeyFor('bitcoin...'), 'coin_bitcoin_dd0e7131');

      for (final id in ['bitcoin.', 'eth..', '.', '..', 'x. ']) {
        expect(CoinImage.cacheKeyFor(id).endsWith('.'), isFalse,
            reason: 'key for "$id" must not end with a dot');
      }
    });

    test('caps long ids at 128 characters', () {
      final key = CoinImage.cacheKeyFor('a' * 300);
      expect(key.length, 128);
      expect(key.startsWith('coin_'), isTrue);
      expect(key, 'coin_${'a' * 114}_279e8f01');
    });

    test('is deterministic for the same input', () {
      const id = 'we!rd*id';
      expect(CoinImage.cacheKeyFor(id), CoinImage.cacheKeyFor(id));
      expect(CoinImage.cacheKeyFor(''), CoinImage.cacheKeyFor(''));
    });

    test('falls back to a stable key when nothing survives sanitization', () {
      expect(CoinImage.cacheKeyFor(''), 'coin_unknown_811c9dc5');
      expect(CoinImage.cacheKeyFor('...'), 'coin_unknown_0ac31c19');
      expect(CoinImage.cacheKeyFor('.'), 'coin_unknown_2b0c98f1');
    });

    test('distinguishes ids that sanitize to the same text', () {
      expect(
        CoinImage.cacheKeyFor('a!b'),
        isNot(CoinImage.cacheKeyFor('a_b')),
      );
      expect(CoinImage.cacheKeyFor('a!b'), 'coin_a_b_32a66e0f');
      expect(CoinImage.cacheKeyFor('a_b'), 'coin_a_b_1ba46871');

      expect(
        CoinImage.cacheKeyFor('bitcoin.'),
        isNot(CoinImage.cacheKeyFor('bitcoin')),
      );
      expect(CoinImage.cacheKeyFor('bitcoin'), 'coin_bitcoin_55f7427d');
    });

    test('always produces a valid cache key for hostile inputs', () {
      final ids = <String>[
        '',
        '...',
        'CON',
        'é',
        '🚀',
        'a/b',
        'a' * 300,
      ];
      for (final id in ids) {
        final key = CoinImage.cacheKeyFor(id);
        expect(_keyPattern.hasMatch(key), isTrue,
            reason: 'key for "$id" must match the cache key pattern: $key');
        expect(key.length, lessThanOrEqualTo(128),
            reason: 'key for "$id" must be at most 128 characters');
        expect(key.endsWith('.'), isFalse,
            reason: 'key for "$id" must not end with a dot');
      }
    });
  });
}
