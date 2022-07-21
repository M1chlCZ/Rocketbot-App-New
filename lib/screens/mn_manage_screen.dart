import 'package:flutter/material.dart';
import 'package:rocketbot/models/masternode_info.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class MasternodeManageScreen extends StatefulWidget {
  final MasternodeInfo mnInfo;

  const MasternodeManageScreen({Key? key, required this.mnInfo}) : super(key: key);

  @override
  State<MasternodeManageScreen> createState() => _MasternodeManageScreenState();
}

class _MasternodeManageScreenState extends State<MasternodeManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
                child: FlatCustomButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(children: [
                    const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text("Masternode Management", style: Theme.of(context).textTheme.headline3),
                  ]),
                )),
            const SizedBox(
              height: 50.0,
            ),
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.mnInfo.mnList!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      key: ValueKey(widget.mnInfo.mnList![index].id),
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 65.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.black12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${widget.mnInfo.mnList![index].id}",
                                      style: const TextStyle(fontSize: 24.0, color: Colors.amberAccent),
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  height: 40.0,
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.black26,
                                  ),
                                  child: Text(
                                    "${widget.mnInfo.mnList![index].ip}",
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontSize: 14.0, color: Colors.white70),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Average payrate:", style: TextStyle(fontSize: 14.0, color: Colors.white70),),
                              Text(widget.mnInfo.mnList![index].averagePayTime.toString(), style: const TextStyle(fontSize: 14.0, color: Colors.white70),),
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Last seen:", style: TextStyle(fontSize: 14.0, color: Colors.white70),),
                              Text(Utils.convertDate(widget.mnInfo.mnList![index].lastSeen), style: const TextStyle(fontSize: 14.0, color: Colors.white70),),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              //add some actions, icons...etc
                              FlatCustomButton(
                                  onTap: () {
                                    Dialogs.openAlertBox(context, "Info", "Not implemented");
                                  },
                                  color: Colors.transparent,
                                  child: const Text("INFO")),
                              const SizedBox(
                                width: 20.0,
                              ),
                              FlatCustomButton(
                                  onTap: () {
                                    Dialogs.openAlertBox(context, "Info", "Not implemented");
                                  },
                                  color: Colors.transparent,
                                  child: const Text(
                                    "DELETE",
                                    style: TextStyle(color: Colors.redAccent),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    );
                    // return ListTile(
                    //     key: ValueKey(widget.mnInfo.mnList![index].id),
                    //     title: Text(widget.mnInfo.mnList![index].ip.toString()),
                    //     subtitle: Text(Utils.convertDate(widget.mnInfo.mnList![index].lastSeen.toString())),
                    //     trailing: Text("shit"),
                    //     leading: Text(widget.mnInfo.mnList![index].id.toString()));
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
