import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/providers/dep_addr_provider.dart';
import 'package:rocketbot/providers/websocket_test_provider.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:webviewx/webviewx.dart';

class RamperScreen extends ConsumerStatefulWidget {
  final Coin coin;
  final int userID;
  final String email;

  const RamperScreen({Key? key, required this.coin, required this.userID, required this.email}) : super(key: key);

  @override
  ConsumerState<RamperScreen> createState() => _RamperScreenState();
}

class _RamperScreenState extends ConsumerState<RamperScreen> {
  late WebViewXController webviewController;
  String? depositAddr;
  var textData = "";
  var lastLine = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        ref.read(depAddressProvider(widget.coin.id!)).whenData((value) {
          depositAddr = value;
          webviewController.reload();
        });
      });
      // _getStream();
    });
  }

  // _getStream() {
  //   final channel = WebSocketChannel.connect(Uri.parse('ws://mobileapp.rocketbot.pro/api/ws?userId=${widget.userID}'));
  //   final subscription = channel.stream.listen((event) {
  //     print(event);
  //   }, onError: (e) {
  //     print(e);
  //   }, onDone: () {
  //     print("done");
  //   });
  //   channel.sink.add("shit");
  //   // channel.sink.close();
  //   //
  // }

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final webSocketStream = ref.watch(webSocketProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
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
                    child: Text(
                      "Buy ${widget.coin.ticker}",
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
            // Center(
            //   child: webSocketStream.when(data: (data)  {
            //     debugPrint("data: $data");
            //     if (data != null) {
            //       textData += data + "\n";
            //       lastLine = data;
            //     }
            //     return Text(textData);
            //     }, error: (err, st) => Text(err.toString()), loading: () => const Text("Loading...")),
            //   ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
  <iframe   src="https://buy.onramper.com?darkmode=true&apiKey=pk_prod_01H037JKN767VYZRAS9Q32F7CW&defaultCrypto=${widget.coin.ticker!.toUpperCase()}&wallets=${widget.coin.ticker!.toUpperCase()}:$depositAddr&supportSell=false&supportSwap=false&partnerContext=${widget.userID}"
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
                        mobileSpecificParams: const MobileSpecificParams(
                          androidEnableHybridComposition: true,
                        ),
                        width: constraints.maxHeight,
                        height: constraints.maxWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
