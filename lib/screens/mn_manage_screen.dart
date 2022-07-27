import 'package:flutter/material.dart';
import 'package:rocketbot/models/masternode_info.dart';
import 'package:rocketbot/netInterface/app_exception.dart';
import 'package:rocketbot/netinterface/interface.dart';
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
  NetInterface interface = NetInterface();
  List<MnList> sortedList = [];

  @override
  void initState() {
    super.initState();
    sortedList = widget.mnInfo.mnList!;
    sortedList.sort((a,b) {
      var A = a.id!;
      var B = b.id!;
      return A.compareTo(B);
    });
  }
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
              height: 10.0,
            ),
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      key: ValueKey(sortedList[index].id),
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
                                      "${sortedList[index].id}",
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
                                    "${sortedList[index].ip}",
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
                              Text(averagePayFormat(sortedList[index].averagePayTime.toString()), style: const TextStyle(fontSize: 14.0, color: Colors.white70),),
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Last seen:", style: TextStyle(fontSize: 14.0, color: Colors.white70),),
                              Text(Utils.convertDate(sortedList[index].lastSeen), style: const TextStyle(fontSize: 14.0, color: Colors.white70),),
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
                                    Dialogs.openAlertBox(context, "Info", "Not yet implemented");
                                  },
                                  color: Colors.transparent,
                                  child: const Text("INFO", style: TextStyle(color: Colors.white24),)),
                              const SizedBox(
                                width: 20.0,
                              ),
                              FlatCustomButton(
                                  onTap: () {
                                    Dialogs.openMNWithdrawBox(context,sortedList[index].id!, () { _withdrawNode(sortedList[index].id!);});
                                    // Dialogs.openAlertBox(context, "Info", "Not implemented");

                                  },
                                  color: Colors.transparent,
                                  child: const Text(
                                    "WITHDRAW",
                                    style: TextStyle(color: Colors.redAccent),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ]),
        ),
      ),
    );
  }

  _withdrawNode(int id) async {
    try {
      Map<String, dynamic> m = {"idNode" : id};
      await interface.post("masternode/withdraw", m, pos: true);
     if(mounted)Dialogs.openAlertBox(context, "Info", "Tokens are on the way!");
    } catch (e) {
      var err = e as ConflictDataException;
      Dialogs.openAlertBox(context, "Error", err.toString());
    }
  }

  String averagePayFormat(String s) {
    if (s == "0") {
      return "Waiting for first reward";
    }else if (s == "00:00:00.000000") {
      return "Only 1 reward received";
    }else{
      var split = s.split(".");
      return split[0];
    }
  }
}
