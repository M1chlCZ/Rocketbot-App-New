import 'package:flutter/material.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:webviewx/webviewx.dart';

class RamperScreen extends StatefulWidget {
  final String idCoin;
  final String depositAddr;
  final int userID;

  const RamperScreen({Key? key, required this.idCoin, required this.depositAddr, required this.userID}) : super(key: key);

  @override
  State<RamperScreen> createState() => _RamperScreenState();
}

class _RamperScreenState extends State<RamperScreen> {
  late WebViewXController webviewController;

  @override
  void initState() {
    super.initState();
    print("https://buy.onramper.com?darkmode=true&apiKey=pk_prod_01GRC4A70MRHE8RZM8E7TE46YE&defaultCrypto=${widget.idCoin.toUpperCase()}&wallets=${widget.idCoin.toUpperCase()}:${widget.depositAddr}&supportSell=false&supportSwap=false&partnerContext=${widget.userID}");
  }

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                child: Row(
                  children: [
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
                      child: Text("Buy ${widget.idCoin}",
                        style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),

                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal:10, vertical:10),
                  padding: const EdgeInsets.symmetric(horizontal:10, vertical:10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: SafeArea(
                        child: WebViewX(
                          initialContent: """
  <iframe   src="https://buy.onramper.com?darkmode=true&apiKey=pk_prod_01GRC4A70MRHE8RZM8E7TE46YE&defaultCrypto=${widget.idCoin.toUpperCase()}&wallets=${widget.idCoin.toUpperCase()}:${widget.depositAddr}&supportSell=false&supportSwap=false&partnerContext=${widget.userID}"
  height="${constraints.maxHeight}"
  width="${constraints.maxWidth}"
  title="Onramper widget"
  frameborder="0"
  allow="accelerometer;
  autoplay; camera; gyroscope; payment; keyboard;"
  style="box-shadow: 1px 1px 1px 1px
  rgba(0,0,0,0.2);"
>
  </iframe>
                                          """,
                          initialSourceType: SourceType.html,
                          onWebViewCreated: (controller) => webviewController = controller,
                          width: constraints.maxHeight,
                          height: constraints.maxWidth ,
                        ),
//         Column(
//             children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
//             child: Row(children: [
//               SizedBox(
//                 height: 30,
//                 width: 25,
//                 child: FlatCustomButton(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new,
//                     size: 24.0,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 20.0,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text(
//                   widget.idCoin,
//                   style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
//                 ),
//               ),
//             ]),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: Container(
//            margin: MediaQuery.of(context).viewInsets,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
//                     return Center(
//                       child: Stack(
//                         children: [
//                           Html(
//                             shrinkWrap: true,
//                             data: """
//   <iframe
//   src="https://buy.onramper.com?color=266677&darkmode=true&apiKey=pk_prod_B7UiJhtLIMs_c6f1JhZOj6rjG0RcwyjxOmV3RZa7D7Y0&defaultCrypto=${widget.idCoin.toUpperCase()}&wallets=${widget.idCoin.toUpperCase()}:${widget.depositAddr}&supportSell=false&supportSwap=false"
//   height="${constraints.maxHeight}"
//   width="$width"
//   title="Onramper widget"
//   frameborder="0"
//   allow="accelerometer;
//   autoplay; camera; gyroscope; payment; keyboard;"
//   style="box-shadow: 1px 1px 1px 1px
//   rgba(0,0,0,0.2);"
// >
//   </iframe>
//                               """,
//                             customRenders: {
//                               iframeMatcher(): iframeRender(),
//                             },
//                           ),
//                         ],
//                       ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
