import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:rocketbot/models/notifications.dart';
import 'package:rocketbot/providers/not_provider.dart';
import 'package:rocketbot/storage/app_database.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/notification_tile.dart';

class NotificationScreen extends ConsumerWidget {
   NotificationScreen({Key? key}) : super(key: key);

  AppDatabase db = GetIt.I.get<AppDatabase>();
  List<NotNode> _list = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _getNot();
  // }
  //
  // void _getNot() async {
  //   Future.delayed(Duration.zero, () async {
  //     _list = await db.getNotifications();
  //     setState(() {});
  //     db.setRead();
  //   });
  // }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
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
                          Text("Notifications", style: Theme
                              .of(context)
                              .textTheme
                              .displaySmall),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Flexible(
                      child: not.when(
                        data: (data) {
                          _list = data;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: _list.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return NotificationTile(node: _list[index],);
                              });
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, s) => const Center(child: Text("Error")),
                        // child: ListView.builder(
                        //   shrinkWrap: true,
                        //     itemCount: _list.length,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     itemBuilder: (context, index) {
                        //       return NotificationTile(node: _list[index],);
                        //     }),
                      ),
                    ),
                  ]),
            )
        )
    );
  }
}
