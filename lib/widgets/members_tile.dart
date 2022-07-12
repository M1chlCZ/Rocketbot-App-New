import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/models/giveaway_members.dart';

class MembersTile extends StatelessWidget {
  final Members member;
  final Function(Members g) callBack;

  const MembersTile({Key? key, required this.member, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          splashColor: Colors.white30,
          onTap: () {
            // callBack(giveaway);
          },
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
                            progressIndicatorBuilder: (context, url, progress) => Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                              ),
                            ),
                            imageUrl:
                            "https://app.rocketbot.pro/Image?imageId=${member.socialMediaAccount!.imageId!}",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: 200,
                    child: AutoSizeText(
                      member.socialMediaAccount!.name!,
                      maxLines: 1,
                      minFontSize: 8.0,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: AutoSizeText(
                          parseDate(member.participateAt!),
                          maxLines: 1,
                          minFontSize: 8.0,
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white54),
                        ),
                      ),
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
    );
  }
}

String parseDate(String s) {
  DateTime dt = DateTime.parse(s);
  return DateFormat.MEd(Platform.localeName).add_jm().format(dt);
}
