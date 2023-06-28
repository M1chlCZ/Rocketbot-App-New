import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/models/aidrop_details.dart';
import 'package:rocketbot/models/airdrops.dart';
import 'package:rocketbot/providers/airdrop_provider.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/airdrop_members_tile.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class AirdropDetailScreen extends ConsumerWidget {
  final Airdrop airdrop;

  const AirdropDetailScreen({Key? key, required this.airdrop}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var bloc = ref.watch(airdropProvider(airdrop.id!));
    return Scaffold(
        body: SafeArea(
            child: bloc.when(
                data: (data) {
                  AirdropData ag = data["activeAirdrop"];
                  List<AirdropMembers>? memba = ag.members;
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
                                  Text("Airdrop details", style: Theme.of(context).textTheme.displaySmall),
                                ]),
                              )),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: SizedBox(
                              height: 80.0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: smallBlock("Like, Retweet, Comment & Follow ${ag.creator?.name ?? ''}", "Rules", color: Colors.green),
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
                                    child: smallBlock(ag.membersLimit!.toString(), "WINNERS LIMIT"),
                                  ),
                                  const SizedBox(
                                    width: 30.0,
                                  ),
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: Stream.periodic(const Duration(seconds: 1)),
                                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                        return smallBlock(ag.membersCount!.toString(), "USERS REWARDED");
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
                            child: bigBlock("Airdrop Winners"),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: memba!.length,
                                  itemBuilder: (ctx, index) {
                                    return AirdropMembersTile(member: memba[index], callBack: (AirdropMembers a) {});
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
                              debugPrint(ag.channel?.url ?? "== NULL ==");
                              Utils.openLink(ag.channel?.url);
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
                error: (err, st) => Text(err.toString()),
                loading: () {
                  return const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      child: Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      )),
                    ),
                  );
                })));
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
}
