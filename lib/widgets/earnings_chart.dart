import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/sector.dart';

class EarningsChart extends StatefulWidget {
  final List<Sector> sectors;

  const EarningsChart(this.sectors, {Key? key}) : super(key: key);

  @override
  State<EarningsChart> createState() => _EarningsChartState();
}

class _EarningsChartState extends State<EarningsChart> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
            pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 1,
            centerSpaceRadius: 55,
            centerSpaceColor: Colors.transparent,
            sections: showingSections(widget.sectors)),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Sector> sectors) {
    final List<PieChartSectionData> list = [];
    int i = 0;
    for (var sector in sectors) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? sector.radius! * 1.2 : sector.radius!;
      final data = PieChartSectionData(
        color: sector.color,
        value: sector.value,
        radius: radius,
        // badgeWidget: Container(
        //   height: 55,
        //     width: 100,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(5.0),
        //       color: sector.color!,
        //     ),
        //     child: Center(
        //       child: Padding(
        //         padding: const EdgeInsets.all(4.0),
        //         child: Column(
        //           children: [
        //             AutoSizeText(
        //                 sector.nam,
        //               maxLines: 1,
        //               minFontSize: 4.0,
        //               style: Theme.of(context).textTheme.bodyMedium,
        //             ),
        //             AutoSizeText(
        //               sector.value.toString(),
        //               maxLines: 1,
        //               minFontSize: 4.0,
        //               style: const TextStyle(color: Colors.white),
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        // ),
        title: '',
      );
      list.add(data);
      i++;
    }
    return list;
  }
}
