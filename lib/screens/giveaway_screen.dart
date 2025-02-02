import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/get_airdrops_bloc.dart';
import 'package:rocketbot/bloc/get_giveaways_bloc.dart';
import 'package:rocketbot/bloc/get_lotteries_bloc.dart';
import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/models/loterries.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rocketbot/screens/airdrop_detail_screen.dart';
import 'package:rocketbot/screens/bot_screen.dart';
import 'package:rocketbot/screens/games_switch.dart';
import 'package:rocketbot/screens/giveaway_detail_screen.dart';
import 'package:rocketbot/screens/lottery_detail_screen.dart';
import 'package:rocketbot/screens/twitter_giveaway_detail_screen.dart';
import 'package:rocketbot/support/route.dart';
import 'package:rocketbot/widgets/airdrop_tile.dart';
import 'package:rocketbot/widgets/giveaway_tile.dart';
import 'package:rocketbot/widgets/lottery_tile.dart';

import '../netinterface/interface.dart';
import '../widgets/animted_list_item_wrapper.dart';

class GiveAwayScreen extends StatefulWidget {
  final VoidCallback prevScreen;
  final VoidCallback nextScreen;

  const GiveAwayScreen({
    super.key,
    required this.prevScreen,
    required this.nextScreen,
  });

  @override
  State<GiveAwayScreen> createState() => _GiveAwayScreenState();
}

class _GiveAwayScreenState extends State<GiveAwayScreen> with AutomaticKeepAliveClientMixin<GiveAwayScreen> {
  final _pageController = PageController(initialPage: 0);
  final ValueNotifier<ScrollDirection> scrollDirectionNotifier = ValueNotifier<ScrollDirection>(ScrollDirection.forward);
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final _switchKey = GlobalKey<GameSwitcherState>();
  final NetInterface interface = NetInterface();
  ScrollController gwScroll = ScrollController();
  ScrollController adScroll = ScrollController();
  ScrollController ltScroll = ScrollController();
  int activeSection = 0;
  GiveawaysBloc? gwBlock;
  AirdropsBloc? adBlock;
  LotteriesBloc? ltBlock;

  int giveawayPage = 1;
  int airdropPage = 1;
  int lotteryPage = 1;

  double widthScreen = 0.0;

  @override
  void initState() {
    super.initState();
    gwBlock = GiveawaysBloc();
    adBlock = AirdropsBloc();
    ltBlock = LotteriesBloc();

    _scrollListener(gwScroll, 1);
    _scrollListener(adScroll, 2);
    _scrollListener(ltScroll, 3);

    _pageController.addListener(() {
      if (_pageController.page == 0) {
        if (_pageController.offset < -widthScreen * 0.2) {
          widget.prevScreen();
          _pageController.jumpToPage(0);
        }
      } else if (_pageController.page == 2) {
        if (_pageController.offset > (widthScreen * 2) + (widthScreen * 0.2)) {
          widget.nextScreen();
          _pageController.jumpToPage(0);
        }
      }
    });
  }

