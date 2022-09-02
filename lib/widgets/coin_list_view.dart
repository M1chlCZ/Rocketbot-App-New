import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/widgets/picture_cache.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'price_badge.dart';

class CoinListView extends StatefulWidget {
  final CoinBalance coin;
  final String? customLocale;
  final Function(CoinBalance h) coinSwitch;
  final Decimal? free;

  const CoinListView({Key? key, required this.coin, this.customLocale, this.free, required this.coinSwitch}) : super(key: key);

  @override
  State<CoinListView> createState() => _CoinListViewState();
}

class _CoinListViewState extends State<CoinListView> {
  Timer? _timer;
  bool _crossfade = true;

  @override
  void initState() {
    super.initState();
    if (widget.coin.posCoin != null) {
      startTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        setState(() {
          _crossfade ? _crossfade = false : _crossfade = true;
        });
      },
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Card(
              elevation: 0,
              color: Theme.of(context).canvasColor,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: InkWell(
                splashColor: Colors.black54,
                highlightColor: Colors.black54,
                onTap: () {
                  widget.coinSwitch(widget.coin);
                  // widget.activeCoin(widget.coin.coin!);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 70.0,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _getColor(widget.coin.posCoin),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(5, 8, 5, 5),
                                  child: Center(
                                      child: SizedBox(
                                    height: 30,
                                    width: 40.0,
                                    child: PictureCacheWidget(coin: widget.coin.coin!),
                                  )),
                                ),
                                PriceBadge(
                                  percentage: widget.coin.priceData?.priceChange24HPercent?.usd,
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.coin.coin!.ticker!,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.3),
                                  child: SizedBox(
                                    width: 70,
                                    child: AutoSizeText(
                                      widget.coin.coin!.name!,
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontStyle: FontStyle.normal, fontSize: 10.0),
                                      minFontSize: 8,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0.0, right: 4.0),
                                    child: widget.coin.posCoin != null
                                        ? AnimatedCrossFade(
                                            layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
                                              return Stack(
                                                alignment: AlignmentDirectional.centerEnd,
                                                clipBehavior: Clip.none,
                                                children: <Widget>[
                                                  Positioned(
                                                    key: bottomChildKey,
                                                    child: bottomChild,
                                                  ),
                                                  Positioned(
                                                    key: topChildKey,
                                                    child: topChild,
                                                  ),
                                                ],
                                              );
                                            },
                                            duration: const Duration(milliseconds: 1000),
                                            firstChild: AutoSizeText(
                                              _formatFree(widget.free!),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 16.0),
                                              minFontSize: 8,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                            ),
                                            crossFadeState: _crossfade ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                            secondChild: AutoSizeText(
                                              "${AppLocalizations.of(context)!.stake_label}: ${_formatFree(Decimal.parse(widget.coin.posCoin!.amount!.toStringAsFixed(4)))}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 16.0),
                                              minFontSize: 8,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                            ),
                                          )
                                        : AutoSizeText(
                                            _formatFree(widget.free!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 16.0),
                                            minFontSize: 8,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.end,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            widget.coin.priceData != null
                                ? widget.coin.posCoin != null && widget.coin.posCoin!.amount! != 0.0
                                    ? AnimatedCrossFade(
                                        layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
                                          return Stack(
                                            alignment: AlignmentDirectional.centerEnd,
                                            clipBehavior: Clip.none,
                                            children: <Widget>[
                                              Positioned(
                                                key: bottomChildKey,
                                                child: bottomChild,
                                              ),
                                              Positioned(
                                                key: topChildKey,
                                                child: topChild,
                                              ),
                                            ],
                                          );
                                        },
                                        duration: const Duration(milliseconds: 1000),
                                        firstChild: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, right: 4.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _formatValue(widget.coin.priceData!.prices!.usd!),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(fontStyle: FontStyle.normal, color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 16.0),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: AutoSizeText(
                                                  "\$${_formatPrice(widget.coin.free! * widget.coin.priceData!.prices!.usd!.toDouble())}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(fontStyle: FontStyle.normal, color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 16.0),
                                                  minFontSize: 8,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        crossFadeState: _crossfade ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                        secondChild: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, right: 4.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _formatValue(widget.coin.priceData!.prices!.usd!),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 16.0),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: AutoSizeText(
                                                  "\$${_formatPrice(widget.coin.posCoin!.amount! * widget.coin.priceData!.prices!.usd!.toDouble())}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(fontStyle: FontStyle.normal, color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 16.0),
                                                  minFontSize: 8,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 12.0, right: 4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                _formatValue(widget.coin.priceData!.prices!.usd!),
                                                style: Theme.of(context).textTheme.headline3,
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: AutoSizeText(
                                                "\$${_formatPrice(widget.coin.free! * widget.coin.priceData!.prices!.usd!.toDouble())}",
                                                style: Theme.of(context).textTheme.headline3,
                                                minFontSize: 8,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: SizedBox(
            height: 0.5,
            child: Container(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  String _formatPrice(double d) {
    var split = d.toString().split('.');
    var decimal = split[1];
    if (decimal.length >= 2) {
      var sub = decimal.substring(0, 2);
      return "${split[0]}.$sub";
    } else {
      return d.toString();
    }
  }

  String _formatValue(Decimal decimal) {
    if (decimal < Decimal.parse("0.01")) {
      return "Less than 1¢";
    } else {
      return "\$${decimal.toStringAsFixed(2)}";
    }
  }

  String _formatFree(Decimal decimal) {
    if (decimal == Decimal.zero) {
      return "0.0";
    } else {
      return _formatFreeValue(decimal.toDouble());
    }
  }

  List<Color> _getColor(dynamic pos) {
    if(pos != null) {
      return [
        const Color(0xFF9D9BFD),
        const Color(0x009D9BFD),
      ];
    }else{
      return [
        const Color(0xFF394359),
        const Color(0x00394359),
      ];
    }
  }

  String _formatFreeValue(double d) {
    var split = d.toString().split('.');
    var decimal = split[1];
    if (decimal.length >= 8) {
      var sub = decimal.substring(0, 8);
      return "${split[0]}.$sub";
    } else {
      return d.toString();
    }
  }
}
