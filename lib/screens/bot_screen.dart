import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/providers/balance_provider.dart';
import 'package:rocketbot/screens/socials_screen.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/dropdown_menu_icon.dart';
import 'package:rocketbot/widgets/percent_switch_widget.dart';
import 'package:rocketbot/widgets/picture_cache.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_number/sliding_number.dart';

class BotScreen extends ConsumerStatefulWidget {
  final String type;

  const BotScreen(this.type, {Key? key}) : super(key: key);

  @override
  ConsumerState<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends ConsumerState<BotScreen> {
  final TextEditingController _amountController = TextEditingController();
  final key = GlobalKey<PercentSwitchWidgetState>();
  CoinBalance? selectedCoin;
  int indexCoin = 0;

  List<String> socials = ["Twitter", "Telegram", "Discord"];
  String currentSocial = "Twitter";

  int indexSocial = 0;

  String switchValue = "hours";
  String switchNums = "0-100";
  double _value = 5;
  double _valueUsers = 100;
  String dateShort = "m";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final p = ref.read(dropdownProvider.notifier);
      p.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.watch(dropdownProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 25,
                      child: FlatCustomButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 24.0,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        "Tip Bot",
                        style: TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
              ctrl.when(data: (data) {
                if (data.isNotEmpty) {
                  selectedCoin ??= data.firstWhere((element) => element.free! > 0.0);
                  return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CoinBalance>(
                                value: selectedCoin,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.white70,
                                ),
                                iconSize: 20,
                                iconEnabledColor: Colors.white70,
                                elevation: 16,
                                style: const TextStyle(color: Colors.white70),
                                onChanged: (CoinBalance? newValue) {
                                  if (newValue == null) return;
                                  if (newValue.free! <= 0.0) {
                                    Dialogs.openAlertBox(context, "Insufficient funds", "You don't have enough ${newValue.coin?.ticker} to send a tip");
                                    return;
                                  }
                                  setState(() {
                                    key.currentState?.deActivate();
                                    _amountController.clear();
                                    selectedCoin = newValue;
                                  });
                                },
                                items: data
                                    .map((coin) => DropdownMenuItem<CoinBalance>(
                                          value: coin,
                                          child: Row(
                                            children: [
                                              Opacity(
                                                opacity: coin.free! > 0.0 ? 1.0 : 0.3,
                                                child: SizedBox(width: 25.0, height: 25.0, child: PictureCacheWidget(coin: coin.coin!)),
                                              ),
                                              const SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(coin.coin?.ticker ?? "Coin",
                                                  style: TextStyle(color: coin.free! > 0.0 ? Colors.white70 : Colors.white30, fontSize: 16.0, fontWeight: FontWeight.w600)),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList()),
                          ),
                        )),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: 110.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: const Center(child: Text("Balance", style: TextStyle(color: Colors.white70, fontSize: 16.0, fontWeight: FontWeight.w400)))),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: AutoSizeText("${selectedCoin?.free ?? 0.0} ${selectedCoin?.coin?.ticker ?? "Coin"}",
                                      maxLines: 1, minFontSize: 8.0, textAlign: TextAlign.end, style: const TextStyle(color: Colors.white70)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text("Duration", style: TextStyle(color: Colors.white70, fontSize: 16.0, fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 100.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SlidingNumber(
                                          number: _value.toInt(),
                                          style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w800),
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOutCubicEmphasized,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(_value == 1 ? switchValue.replaceAll("s", "").capitalize() : switchValue.capitalize(),
                                            style: const TextStyle(color: Colors.white70, fontSize: 16.0, fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                ],
                              ))),
                          const SizedBox(
                            height: 10.0,
                          ),
                          AnimatedToggleSwitch<String>.custom(
                            current: switchValue,
                            iconOpacity: 0.2,
                            indicatorSize: const Size.fromWidth(120),
                            animatedIconBuilder: (i, a, c) => Center(child: Text(a.value, style: const TextStyle(color: Colors.white))),
                            foregroundIndicatorIconBuilder: (i, a) => Center(child: Text(a.current, style: const TextStyle(color: Colors.black87))),
                            borderRadius: BorderRadius.circular(8.0),
                            borderWidth: 0,
                            height: 40.0,
                            colorBuilder: (i) {
                              switch (i) {
                                case "minutes":
                                  return Colors.lightBlue;
                                case "hours":
                                  return Colors.lightGreen;
                                case "days":
                                  return Colors.amberAccent;
                                default:
                                  return Colors.white;
                              }
                            },
                            onChanged: (i) {
                              setState(() {
                                switchValue = i;
                                _value = 1;
                              });
                            },
                            values: const ["minutes", "hours", "days"],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF252F45),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: const Color(0xFF37394F), width: 1.0),
                            ),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10.0,
                                trackShape: const RoundedRectSliderTrackShape(),
                                activeTrackColor: thumbColor(switchValue).withOpacity(0.8),
                                inactiveTrackColor: Colors.black38,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 14.0,
                                  pressedElevation: 20.0,
                                  elevation: 5.0,
                                ),
                                thumbColor: thumbColor(switchValue),
                                overlayColor: thumbColor(switchValue).withOpacity(0.2),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
                                tickMarkShape: const RoundSliderTickMarkShape(),
                                activeTickMarkColor: thumbColor(switchValue).withOpacity(0.5),
                                inactiveTickMarkColor: Colors.white30,
                                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.black,
                                valueIndicatorTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              child: Slider(
                                min: getSliderValues(switchValue)['min'] ?? 0.0,
                                max: getSliderValues(switchValue)['max'] ?? 0.0,
                                value: _value,
                                divisions: getSliderValues(switchValue)['divisions']!.toInt(),
                                label: '${_value.round()}',
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF252F45),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: const Color(0xFF37394F), width: 1.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                    controller: _amountController,
                                    textAlign: TextAlign.center,
                                    cursorColor: Colors.white,
                                    keyboardType: Platform.isIOS ? const TextInputType.numberWithOptions(signed: true) : TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')),
                                    ],
                                    style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w800),
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.black38,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      ),
                                      hintText: "Enter Amount",
                                      hintStyle: TextStyle(color: Colors.white30, fontSize: 16.0, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  PercentSwitchWidget(
                                    key: key,
                                    width: 75,
                                    changePercent: (double percent) {
                                      setState(() {
                                        _amountController.text = NumberFormat("###.######").format(double.parse(selectedCoin!.free!.toString()) * percent);
                                      });
                                      // setState(() { _percent = percent; });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text("Number of winners", style: TextStyle(color: Colors.white70, fontSize: 16.0, fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 100.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SlidingNumber(
                                          number: _valueUsers.toInt(),
                                          style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w800),
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOutCubicEmphasized,
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        const Icon(Icons.person_2, color: Colors.white70),
                                      ],
                                    ),
                                  ),
                                ],
                              ))),
                          const SizedBox(
                            height: 10.0,
                          ),
                          AnimatedToggleSwitch<String>.custom(
                            current: switchNums,
                            iconOpacity: 0.2,
                            indicatorSize: const Size.fromWidth(80),
                            animatedIconBuilder: (i, a, c) => Center(child: Text(a.value, style: const TextStyle(color: Colors.white))),
                            foregroundIndicatorIconBuilder: (i, a) => Center(child: Text(a.current, style: const TextStyle(color: Colors.black87))),
                            borderRadius: BorderRadius.circular(8.0),
                            borderWidth: 0,
                            height: 30.0,
                            colorBuilder: (i) {
                              switch (i) {
                                case "0-100":
                                  return Colors.redAccent;
                                case "100+":
                                  return Colors.lightGreen;
                                case "days":
                                  return Colors.amberAccent;
                                default:
                                  return Colors.white;
                              }
                            },
                            onChanged: (i) {
                              setState(() {
                                switchNums = i;
                                _valueUsers = getUserValues("${widget.type}$switchNums")['default'] as double;
                              });
                            },
                            values: const ["0-100", "100+"],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF252F45),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: const Color(0xFF37394F), width: 1.0),
                            ),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10.0,
                                trackShape: const RoundedRectSliderTrackShape(),
                                activeTrackColor: thumbColor(switchValue).withOpacity(0.8),
                                inactiveTrackColor: Colors.black38,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 14.0,
                                  pressedElevation: 20.0,
                                  elevation: 5.0,
                                ),
                                thumbColor: thumbColor(switchValue),
                                overlayColor: thumbColor(switchValue).withOpacity(0.2),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
                                tickMarkShape: const RoundSliderTickMarkShape(),
                                activeTickMarkColor: thumbColor(switchValue).withOpacity(0.5),
                                inactiveTickMarkColor: Colors.white30,
                                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.black,
                                valueIndicatorTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              child: Slider(
                                min: getUserValues("${widget.type}$switchNums")['min'] ?? 0.0,
                                max: getUserValues("${widget.type}$switchNums")['max'] ?? 0.0,
                                value: _valueUsers,
                                divisions: getUserValues("${widget.type}$switchNums")['divisions']!.toInt(),
                                label: '${_valueUsers.round()}',
                                onChanged: (value) {
                                  setState(() {
                                    _valueUsers = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Container(
                                      height: 48.0,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: getColor(currentSocial),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: DropDownIcon<String>(
                                          onChange: (String value, int index) {
                                            setState(() {
                                              currentSocial = value;
                                            });
                                          },
                                          dropdownButtonStyle: DropdownButtonStyle(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            height: 50,
                                            width: 180,
                                            elevation: 5,
                                            backgroundColor: getColor(currentSocial),
                                            primaryColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                            ),
                                          ),
                                          dropdownStyle: DropdownStyle(
                                            borderRadius: BorderRadius.circular(5),
                                            elevation: 5,
                                            color: const Color(0xFF579B61),
                                            offset: const Offset(0, 50),
                                          ),
                                          items: socials
                                              .map(
                                                (item) => DropdownItem<String>(
                                                  value: item,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: getColor(item),
                                                      borderRadius: getBorderRadius(socials.indexOf(item)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Text(
                                                            item,
                                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.0, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w400),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                                                          child: Image.asset(
                                                            "images/${item.toLowerCase()}.png",
                                                            width: 20.0,
                                                            height: 20.0,
                                                            color: Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          currentIndex: indexSocial,
                                          child: const SizedBox.shrink()),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF252F45),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: const Color(0xFF37394F), width: 1.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_amountController.text.isNotEmpty)
                                  Text("${_valueUsers.toInt()} winners rewarded ${getAmountWinner(_amountController.text, _valueUsers, selectedCoin!.coin!.name!)}"),
                                if (_amountController.text.isEmpty)
                                  const Text("Please enter an amount", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w200),),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Opacity(
                            opacity: _amountController.text.isNotEmpty ? 1.0 : 0.5,
                            child: FlatCustomButton(
                              radius: 8.0,
                              width: double.infinity,
                              height: 50.0,
                              color: getColor(currentSocial),
                              onTap: () {
                                if (_amountController.text.isNotEmpty) {
                                  switch (currentSocial) {
                                    case "Twitter":
                                      {
                                        String s = "@rocketbotpro ${widget.type} ${_amountController.text} ${selectedCoin!.coin!.ticker} ${_valueUsers.toInt()} ${_value.toInt()}$dateShort";
                                        Share.share(
                                            s);
                                      }
                                      break;
                                    case "Telegram":
                                      {
                                        String s = "!${widget.type} ${_amountController.text} ${selectedCoin!.coin!.ticker} ${_valueUsers.toInt()} ${_value.toInt()}$dateShort";
                                        Share.share(
                                            s);
                                      }
                                      break;
                                    case "Discord":
                                      {
                                        String s = "/${widget.type} ${_amountController.text} ${selectedCoin!.coin!.ticker} ${_valueUsers.toInt()} ${_value.toInt()}$dateShort";
                                        Share.share(
                                            s);
                                      }
                                      break;
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Amount must be greater than 0")));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Share", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w400)),
                                  Icon(Icons.share, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ]))
                  ]);
                } else {
                  return const Text("No coins");
                }
              }, loading: () {
                return const CircularProgressIndicator();
              }, error: (error, stack) {
                return Text(error.toString());
              }),
            ]))
          ]),
        ),
      ),
    );
  }

  Color getColor(String index) {
    var value = index.toLowerCase();
    switch (value) {
      case "twitter":
        return const Color(0xFF1DA1F2);
      case "telegram":
        return const Color(0xFF229ED9);
      case "discord":
        return const Color(0xFF7289DA);
      default:
        return Colors.blue;
    }
  }

  Color thumbColor(String index) {
    switch (index) {
      case "minutes":
        dateShort = "m";
        return Colors.lightBlue;
      case "hours":
        dateShort = "h";
        return Colors.lightGreen;
      case "days":
        dateShort = "d";
        return Colors.amberAccent;
      default:
        return Colors.white;
    }
  }

  String getAmountWinner(String amnt,  double valueUser, String coinID) {
    var amount = double.parse(amnt);
    var amountWinner = amount / valueUser;
    return NumberFormat("###.######").format(amountWinner);
  }

  Map<String, double> getSliderValues(String index) {
    switch (index) {
      case "minutes":
        return const {"min": 1.0, "max": 59.0, "divisions": 59.0};
      case "hours":
        return const {"min": 1.0, "max": 23.0, "divisions": 23.0};
      case "days":
        return const {"min": 1.0, "max": 30.0, "divisions": 30.0};
      default:
        return const {"min": 1, "max": 30};
    }
  }

  Map<String, double> getUserValues(String typeDrop) {
    switch (typeDrop) {
      case "gw0-100":
        return const {"min": 0.0, "max": 100.0, "divisions": 100.0, "default": 10.0};
      case "gw100+":
        return const {"min": 100.0, "max": 1000.0, "divisions": 100.0, "default": 200.0};
      case "airdrop0-100":
        return const {"min": 0.0, "max": 100.0, "divisions": 10.0};
      case "airdrop100+":
        return const {"min": 100.0, "max": 500.0, "divisions": 100.0, "default": 200.0};
      case "spin":
        return const {"min": 0.0, "max": 30.0, "divisions": 30.0};
      default:
        return const {"min": 1, "max": 30};
    }
  }

  // Map<String, double> getCommandValues(String index) {
  //   switch (index) {
  //     case "minutes":
  //       return const {"min": 1.0, "max": 59.0, "divisions": 59.0};
  //     case "hours":
  //       return const {"min": 1.0, "max": 23.0, "divisions": 23.0};
  //     case "days":
  //       return const {"min": 1.0, "max": 30.0, "divisions": 30.0};
  //     default:
  //       return const {"min": 1, "max": 30};
  //   }
  // }

  BorderRadius getBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5));
    } else if (index == socials.length - 1) {
      return const BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5));
    } else {
      return const BorderRadius.all(Radius.circular(0));
    }
  }
}
