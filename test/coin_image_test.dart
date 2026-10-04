import 'package:flutter_test/flutter_test.dart';
import 'package:rocketbot/widgets/coin_image.dart';

void main() {
  group('CoinImage.cacheKeyFor', () {
    test('replaces invalid characters with underscores and prefixes coin_', () {
      expect(CoinImage.cacheKeyFor('we!rd*id'), 'coin_we_rd_id');
      expect(CoinImage.cacheKeyFor('a b/c'), 'coin_a_b_c');
    });

    test('keeps reserved device names safe via the coin_ prefix', () {
      expect(CoinImage.cacheKeyFor('CON'), 'coin_CON');
      expect(CoinImage.cacheKeyFor('con'), 'coin_con');
      expect(CoinImage.cacheKeyFor('NUL'), 'coin_NUL');
      expect(CoinImage.cacheKeyFor('COM1'), 'coin_COM1');
    });

    test('strips trailing dots and never returns a key ending with "."', () {
      expect(CoinImage.cacheKeyFor('bitcoin.'), 'coin_bitcoin');
      expect(CoinImage.cacheKeyFor('bitcoin...'), 'coin_bitcoin');

      for (final id in ['bitcoin.', 'eth..', '.', '..', 'x. ']) {
        expect(CoinImage.cacheKeyFor(id).endsWith('.'), isFalse,
            reason: 'key for "$id" must not end with a dot');
      }
    });

    test('caps long ids at 128 characters', () {
      final key = CoinImage.cacheKeyFor('a' * 300);
      expect(key.length, 128);
      expect(key.startsWith('coin_'), isTrue);
    });

    test('is deterministic for the same input', () {
      const id = 'we!rd*id';
      expect(CoinImage.cacheKeyFor(id), CoinImage.cacheKeyFor(id));
    });

    test('falls back to a stable key when nothing survives sanitization', () {
      expect(CoinImage.cacheKeyFor(''), 'coin_unknown');
      expect(CoinImage.cacheKeyFor('...'), 'coin_unknown');
    });
  });
}
