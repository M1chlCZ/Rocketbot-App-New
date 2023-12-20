import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/exchanges.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class ExchangeTile extends StatelessWidget {
  final Exchange ex;
  final String coin;

  const ExchangeTile({super.key, required this.ex, required this.coin});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        color: Colors.black12,
        child: InkWell(
          customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          splashColor: Colors.black87,
          onTap: () {
            Utils.openLink(ex.url);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: 200,
                child: AutoSizeText(ex.name ?? "",
                    maxLines: 1,
                    minFontSize: 10,
                    textAlign: TextAlign.start, style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 14.0, color: Colors.white)),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                      child: AutoSizeText("$coin/${ex.target.toString()}",
                          maxLines: 1,
                          minFontSize: 8,
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 12.0, color: Colors.white))),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    height: double.infinity,
                    color: const Color(0xFF252F45),
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  FlatCustomButton(
                    width: 30,
                    height: double.infinity,
                    color: Colors.transparent,
                    onTap: () {
                      Utils.openLink(ex.url);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.white30,
                    ),
                  ),
                  const SizedBox(
                    width: 5,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
