import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/bloc/giveaway_bloc.dart';
import 'package:rocketbot/models/active_giveaways.dart';
import 'package:rocketbot/models/giveaway_members.dart';
import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/netinterface/api_response.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/members_tile.dart';

import '../netinterface/interface.dart';

class GiveawayDetailScreen extends StatefulWidget {
  final Giveaway giveaway;

  const GiveawayDetailScreen({super.key, required this.giveaway});

  @override
  State<GiveawayDetailScreen> createState() => _GiveawayDetailScreenState();
}

//TODO Translations
class _GiveawayDetailScreenState extends State<GiveawayDetailScreen> {
  final NetInterface interface = NetInterface();
  GiveawayDetailBloc? bloc;
  ActiveGiveaway? activeGiveaway;
  List<Members>? giveawayMembers;

  @override
  void initState() {
    super.initState();
    bloc = GiveawayDetailBloc(widget.giveaway.id!, widget.giveaway.socialMedia!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: StreamBuilder<ApiResponse<Map<String, dynamic>>>(
                stream: bloc!.coinsListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.completed:
                        ActiveGiveaway ag = snapshot.data!.data!["activeGiveaway"];
                        List<Members> memba = snapshot.data!.data!["members"];
                        return Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
                                    child: FlatCustomButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(children: [
                                        const Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text("Giveaway details", style: Theme.of(context).textTheme.displaySmall),
                                      ]),
                                    )),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                //   child: SizedBox(
                                //     height: 80.0,
                                //     child: Row(
                                //       children: [
                                //         Expanded(
                                //           child: smallBlock("Retweet & Comment", "Rules", color: Colors.green),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: 20.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: SizedBox(
                                    height: 80.0,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: smallBlock(ag.coin!.name!, "Coin"),
                                        ),
                                        const SizedBox(
                                          width: 30.0,
                                        ),
                                        Expanded(
                                          child: smallBlock(ag.channel!.name!, "Creator"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: SizedBox(
                                    height: 80.0,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: smallBlock(
                                              ag.isActive != null
                                                  ? ag.isActive!
                                                      ? 'Active'
                                                      : 'Ended'
                                                  : 'Ended',
                                              "Status"),
                                        ),
                                        const SizedBox(
                                          width: 30.0,
                                        ),
                                        Expanded(
                                          child: StreamBuilder(
                                            stream: Stream.periodic(const Duration(seconds: 1)),
                                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                              return smallBlock(convertDate(ag.expirationTime!), "Time to end");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: SizedBox(
                                    height: 80.0,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: smallBlock("${ag.reward!} ${ag.coin!.ticker!}", "Reward"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 60.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: bigBlock("Giveaway Members"),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Flexible(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: memba.length,
                                        itemBuilder: (ctx, index) {
                                          return MembersTile(member: memba[index], callBack: (Members s) {});
                                        })),
                                const SizedBox(
                                  height: 100.0,
                                ),
                              ]),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 50.0,
                                margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                                child: FlatCustomButton(
                                  color: Colors.green,
                                  child: const Text("Claim the reward"),
                                  onTap: () {
                                    Utils.openLink(ag.channel?.url);
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      case Status.loading:
                        return const Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            child: Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            )),
                          ),
                        );
                      case Status.error:
                        print(snapshot.error.toString());
                        return Container();
                    }
                  } else {
                    return Container();
                  }
                })));
  }
}

Widget smallBlock(String main, String sub, {Color color = Colors.white10}) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: color,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            child: AutoSizeText(
              main,
              maxLines: 1,
              minFontSize: 8.0,
              style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 18.0, color: Colors.white),
            ),
          ),
          AutoSizeText(
            sub,
            maxLines: 1,
            minFontSize: 8.0,
            style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 13.0, color: Colors.white54),
          ),
        ],
      ),
    ),
  );
}

Widget bigBlock(String main) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white.withOpacity(0.1),
    ),
    child: Center(
      child: Column(
        children: [
          AutoSizeText(
            main,
            maxLines: 1,
            minFontSize: 8.0,
            style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w200, fontSize: 22.0, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

String convertDate(String? date) {
  DateTime dt = DateTime.parse(date!);
  final dateNow = DateTime.now();
  DateTime? fix;
  if (dateNow.timeZoneOffset.isNegative) {
    fix = dt.subtract(Duration(hours: dateNow.timeZoneOffset.inHours));
  } else {
    fix = dt.add(Duration(hours: dateNow.timeZoneOffset.inHours));
  }
  final sec = fix.difference(dateNow);
  var days = sec.inDays;
  var hours = sec.inHours % 24;
  var minutes = sec.inMinutes % 60;
  var seconds = sec.inSeconds % 60;
  return "${days < 10 ? "0$days" : "$days"}d:${hours < 10 ? "0$hours" : "$hours"}h:${minutes < 10 ? "0$minutes" : "$minutes"}m:${seconds < 10 ? "0$seconds" : "$seconds"}s";
}
