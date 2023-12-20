import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/models/launchpad_detail.dart';
import 'package:universal_io/io.dart';

class LaunchpadMemberTile extends StatelessWidget {
  final WhitelistPeople member;

  // final Function(Members g) callBack;

  const LaunchpadMemberTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Stack(
        children: [
          InkWell(
            splashColor: Colors.white30,
            // onTap: () {
            // callBack(giveaway);
            // },
            child: Column(
              children: [
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    const SizedBox(
                      width: 15.0,
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),),
                        CircleAvatar(
                          radius: 20.0,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              progressIndicatorBuilder: (context, url, progress) =>
                                  Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                              errorWidget: (context, message, dyn) {
                                return Container();
                              },
                              imageUrl: member.pfpUrl ?? "",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      height: 50.0,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: AutoSizeText(
                                member.name ?? "",
                                maxLines: 1,
                                minFontSize: 8.0,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 15.0, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: AutoSizeText(
                                member.bio ?? "",
                                maxLines: 1,
                                minFontSize: 8.0,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        parseDate(member.createdAt ?? "0000-00-01"), style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white54),
                        maxLines: 1,
                        minFontSize: 8.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0,),
                const Divider(height: 1.0, color: Colors.white24,)
              ],
            ),
          ),
        ],
      ),
    );
  }
  String parseDate(String s) {
    DateTime dt = DateTime.parse(s);
    return DateFormat.MMMEd(Platform.localeName).add_jm().format(dt);
  }
}