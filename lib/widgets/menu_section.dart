import 'package:flutter/material.dart';
import 'package:rocketbot/widgets/menu_node.dart';

class MenuSection extends StatelessWidget {
  final String sectionName;
  final List<MenuNode> children;
  const MenuSection({super.key, required this.sectionName, required this.children});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
         sectionName,
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.0, color: Colors.white24),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          height: 0.5,
          color: Colors.white12,
        ),
        const SizedBox(
          height: 10.0,
        ),
        ...children
      ],
    );
  }
}
