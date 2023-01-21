import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/notifications.dart';
import 'package:rocketbot/support/utils.dart';

class NotificationTile extends StatelessWidget {
  final NotNode node;

  const NotificationTile({Key? key, required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(left: 10.0, right: 15.0, bottom: 15.0),
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: _getColor(node.link).withOpacity( node.read == 0 ? 0.6 : 0.2),
            child: InkWell(
              splashColor: Colors.white70,
              onTap: () {
                Utils.openLink(node.link);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: AutoSizeText(utf8convert(node.title!),
                                maxLines: 1,
                                minFontSize: 8.0,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))),
                        AutoSizeText(Utils.convertDate(node.datePosted!),
                            maxLines: 1,
                            minFontSize: 8.0,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    AutoSizeText(utf8convert(node.body!),
                        maxLines: 1,
                        minFontSize: 8.0,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle( fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  String utf8convert(String text) {
    try {
      List<int> bytes = text.toString().codeUnits;
      return utf8.decode(bytes);
    } catch (e) {
      return text;
    }
  }

  Color _getColor(String? link) {
    if (link == null || link.isEmpty) {
      return Colors.white10;
    }
    if (link.contains("twitter")) {
      return const Color(0xFF1DA1F2);
    }
    if (link.contains("telegram")) {
      return const Color(0xFF229ED9);
    }
    if (link.contains("discord")) {
      return const Color(0xFF7289DA);
    }
    return const Color(0xFF7289DA);
  }
}