  @override
  void dispose() {
    gwBlock?.dispose();
    adBlock?.dispose();
    ltBlock?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollListener(ScrollController sc, int type) {
    sc.addListener(() {
      if (sc.position.pixels >= (sc.position.maxScrollExtent - 50)) {
        if (type == 1) {
          giveawayPage++;
          gwBlock!.fetchGiveaways(page: giveawayPage);
        }
        if (type == 2) {
          airdropPage++;
          adBlock!.fetchGiveaways(page: airdropPage);
        }
        if (type == 3) {
          lotteryPage++;
          ltBlock!.fetchGiveaways(page: airdropPage);
        }
        // _suggestionBloc.fetchSuggestions();
      }
    });
  }

  void aidropCallBack(Airdrop a) {
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return AirdropDetailScreen(
            airdrop: a,
          );
        }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => adBlock!.fetchGiveaways(page: airdropPage));
  }

  void giveawayCallback(Giveaway g) async {
    if (g.socialMedia == 3) {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return TwitterGiveawayDetailScreen(
              giveaway: g,
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }))
          .then((value) => gwBlock!.fetchGiveaways(page: giveawayPage));
    } else {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return GiveawayDetailScreen(
              giveaway: g,
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }))
          .then((value) => gwBlock!.fetchGiveaways(page: giveawayPage));
    }
  }

  void lotteryCallback(Lottery l) {
    if (l.id != 0) {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return LotteryDetailScreen(
              lottery: l,
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }))
          .then((value) => ltBlock!.fetchGiveaways(page: airdropPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: PageView(
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          switch (index) {
                            case 0:
                              gwBlock!.fetchGiveaways(page: giveawayPage);
                              break;
                            case 1:
                              adBlock!.fetchGiveaways(page: airdropPage);
                              break;
                            case 2:
                              ltBlock!.fetchGiveaways(page: airdropPage);
                              break;
                          }
                          activeSection = index;
                          _switchKey.currentState?.currentPage(index);
                        });
                      },
                      controller: _pageController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0, top: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: StreamBuilder<ApiResponse<List<Giveaway>>>(
                              stream: gwBlock!.coinsListStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.loading:
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 0.0),
                                          child: HeartbeatProgressIndicator(
                                            startScale: 0.01,
                                            endScale: 0.2,
                                            child: const Image(
                                              image: AssetImage('images/rocketbot_logo.png'),
                                              color: Colors.white30,
                                            ),
                                          ),
                                        ),
                                      );
                                    case Status.completed:
                                      if (snapshot.data!.data!.isNotEmpty) {
                                        return NotificationListener<UserScrollNotification>(
                                          onNotification: (UserScrollNotification notification) {
                                            if (notification.direction == ScrollDirection.forward ||
                                                notification.direction == ScrollDirection.reverse) {
                                              scrollDirectionNotifier.value = notification.direction;
                                            }
                                            return true;
                                          },
                                          child: ListView.builder(
                                              key: const PageStorageKey(0),
                                              controller: gwScroll,
                                              shrinkWrap: false,
                                              itemCount: snapshot.data!.data!.length,
                                              itemBuilder: (ctx, index) {
                                                return ValueListenableBuilder(
                                                    valueListenable: scrollDirectionNotifier,
                                                    child: GiveawayTile(
                                                        key: ValueKey<int>(snapshot.data!.data![index].id!),
                                                        giveaway: snapshot.data!.data![index],
                                                        callBack: giveawayCallback),
                                                    builder: (BuildContext context, scrollDirection, Widget? child) {
                                                      return AnimatedListItemWrapper(
                                                        scrollDirection: scrollDirection,
                                                        child: child!,
                                                      );
                                                    });
                                              }),
                                        );
                                      } else {
                                        return Container(
                                          width: double.infinity,
                                          height: 60.0,
                                          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "No giveaway available at this moment",
                                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.amber),
                                          )),
                                        );
                                      }
                                    case Status.error:
                                      debugPrint("error");
                                      break;
                                  }
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0, top: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: StreamBuilder<ApiResponse<List<Airdrop>>>(
                              stream: adBlock!.coinsListStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.loading:
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 0.0),
                                          child: HeartbeatProgressIndicator(
                                            startScale: 0.01,
                                            endScale: 0.2,
                                            child: const Image(
                                              image: AssetImage('images/rocketbot_logo.png'),
                                              color: Colors.white30,
                                            ),
                                          ),
                                        ),
                                      );
                                    case Status.completed:
                                      if (snapshot.data!.data!.isNotEmpty) {
                                        return NotificationListener<UserScrollNotification>(
                                          onNotification: (UserScrollNotification notification) {
                                            if (notification.direction == ScrollDirection.forward ||
                                                notification.direction == ScrollDirection.reverse) {
                                              scrollDirectionNotifier.value = notification.direction;
                                            }
                                            return true;
                                          },
                                          child: ListView.builder(
                                              key: const PageStorageKey(1),
                                              controller: adScroll,
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.data!.length,
                                              itemBuilder: (ctx, index) {
                                                return ValueListenableBuilder(
                                                    valueListenable: scrollDirectionNotifier,
                                                    child: AirdropTile(
                                                      key: ValueKey<int>(snapshot.data!.data![index].id!),
                                                      airdrop: snapshot.data!.data![index],
                                                      callBack: aidropCallBack,
                                                    ),
                                                    builder: (BuildContext context, scrollDirection, Widget? child) {
                                                      return AnimatedListItemWrapper(
                                                        scrollDirection: scrollDirection,
                                                        child: child!,
                                                      );
                                                    });
                                              }),
                                        );
                                      } else {
                                        return Container(
                                          width: double.infinity,
                                          height: 60.0,
                                          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "No airdrop available at this moment",
                                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.amber),
                                          )),
                                        );
                                      }
                                    case Status.error:
                                      debugPrint("error");
                                      break;
                                  }
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0, top: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: StreamBuilder<ApiResponse<List<Lottery>>>(
                              stream: ltBlock!.coinsListStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.loading:
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 0.0),
                                          child: HeartbeatProgressIndicator(
                                            startScale: 0.01,
                                            endScale: 0.2,
                                            child: const Image(
                                              image: AssetImage('images/rocketbot_logo.png'),
                                              color: Colors.white30,
                                            ),
                                          ),
                                        ),
                                      );
                                    case Status.completed:
                                      if (snapshot.data!.data!.isNotEmpty) {
                                        return NotificationListener<UserScrollNotification>(
                                          onNotification: (UserScrollNotification notification) {
                                            if (notification.direction == ScrollDirection.forward ||
                                                notification.direction == ScrollDirection.reverse) {
                                              scrollDirectionNotifier.value = notification.direction;
                                            }

                                            return true;
                                          },
                                          child: ListView.builder(
                                              key: const PageStorageKey(2),
                                              controller: ltScroll,
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.data!.length,
                                              itemBuilder: (ctx, index) {
                                                return ValueListenableBuilder(
                                                    valueListenable: scrollDirectionNotifier,
                                                    child: LotteryTile(
                                                      key: ValueKey<int>(snapshot.data!.data![index].id!),
                                                      lottery: snapshot.data!.data![index],
                                                      callBack: lotteryCallback,
                                                    ),
                                                    builder: (BuildContext context, scrollDirection, Widget? child) {
                                                      return AnimatedListItemWrapper(
                                                        scrollDirection: scrollDirection,
                                                        child: child!,
                                                      );
                                                    });
                                              }),
                                        );
                                      } else {
                                        return Container(
                                          width: double.infinity,
                                          height: 60.0,
                                          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                          child: Center(
                                              child: AutoSizeText(
                                            "No Spin Lotteries available at this moment",
                                            maxLines: 1,
                                            minFontSize: 8.0,
                                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.amber),
                                          )),
                                        );
                                      }
                                    case Status.error:
                                      debugPrint("error");
                                      break;
                                  }
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GameSwitcher(
                        key: _switchKey,
                        changeType: (page) {
                          setState(() {
                            activeSection = page;
                          });
                          _pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
                        }),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 50.0,
                right: 20.0,
                child: PhysicalModel(
                  shape: BoxShape.circle,
                  elevation: 10.0,
                  color: Colors.black12,
                  child: ClipOval(
                    child: SpeedDial(
                      overlayOpacity: 0.8,
                      overlayColor: Colors.black,
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      openCloseDial: isDialOpen,
                      icon: Icons.add,
                      activeIcon: Icons.close,
                      iconTheme: const IconThemeData(color: Colors.white, size: 30),
                      childPadding: const EdgeInsets.all(5),
                      spaceBetweenChildren: 4,
                      dialRoot: null,
                      children: [
                        SpeedDialChild(
                          child: Container(
                              margin: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                "images/spin_but.png",
                                scale: 0.8,
                              )),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          visible: true,
                          onTap: () => Navigator.push(context, pushRoute(const BotScreen("spin"))),
                          labelWidget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            margin: const EdgeInsets.only(right: 10.0),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Spin'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SpeedDialChild(
                          child: Container(
                              margin: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                "images/air_but.png",
                                scale: 0.8,
                              )),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          label: 'First',
                          labelShadow: null,
                          labelStyle: const TextStyle(fontSize: 18.0),
                          labelBackgroundColor: Colors.black87,
                          onTap: () => Navigator.push(context, pushRoute(const BotScreen("airdrop"))),
                          labelWidget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            margin: const EdgeInsets.only(right: 10.0),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Aidrop'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SpeedDialChild(
                          child: Container(
                              margin: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                "images/give_but.png",
                                scale: 0.8,
                              )),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          label: 'Second',
                          onTap: () => Navigator.push(context, pushRoute(const BotScreen("gw"))),
                          elevation: 5.0,
                          labelWidget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            margin: const EdgeInsets.only(right: 10.0),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Giveaway'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      shape: const StadiumBorder(),
                      // width: 50.0,
                      // height: 50.0,
                      // radius: 50.0,
                      // color: Colors.lightGreen,
                      // onTap: () {
                      //   Navigator.push(context, pushRoute(const BotScreen()));
                      // },
                      child: const Text(
                        "+",
                        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
