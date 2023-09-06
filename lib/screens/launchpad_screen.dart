import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/bloc/get_airdrops_bloc.dart';
import 'package:rocketbot/bloc/get_giveaways_bloc.dart';
import 'package:rocketbot/bloc/get_lotteries_bloc.dart';
import 'package:rocketbot/providers/launchpad_provider.dart';
import 'package:rocketbot/screens/games_switch.dart';
import 'package:rocketbot/screens/launchpad_details.screen.dart';
import 'package:rocketbot/widgets/launchpad_tile.dart';

import '../netinterface/interface.dart';
import '../widgets/animted_list_item_wrapper.dart';

class LaunchpadScreen extends ConsumerStatefulWidget {
  final VoidCallback prevScreen;
  final VoidCallback nextScreen;

  const LaunchpadScreen({
    Key? key,
    required this.prevScreen,
    required this.nextScreen,
  }) : super(key: key);

  @override
  ConsumerState<LaunchpadScreen> createState() => _LaunchpadScreenState();
}

class _LaunchpadScreenState extends ConsumerState<LaunchpadScreen> with AutomaticKeepAliveClientMixin<LaunchpadScreen> {
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

  void launchpadCallback(int id) {
    if (id != 0) {
      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
        return LaunchpadDetailsScreen(launchpadID: id);
      }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      }));
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    widthScreen = MediaQuery.sizeOf(context).width;
    final launchpad = ref.watch(launchpadProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            launchpad.when(data: (data) {
              return ExcludeSemantics(
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
                            activeSection = index;
                            _switchKey.currentState?.currentPage(index);
                          });
                        },
                        controller: _pageController,
                        children: [
                          if (data.topForever!.isNotEmpty || data.topWeek!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0, top: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: NotificationListener<UserScrollNotification>(
                                  onNotification: (UserScrollNotification notification) {
                                    if (notification.direction == ScrollDirection.forward || notification.direction == ScrollDirection.reverse) {
                                      scrollDirectionNotifier.value = notification.direction;
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                      key: const PageStorageKey(0),
                                      controller: gwScroll,
                                      shrinkWrap: false,
                                      itemCount: data.topWeek!.length + data.topForever!.length + 2,
                                      itemBuilder: (ctx, index) {
                                        if (index == 0) {
                                          // Separator - TOP WEEK
                                          return const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("TOP 10 WEEK"),
                                          );
                                        } else if (index <= data.topWeek!.length) {
                                          // topWeek data
                                          final weekIndex = index - 1; // adjusting index because of separator at 0th position
                                          return ValueListenableBuilder(
                                              valueListenable: scrollDirectionNotifier,
                                              child: LaunchpadTopTile(
                                                key: ValueKey<int>(data.topWeek![weekIndex].launchpadId!),
                                                launchpad: data.topWeek![weekIndex],
                                                callBack: launchpadCallback,
                                                position: weekIndex,
                                              ),
                                              builder: (BuildContext context, scrollDirection, Widget? child) {
                                                return AnimatedListItemWrapper(
                                                  scrollDirection: scrollDirection,
                                                  child: child!,
                                                );
                                              });
                                        } else if (index == data.topWeek!.length + 1) {
                                          // Separator - TOP FOREVER
                                          return const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("TOP 10 FOREVER"),
                                          );
                                        } else {
                                          // topForever data
                                          final foreverIndex = index - data.topWeek!.length - 2; // adjusting index because of separators
                                          return ValueListenableBuilder(
                                              valueListenable: scrollDirectionNotifier,
                                              child: LaunchpadTopTile(
                                                key: ValueKey<int>(data.topForever![foreverIndex].launchpadId!),
                                                launchpad: data.topForever![foreverIndex],
                                                callBack: launchpadCallback,
                                                position: foreverIndex,
                                              ),
                                              builder: (BuildContext context, scrollDirection, Widget? child) {
                                                return AnimatedListItemWrapper(
                                                  scrollDirection: scrollDirection,
                                                  child: child!,
                                                );
                                              });
                                        }
                                      }),
                                ),
                              ),
                            ),
                          if (data.topForever!.isEmpty && data.topWeek!.isEmpty)
                            const Center(
                              child: Text("Whitelist launchpad list is empty"),
                            ),
                          if (data.whitelist?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0, top: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: NotificationListener<UserScrollNotification>(
                                  onNotification: (UserScrollNotification notification) {
                                    if (notification.direction == ScrollDirection.forward || notification.direction == ScrollDirection.reverse) {
                                      scrollDirectionNotifier.value = notification.direction;
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                      key: const PageStorageKey(0),
                                      controller: gwScroll,
                                      shrinkWrap: false,
                                      itemCount: data.whitelist?.length ?? 0,
                                      itemBuilder: (ctx, index) {
                                        return ValueListenableBuilder(
                                            valueListenable: scrollDirectionNotifier,
                                            child: LaunchpadTile(
                                                key: ValueKey<int>(data.whitelist![index].launchpad!.id!),
                                                launchpad: data.whitelist![index],
                                                callBack: launchpadCallback),
                                            builder: (BuildContext context, scrollDirection, Widget? child) {
                                              return AnimatedListItemWrapper(
                                                scrollDirection: scrollDirection,
                                                child: child!,
                                              );
                                            });
                                      }),
                                ),
                              ),
                            ),
                          if (data.whitelist?.isEmpty ?? false)
                            const Center(
                              child: Text("Whitelist launchpad list is empty"),
                            ),
                          if (data.presale?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0, top: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: NotificationListener<UserScrollNotification>(
                                  onNotification: (UserScrollNotification notification) {
                                    if (notification.direction == ScrollDirection.forward || notification.direction == ScrollDirection.reverse) {
                                      scrollDirectionNotifier.value = notification.direction;
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                      key: const PageStorageKey(0),
                                      controller: adScroll,
                                      shrinkWrap: false,
                                      itemCount: data.presale?.length ?? 0,
                                      itemBuilder: (ctx, index) {
                                        return ValueListenableBuilder(
                                            valueListenable: scrollDirectionNotifier,
                                            child: LaunchpadTile(
                                                key: ValueKey<int>(data.presale![index].launchpad!.id!),
                                                launchpad: data.presale![index],
                                                callBack: launchpadCallback),
                                            builder: (BuildContext context, scrollDirection, Widget? child) {
                                              return AnimatedListItemWrapper(
                                                scrollDirection: scrollDirection,
                                                child: child!,
                                              );
                                            });
                                      }),
                                ),
                              ),
                            ),
                          if (data.whitelist?.isEmpty ?? false)
                            const Center(
                              child: Text("Pre-sale launchpad list is empty"),
                            ),
                          if (data.public?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0, top: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: NotificationListener<UserScrollNotification>(
                                  onNotification: (UserScrollNotification notification) {
                                    if (notification.direction == ScrollDirection.forward || notification.direction == ScrollDirection.reverse) {
                                      scrollDirectionNotifier.value = notification.direction;
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                      key: const PageStorageKey(0),
                                      controller: ltScroll,
                                      shrinkWrap: false,
                                      itemCount: data.public?.length ?? 0,
                                      itemBuilder: (ctx, index) {
                                        return ValueListenableBuilder(
                                            valueListenable: scrollDirectionNotifier,
                                            child: LaunchpadTile(
                                                key: ValueKey<int>(data.public![index].launchpad!.id!),
                                                launchpad: data.public![index],
                                                callBack: launchpadCallback),
                                            builder: (BuildContext context, scrollDirection, Widget? child) {
                                              return AnimatedListItemWrapper(
                                                scrollDirection: scrollDirection,
                                                child: child!,
                                              );
                                            });
                                      }),
                                ),
                              ),
                            ),
                          if (data.public?.isEmpty ?? false)
                            const Center(
                              child: Text("Public launchpad list is empty"),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GameSwitcher(
                          key: _switchKey,
                          games: const ['*', 'Whitelist', 'Pre-sale', 'Public'],
                          changeType: (page) {
                            setState(() {
                              activeSection = page;
                            });
                            _pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
                          }),
                    ),
                  ],
                ),
              );
            }, loading: () {
              return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white24,
                    strokeWidth: 1.0,
                  ));
            }, error: (error, stack) {
              return Center(child: Text(error.toString()));
            }),
          ],
        ),
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}

