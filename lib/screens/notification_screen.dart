import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/providers/not_provider.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/notification_tile.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final not = ref.watch(notificationProvider);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text("Notifications", style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              child: not.when(
                data: (data) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return NotificationTile(
                          node: data[index],
                        );
                      });
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Center(child: Text("Error")),
              ),
            ),
          ]),
    )));
  }
}
