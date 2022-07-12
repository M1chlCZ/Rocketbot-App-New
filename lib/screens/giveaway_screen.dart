import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/get_airdrops_bloc.dart';
import 'package:rocketbot/bloc/get_giveaways_bloc.dart';
import 'package:rocketbot/bloc/get_lotteries_bloc.dart';
import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/models/loterries.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rocketbot/screens/airdrop_detail_screen.dart';
import 'package:rocketbot/screens/giveaway_detail_screen.dart';
import 'package:rocketbot/widgets/airdrop_tile.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/giveaway_tile.dart';
import 'package:rocketbot/widgets/lottery_tile.dart';

import '../netinterface/interface.dart';

class GiveAwayScreen extends StatefulWidget {
  const GiveAwayScreen({Key? key}) : super(key: key);

  @override
  State<GiveAwayScreen> createState() => _GiveAwayScreenState();
}

class _GiveAwayScreenState extends State<GiveAwayScreen>  with AutomaticKeepAliveClientMixin<GiveAwayScreen>  {
  final NetInterface interface = NetInterface();
  int activeSection = 0;
  GiveawaysBloc? gwBlock;
  AirdropsBloc? adBlock;
  LotteriesBloc? ltBlock;

  @override
  void initState() {
    super.initState();
    gwBlock = GiveawaysBloc();
    adBlock = AirdropsBloc();
    ltBlock = LotteriesBloc();
  }

  @override
  void dispose() {
    gwBlock?.dispose();
    adBlock?.dispose();
    ltBlock?.dispose();
    super.dispose();
  }
  
  void aidropCallBack(Airdrop a) {

    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return AirdropDetailScreen(
        airdrop: a,
      );
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
    
  }

  void giveawayCallback(Giveaway g) async {
   Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return GiveawayDetailScreen(
        giveaway: g,
      );
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));

    // var res = interface.get('')
  }

  void lotteryCallback(Lottery l) {

    // var res = interface.get('')

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
              child: Row(
                children: [
                 Text("Giveaways", style: Theme.of(context).textTheme.headline3),
                  const SizedBox(
                    width: 50,
                  ),
                  // SizedBox(
                  //     height: 30,
                  //     child: TimeRangeSwitcher(
                  //       changeTime: _changeTime,
                  //     )),

                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatCustomButton(
                      onTap: () {
                        setState((){
                          activeSection = 0;
                        });
                      },
                      radius: 5.0,
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Giveaway', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: activeSection == 0 ? FontWeight.w600 : FontWeight.w200, fontSize: 14.0),),),
                    SizedBox(
                      width: 20,
                      child: Text('|', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w200, fontSize: 14.0), textAlign: TextAlign.center,)
                    ),
                    FlatCustomButton(
                      onTap: () {
                        setState((){
                          activeSection = 1;
                        });
                      },
                      radius: 5.0,
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Airdrop', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: activeSection == 1 ? FontWeight.w600 : FontWeight.w200, fontSize: 14.0),),),
                    SizedBox(
                        width: 20,
                        child: Text('|', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w200, fontSize: 14.0), textAlign: TextAlign.center,)
                    ),
                    FlatCustomButton(
                      onTap: () {
                        setState((){
                          activeSection = 2;
                        });
                      },
                      radius: 5.0,
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Spin Lottery', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: activeSection == 2 ? FontWeight.w600 : FontWeight.w200, fontSize: 14.0),),)
                ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  IgnorePointer(
                    ignoring: activeSection == 0 ? false : true,
                    child: Visibility(
                      visible: activeSection == 0 ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
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
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.data!.length,
                                        itemBuilder: (ctx, index) {
                                          return GiveawayTile(giveaway: snapshot.data!.data![index], callBack: giveawayCallback, );
                                        });
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
                    ),
                  ),
                  IgnorePointer(
                    ignoring: activeSection == 1 ? false : true,
                    child: Visibility(
                      visible: activeSection == 1 ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
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
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.data!.length,
                                        itemBuilder: (ctx, index) {
                                          return AirdropTile(giveaway: snapshot.data!.data![index], callBack: aidropCallBack, );
                                        });
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
                    ),
                  ),
                  IgnorePointer(
                    ignoring: activeSection == 2 ? false : true,
                    child: Visibility(
                      visible: activeSection == 2 ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
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
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.data!.length,
                                        itemBuilder: (ctx, index) {
                                          return LotteryTile(giveaway: snapshot.data!.data![index], callBack: lotteryCallback, );
                                        });
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
