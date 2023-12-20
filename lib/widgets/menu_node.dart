import 'package:flutter/material.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class MenuNode extends StatelessWidget {
  final String menuText;
  final VoidCallback goto;
  const MenuNode({super.key, required this.menuText, required this.goto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Card(
          elevation: 0,
          color: Theme.of(context).canvasColor,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: InkWell(
            splashColor: Colors.black54,
            highlightColor: Colors.black54,
            onTap: () async {
             goto();
            },
            // widget.coinSwitch(widget.coin);
            // widget.activeCoin(widget.coin.coin!);

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      menuText,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                          fontSize: 14.0,
                          color: Colors.white)),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  FlatCustomButton(
                      height: 25,
                      width: 20,
                      onTap: ()  {
                        goto();
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.white,
                        size: 22.0,
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
