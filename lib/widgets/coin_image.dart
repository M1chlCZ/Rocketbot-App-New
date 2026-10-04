import 'package:disk_cached_image/disk_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/coin.dart';

class CoinImage extends StatelessWidget {
  const CoinImage({super.key, required this.coin, this.size});

  final Coin coin;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return DiskCachedImage(
      url: 'https://app.rocketbot.pro/Image?imageId=${coin.imageSmallid!}',
      cacheKey: coin.cryptoId!,
      width: size,
      height: size,
    );
  }
}
