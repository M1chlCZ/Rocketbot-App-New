import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/launchpad.dart';

class LaunchpadTile extends StatelessWidget {
  final Stuff launchpad;
  final Function(int launchpadID) callBack;

  const LaunchpadTile({Key? key, required this.launchpad, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white30,
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        callBack(launchpad.launchpad!.id!);
      },
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
          color: const Color(0xFF384259).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 8.0,
            ),
            Container(
              height: 75,
              width: 80.0,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(

                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: launchpad.artwork!,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.65,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.65,
                    height: 20.0,
                    child: AutoSizeText(
                      launchpad.name!,
                      maxLines: 1,
                      minFontSize: 8.0,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15.0, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      launchpad.description ?? "",
                      maxLines: 4,
                      minFontSize: 8.0,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: Padding(
            //       padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
            //       child: SizedBox(width: 22, height: 22, child: socialMedia(giveaway.socialMedia!)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class LaunchpadTopTile extends StatelessWidget {
  final Top launchpad;
  final int position;
  final Function(int launchpadID) callBack;

  const LaunchpadTopTile({Key? key, required this.launchpad, required this.callBack, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white30,
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        callBack(launchpad.launchpadId!);
      },
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
          color: const Color(0xFF384259).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 8.0,
            ),
            Container(
              height: 75,
              width: 80.0,
              decoration: BoxDecoration(
                color: position == 0 ? Colors.amber : Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(

                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: launchpad.imageUrl!,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              width: MediaQuery
                  .sizeOf(context)
                  .width * 0.65,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(width: 55,),
                  Expanded(
                    child: AutoSizeText(
                      launchpad.name!,
                      maxLines: 1,
                      minFontSize: 8.0,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontFamily: 'JosefinSans',
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          color: Colors.white),
                    ),
                  ),
                  const Expanded(child: SizedBox(),),
                  Expanded(
                    child: AutoSizeText(
                      "\$${launchpad.totalAmount?.toStringAsFixed(2)}",
                      maxLines: 1,
                      minFontSize: 8.0,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'JosefinSans',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          fontSize: 24.0,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: Padding(
            //       padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
            //       child: SizedBox(width: 22, height: 22, child: socialMedia(giveaway.socialMedia!)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
