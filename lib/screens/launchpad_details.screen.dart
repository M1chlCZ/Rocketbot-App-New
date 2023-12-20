import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/providers/launchpad_provider.dart';
import 'package:rocketbot/providers/network_provider.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/extensions.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/launchpad_members.dart';

class LaunchpadDetailsScreen extends ConsumerStatefulWidget {
  final int launchpadID;

  const LaunchpadDetailsScreen({super.key, required this.launchpadID});

  @override
  ConsumerState<LaunchpadDetailsScreen> createState() => _LaunchpadDetailsScreenState();
}

class _LaunchpadDetailsScreenState extends ConsumerState<LaunchpadDetailsScreen> {
  final TextEditingController codeControl = TextEditingController();
  String? currentImage;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final launchpad = ref.watch(launchpadDetailProvider(widget.launchpadID));
    return Scaffold(
        body: SafeArea(
            child: Stack(
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
                    Text("Launchpad detail", style: Theme.of(context).textTheme.displaySmall),
                  ]),
                )),
            const SizedBox(
              height: 20.0,
            ),
            launchpad.when(
              data: (data) {
                if (currentImage == null) {
                  currentImage = data.artworks!.first;
                  context.afterBuild(() {
                    timer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
                      setState(() {
                        currentImage = data.artworks![Random().nextInt(data.artworks!.length - 1)];
                      });
                    });
                  });
                }
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 128,
                            maxHeight: 192,
                            minWidth: 128,
                            maxWidth: 192,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              child: CachedNetworkImage(
                                imageUrl: currentImage ?? "",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                  strokeWidth: 1.0,
                                )),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
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
                                if (data.currentStage!.toLowerCase() == "public")
                                  Expanded(child: smallBlock("Public Sale", "Stage", color: Colors.green)),
                                if (data.currentStage!.toLowerCase() == "whitelist")
                                  Expanded(child: smallBlock("Whitelist", "Stage", color: Colors.green)),
                                if (data.currentStage!.toLowerCase() == "presale")
                                  Expanded(child: smallBlock("Presale", "Stage", color: Colors.green))
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
                                  child: smallBlock(data.collection?.name ?? "", "Name"),
                                ),
                                const SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                  child: smallBlock(data.creator ?? "", "Creator"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        if (data.currentStage!.toLowerCase() != "public")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: SizedBox(
                              height: 80.0,
                              child: Row(
                                children: [
                                  // Expanded(
                                  //   child: smallBlock(data.currentStage!.capitalize(), "Status"),
                                  // ),
                                  // const SizedBox(
                                  //   width: 30.0,
                                  // ),
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: Stream.periodic(const Duration(seconds: 1)),
                                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                        return smallBlock(
                                            convertDate(data.currentStage!.toLowerCase() == "whitelist"
                                                ? data.launchpadData!.whitelistEnds
                                                : data.launchpadData!.presaleEnds),
                                            "Time to end");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        if (data.currentStage!.toLowerCase() != "whitelist")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: SizedBox(
                              height: 80.0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: smallBlock((data.sales ?? 0).toString(), "Sales"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        if (data.currentStage!.toLowerCase() == "whitelist" && data.userState == 0 && (data.launchpadAccess == 1 || data.launchpadAccess == 0))
                          Container(
                            height: 60.0,
                            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                            child: FlatCustomButton(
                              color: Colors.pink,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Join Whitelist"),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(
                                    Icons.open_in_new,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ],
                              ),
                              onTap: () {
                                ref.read(networkProvider).post("/whiteList",
                                    {
                                      "id": data.launchpadData?.id,
                                    },
                                    launchpad: true,
                                    debug: false);
                                ref.invalidate(launchpadDetailProvider);
                              },
                            ),
                          )
                        else
                          Container(
                            height: 60.0,
                            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                            child: FlatCustomButton(
                              color: Colors.pink,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Take me there"),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(
                                    Icons.open_in_new,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Utils.openLink("http://rocket.art/launchpad?id=${data.launchpadData!.encLink!}");
                              },
                            ),
                          ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        if (data.currentStage!.toLowerCase() != "whitelist")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: bigBlock("${data.collection?.name ?? ""} Sales"),
                          ),
                        if (data.currentStage!.toLowerCase() == "whitelist")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: bigBlock("${data.collection?.name ?? ""} Members"),
                          ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        if (data.currentStage!.toLowerCase() != "whitelist")
                          Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.salesPeople?.length ?? 0,
                                  itemBuilder: (ctx, index) {
                                    return SizedBox(
                                        height: 80.0,
                                        child: LaunchpadMemberTile(
                                            key: ValueKey<int>(data.salesPeople![index].id ?? 0), member: data.salesPeople![index]));
                                  })),
                        if (data.currentStage!.toLowerCase() == "whitelist")
                          Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.whitelistPeople?.length ?? 0,
                                  itemBuilder: (ctx, index) {
                                    return SizedBox(
                                        height: 80.0,
                                        child: LaunchpadMemberTile(
                                            key: ValueKey<int>(data.whitelistPeople![index].id ?? 0), member: data.whitelistPeople![index]));
                                  })),
                        const SizedBox(
                          height: 100.0,
                        ),
                      ],
                    ),
                    if (data.launchpadAccess! == 2 && data.userState! == 0)
                      Positioned.fill(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height,
                          decoration: const BoxDecoration(
                            color: Color(0xFF252F45),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Launchpad access is restricted",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white70, fontSize: 24),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 350,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: TextField(
                                      autofocus: true,
                                      controller: codeControl,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        isDense: false,
                                        contentPadding: const EdgeInsets.only(bottom: 0.0),
                                        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54, fontSize: 20.0),
                                        hintText: "Enter invite code",
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white70),
                                        ),
                                      ),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24.0, color: Colors.white70),
                                    ),
                                  ),
                                  FlatCustomButton(
                                    height: 40,
                                    width: 60,
                                    icon: const Icon(
                                      Icons.arrow_circle_right,
                                      size: 35,
                                      color: Colors.white70,
                                    ),
                                    onTap: () {
                                      if (codeControl.text.isNotEmpty) {
                                        _enterCode(codeControl.text);
                                      } else {
                                        if (context.mounted) Dialogs.openAlertBox(context, "Error", "Enter code");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
              error: (e, st) => Center(
                child: Text(e.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 1.0,
                ),
              ),
            ),
          ]),
        ),
      ],
    )));
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

  void _enterCode(String text) async {
    Map<String, dynamic> m = {
      "code": text,
    };
    try {
      var net = ref.read(networkProvider);
      await net.post("/whitelist/redeem", m, launchpad: true, debug: false);
      Future.delayed(Duration.zero, () async {
        ref.invalidate(launchpadDetailProvider);
      });
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) Dialogs.openAlertBox(context, "Error", "Code is invalid");
    }
  }
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
