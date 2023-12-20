import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/screenpages/masternode_page.dart';
import 'package:rocketbot/screenpages/staking_page.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/staking_masternode_switch.dart';

class FarmMainScreen extends StatefulWidget {
  final Coin activeCoin;
  final CoinBalance coinBalance;
  final String depositAddress;
  final String? depositPosAddress;
  final Function(double free) changeFree;
  final Function(bool touch) blockTouch;
  final double free;
  final bool masternode;

  const FarmMainScreen(
      {super.key,
      required this.activeCoin,
      required this.coinBalance,
      required this.depositAddress,
      this.depositPosAddress,
      required this.changeFree,
      required this.blockTouch,
      required this.free,
      required this.masternode});

  @override
  State<FarmMainScreen> createState() => _FarmMainScreenState();
}

class _FarmMainScreenState extends State<FarmMainScreen> {
  final _pageController = PageController(initialPage: 0);
  final _switchKey = GlobalKey<StakingMasternodeSwitcherState>();
  String? posDeposit;
  int page = 0;

  @override
  void initState() {
    super.initState();
    posDeposit = widget.depositPosAddress;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Theme.of(context).canvasColor,
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              AppLocalizations.of(context)!.stake_label,
                              style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: StakingMasternodeSwitcher(
                              key: _switchKey,
                              masternode: widget.masternode,
                              changeType: (int a) {
                                _pageController.jumpToPage(a);
                              }),
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1.45,
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      page = index;
                      _switchKey.currentState?.currentPage(index);
                    });
                  },
                  controller: _pageController,
                  children: [
                    StakingPage(
                      activeCoin: widget.activeCoin,
                      depositPosAddress: widget.depositPosAddress,
                      depositAddress: widget.depositAddress,
                      coinBalance: widget.coinBalance,
                      changeFree: widget.changeFree,
                      free: widget.free,
                      blockTouch: widget.blockTouch,
                    ),
                    MasternodePage(
                        activeCoin: widget.activeCoin,
                        coinBalance: widget.coinBalance,
                        depositAddress: widget.depositAddress,
                        changeFree: widget.changeFree,
                        free: widget.free,
                        blockTouch: widget.blockTouch,
                        masternode: widget.masternode)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
