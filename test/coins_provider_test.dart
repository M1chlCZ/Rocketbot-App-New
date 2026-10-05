import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/providers/balance_provider.dart';
import 'package:rocketbot/providers/coins_provider.dart';
import 'package:rocketbot/providers/network_provider.dart';

class _FakeRocketbotClient extends RocketbotClient {
  _FakeRocketbotClient(this.response);

  final dynamic response;

  @override
  Future<dynamic> get(String url,
      {String? request,
      bool pos = false,
      bool web = false,
      bool launchpad = false,
      bool auth = true,
      bool debug = false}) async {
    return response;
  }
}

void main() {
  test('coinsProvider emits price data for a valid response', () async {
    final container = ProviderContainer.test(
      overrides: [
        networkProvider.overrideWithValue(
          _FakeRocketbotClient({
            'hasError': false,
            'data': {
              '1': {
                'updatedAt': 42,
                'prices': {'usd': '12.5', 'btc': '0.0001'},
              },
            },
          }),
        ),
      ],
    );

    expect(container.read(coinsProvider), isA<AsyncLoading<PriceData>>());

    await container.read(coinsProvider.notifier).getData(1);

    final state = container.read(coinsProvider);
    expect(state, isA<AsyncData<PriceData>>());
    expect(state.value?.updatedAt, 42);
    expect(state.value?.prices?.usd.toString(), '12.5');
  });

  test('coinsProvider emits an error when the response has no data', () async {
    final container = ProviderContainer.test(
      overrides: [
        networkProvider.overrideWithValue(
          _FakeRocketbotClient({'hasError': true, 'error': 'boom'}),
        ),
      ],
    );

    await container.read(coinsProvider.notifier).getData(1);

    expect(container.read(coinsProvider), isA<AsyncError<PriceData>>());
  });

  test('dropdownProvider notifies when the same list is wrapped again', () {
    final container = ProviderContainer.test();
    final notifier = container.read(dropdownProvider.notifier);
    final list = <CoinBalance>[];

    expect(
      notifier.updateShouldNotify(
        AsyncValue.data(list),
        AsyncValue.data(list),
      ),
      isTrue,
    );
    final state = AsyncValue.data(list);
    expect(notifier.updateShouldNotify(state, state), isFalse);
  });
}
