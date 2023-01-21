import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';

import '../widgets/button_flat.dart';

class RamperScreen extends StatelessWidget {
  final String idCoin;
final String depositAddr;
  const RamperScreen({Key? key, required this.idCoin, required this.depositAddr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
            child: Row(children: [
              SizedBox(
                height: 30,
                width: 25,
                child: FlatCustomButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 24.0,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  idCoin,
                  style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return Center(
                      child: Html(
                        data: """
  <iframe
  src="https://widget.onramper.com?color=266677&darkmode=true&apiKey=pk_prod_B7UiJhtLIMs_c6f1JhZOj6rjG0RcwyjxOmV3RZa7D7Y0&defaultCrypto=$idCoin&wallets=$idCoin:$depositAddr&excludeCryptos=BTC,ETH&supportSell=false&supportSwap=false"
  height="${constraints.maxHeight}"
  width="$width"
  title="Onramper widget"
  frameborder="0"
  allow="accelerometer;
  autoplay; camera; gyroscope; payment"
  style="box-shadow: 1px 1px 1px 1px
  rgba(0,0,0,0.2);"
>
  </iframe>
                          """,
                        customRenders: {
                          iframeMatcher(): iframeRender(),
                        },
                      ),
                  );
                }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
