import 'package:flutter/material.dart';
import 'package:rocketbot/models/exchanges.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/exchange_list_tile.dart';

class ExchangeListScreen extends StatefulWidget {
  final String idCoin;
  final List<Exchange> exchanges;

  const ExchangeListScreen({Key? key, required this.idCoin, required this.exchanges}) : super(key: key);

  @override
  State<ExchangeListScreen> createState() => _ExchangeListScreenState();
}

class _ExchangeListScreenState extends State<ExchangeListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                  "${widget.idCoin}",
                  style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20,),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.exchanges.length,
            itemBuilder: (context, index) {
              return ExchangeTile(
                ex: widget.exchanges[index],
                coin: widget.idCoin,
              );
            },
          ),
        ]),
      ),
    ));
  }
}
