import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/giveaways.dart';
import 'package:rocketbot/widgets/picture_cache.dart';

class GiveawayTile extends StatelessWidget {
  final Giveaway giveaway;
  final Function(Giveaway g) callBack;

  const GiveawayTile({Key? key, required this.giveaway, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 10.0),
            child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Image.asset('images/giveway_tile_background.png', fit: BoxFit.fill,)),
          ),
          InkWell(
            splashColor: Colors.white30,
            onTap: () {
              callBack(giveaway);
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 22.0,
                ),
                Container(
                  height: 70,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: PictureCacheWidget(coin: giveaway.coin!),
                ),
                const SizedBox(
                  width: 60.0,
                ),
                SizedBox(
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "[${giveaway.coin!.ticker!}] ${giveaway.coin!.tokenStandart!}",
                        maxLines: 1,
                        minFontSize: 8.0,
                        textAlign: TextAlign.start,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                      AutoSizeText(
                        giveaway.channel!.name!,
                        maxLines: 1,
                        minFontSize: 8.0,
                        style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right:MediaQuery.of(context).size.width * 0.05),
                      child: SizedBox(
                        width: 22,
                          height: 22,
                          child: socialMedia(giveaway.socialMedia!)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget socialMedia(int? socials) {
    if (socials == null) {
      return const SizedBox();
    } else {
      switch (socials) {
        case 1:
          return Image.asset("images/discord.png", color: Colors.white30);
        case 2:
          return Image.asset("images/telegram.png", color: Colors.white30);
        case 3:
          return Image.asset("images/twitter.png", color: Colors.white30);
      }
      return const SizedBox();
    }
  }
}
