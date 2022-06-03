import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/models/graph_stake_data.dart';
import 'package:rocketbot/support/duration_extension.dart';

import '../models/stake_data.dart';


class CoinStakeGraph extends StatefulWidget {
  final StakingData? stake;
  final Coin? activeCoin;
  final int type;
  final Function (bool touch) blockTouch;

  const CoinStakeGraph({Key? key, this.stake, required this.type, this.activeCoin, required this.blockTouch}) : super(key: key);

  @override
  CoinStakeGraphState createState() => CoinStakeGraphState();
}

class CoinStakeGraphState extends State<CoinStakeGraph> {
  var _touch = false;
  StakingData? _stakes;
  int _dropdownValue = 0;
  String? _date;
  String? _locale;

  final List<FlSpot> _values = [];

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;

  // double _leftTitlesInterval = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _locale = Localizations.localeOf(context).languageCode;
    });
    _dropdownValue = widget.type;
    _stakes = widget.stake;
    _getDate();
    _prepareStakeData();

  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    _date = formatter.format(now);
  }


  @override
  void dispose() {
    super.dispose();
  }

  DateTime _dateParse(String? day, int hour, int type) {
    if (type == 1 || type == 2) {
      return DateTime.parse(day!);
    }
    if (type == 3) {
      List<String> dt = day!.split("-");
      return DateTime(int.parse(dt[0]), int.parse(dt[1]));
    }
    var timeDifference = DateTime
        .now()
        .timeZoneOffset
        .inHours;
    var datetime = DateTime.parse(day!);
    DateTime newTime = DateTime.now();
    if (timeDifference >= 0) {
      newTime = datetime.add(Duration(hours: hour));
    } else {
      newTime = datetime.add(Duration(hours: hour));
    }
    return newTime.toLocal();
  }

  void _prepareStakeData() async {
    try {
      List<StakeData>? data;
      if (_stakes != null) {
        var amount = 0.0;
        List<StakeData>? dataPrep = List.generate(_stakes!.stakes!.length, (i) {
          return StakeData(
            date: _dateParse(_stakes!.stakes![i].day!, _stakes!.stakes![i].hour!, _dropdownValue),
            amount: _stakes!.stakes![i].amount!,
          );
        });
        dataPrep.sort((a, b) => a.date.compareTo(b.date));
        data = List.generate(dataPrep.length, (i) {
          amount = amount + dataPrep[i].amount;
          return StakeData(
            date: dataPrep[i].date,
            amount: amount,
          );
        });
        if (_dropdownValue == 0) {
          _maxX = const Duration(minutes: 00, hours: 24).inMinutes.toDouble();
          _minX = 0.0;
        } else if (_dropdownValue == 1) {
          _maxX = const Duration(days: 7).inDays.toDouble();
          _minX = 1.0;
        } else if (_dropdownValue == 2) {
          _maxX = Duration(days: Jiffy().daysInMonth).inDays.toDouble();
          _minX = 0.0;
        } else if (_dropdownValue == 3) {
          _maxX = 12.0;
          _minX = 0.0;
        }
        _maxY = _getMaxY(data);
        _minY = 0.0;
      }

      if (data!.isNotEmpty) {
        List<FlSpot>? valuesData;
        if (_dropdownValue == 0) {
          valuesData = data
              .map((stakeData) {
            var d = Duration(minutes: 0, hours: stakeData.date.hour);
            return FlSpot(
              d.inMinutes.toDouble(),
              stakeData.amount,
            );
          }).cast<FlSpot>()
              .toList();
          _values.addAll(valuesData);
        } else if (_dropdownValue == 1) {
          List<StakeData> dt = [];
          var add = false;
          var subst = 0.0;
          var firstMon = data.first.date.weekday == 1 ? true : false;
          if (!firstMon) {
            for (var element in data) {
              if (element.date.weekday == 1) {
                add = true;
              }
              if (add) {
                var k = element.amount - subst;
                dt.add(
                    StakeData(date: element.date, amount: k)
                );
              } else {
                subst = element.amount;
              }
            }
          } else {
            dt.add(
                StakeData(date: data.last.date, amount: data.last.amount)
            );
          }
          var i = 1;
          List<FlSpot> valuesData = dt
              .map((stakeData) {
            var d = Duration(days: i);
            i++;
            return FlSpot(
              d.inDays.toDouble(),
              stakeData.amount,
            );
          }).cast<FlSpot>()
              .toList();
          _values.addAll(valuesData);
        } else if (_dropdownValue == 2) {
          valuesData = data
              .map((stakeData) {
            var d = Duration(days: stakeData.date.day);
            return FlSpot(
              d.inDays.toDouble(),
              stakeData.amount,
            );
          }).cast<FlSpot>()
              .toList();
          _values.addAll(valuesData);
        } else if (_dropdownValue == 3) {
          valuesData = data
              .map((stakeData) {
            // var d = Duration(days: stakeData.date.month);
            return FlSpot(
              stakeData.date.month.toDouble(),
              stakeData.amount,
            );
          }).cast<FlSpot>()
              .toList();
          _values.addAll(valuesData);
        }
      }
      setState(() {});
    } catch (e) {
      _values.clear();
      debugPrint(e.toString());
    }
  }

  double _getMaxY(List<StakeData> l) {
    double max = 0;
    try {
      if (l.isEmpty) return 0;
      for (var element in l) {
        if (element.amount > max) max = element.amount;
      }
      if (max < 10) {
        return 10;
      } else if (max < 50) {
        return 50;
      } else if (max < 100) {
        return 100;
      } else if (max < 500) {
        return 500;
      } else if (max < 1000) {
        return 1000;
      } else if (max < 2000) {
        return 2000;
      } else if (max < 3000) {
        return 3000;
      } else if (max < 5000) {
        return 5000;
      } else if (max < 10000) {
        return 10000;
      } else if (max < 100000) {
        return 100000;
      } else {
        return max;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return max;
  }

  String _formatTooltip(double d) {
    try {
      var str = d.floorToDouble().toString();
      var split = str.split(".");
      var subs = split[1];
      var count = 0;
      loop:
      for (var i = 0; i < subs.length; i++) {
        if (subs[i] == "0") {
          count++;
        } else {
          break loop;
        }
      }
      if (count < 4) {
        return d.toStringAsFixed(2);
      }
      if (count > 8) {
        return d.toStringAsFixed(4);
      }
      return d.toString();
    } catch (e) {
      return "0.0";
    }
  }

  // SideTitles _leftTitles() {
  //   return SideTitles(
  //     showTitles: true,
  //     getTextStyles: (value, margin) => Theme.of(context)
  //         .textTheme
  //         .headline5!
  //         .copyWith(color: Colors.white70, fontSize: 10.0),
  //     getTitles: (value) {
  //       return _formatTitles(value.toInt());
  //     },
  //     // NumberFormat.compactCurrency(symbol: '\$').format(value),
  //     reservedSize: _dropdownValue == 0 ? 19 : 27,
  //     margin: 7,
  //     interval: _leftTitlesInterval,
  //   );
  // }

  // String _formatTitles(int i) {
  //   if (i >= 1000) {
  //     return (i / 1000).round().toString() + "k";
  //   } else if (i >= 500) {
  //     return (i / 1000).toString() + "k";
  //   } else {
  //     return i.toString();
  //   }
  // }

  // SideTitles _bottomTitles() {
  //   return SideTitles(
  //     rotateAngle: 0.0,
  //     showTitles: true,
  //     getTextStyles: (value, margin) => Theme.of(context)
  //         .textTheme
  //         .headline5!
  //         .copyWith(color: Colors.white54, fontSize: 10.0),
  //     getTitles: (value) {
  //       if (_dropdownValue == 0) {
  //         String _d = Duration(minutes: value.toInt()).toHoursMinutes();
  //         String _dd = _getMeTime("0000-00-00 " + _d);
  //         List<String> _dateParts = _dd.toString().split(" ");
  //         String _finalDate = "";
  //         if (_dateParts.length == 1) {
  //           _finalDate = _dd;
  //         } else {
  //           _finalDate = _dateParts[0] + _dateParts[1];
  //         }
  //         return _finalDate;
  //       } else if (_dropdownValue == 1) {
  //         Duration d = Duration(days: value.toInt());
  //         return d.inDays.toString();
  //       } else {
  //         Duration d = Duration(days: value.toInt());
  //         return d.inDays.toString();
  //       }
  //     },
  //     margin: 8.0,
  //     interval: (_maxX - _minX) / (4 + _dropdownValue * 4),
  //   );
  // }

  String _getMeTime(String? d, String format) {
    if (d == null) return "";
    String languageCode = Localizations
        .localeOf(context)
        .languageCode;
    var date = DateTime.parse(d);
    String dateTime = DateFormat(format, languageCode).format(date);
    return dateTime;
  }

  String _getMeDate(String? d) {
    if (d == null) return "";
    var date = DateTime.parse(d);
    var format = DateFormat.yMd(Platform.localeName);
    return format.format(date);
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 0.2,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 0.2,
        );
      },
      checkToShowHorizontalLine: (value) {
        return true;
      },
      checkToShowVerticalLine: (value) {
        return true;
      },
    );
  }

  String _getToolTip(int time) {
    if (_dropdownValue == 0) {
      return '${_getMeTime("0000-00-00 ${Duration(minutes: time).toHoursMinutes()}", "HH:mm")}\n';
    } else if (_dropdownValue == 1) {
      DateTime date = DateTime.parse("1970-00-00");
      DateTime d = Jiffy(date)
          .add(duration: Duration(days: time))
          .dateTime;
      return '${DateFormat.EEEE(_locale).format(d)}\n';
    } else if (_dropdownValue == 2) {
      List<String> dateParts = _date.toString().split("-");
      String tm = time < 10 ? "0$time" : time.toString();
      String dt = "${dateParts[0]}-${dateParts[1]}-$tm";
      return '${_getMeDate(dt)}\n';
    } else if (_dropdownValue == 3) {
      List<String> dateParts = _date.toString().split("-");
      String tm = time < 10 ? "0$time" : time.toString();
      String dt = "${dateParts[0]}-${dateParts[1]}-$tm";
      var date = DateTime.parse(dt);
      var format = DateFormat.yM(Platform.localeName);
      return '${format.format(date)}\n';
    } else {
      return '${Duration(days: time * 31).inDays.toString()} \n';
    }
  }


  @override
  Widget build(BuildContext context) {
    final List<int> showIndexes = [_values.length - 1];
    final lineBarData = [
      LineChartBarData(
        spots: _values,
        showingIndicators: showIndexes,
        color: const Color(0xFF257DC1),
        barWidth: 1,

        shadow: const Shadow(
            color: Color(0xFF257DC1),
            blurRadius: 5.0,
            offset: Offset(0.5, 1)),
        isStrokeCapRound: true,
        isCurved: false,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
              colors: _gradientColors,
              stops: const [0.0, 0.8, 1.0],
              begin: const Alignment(0.0, 0),
              end: const Alignment(0.0, 1)
          ),
        ),
      ),
    ];

    LineChartData _mainData() {
      return LineChartData(
        gridData: _gridData(),

        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(
          show: false,
          border: const Border(
              bottom: BorderSide(color: Colors.white10, width: 0.5),
              left: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        minX: _minX,
        maxX: _maxX,
        minY: _minY,
        maxY: _maxY,
        showingTooltipIndicators: showIndexes.map((index) {
          return ShowingTooltipIndicators([
            LineBarSpot(lineBarData[0], 0, _values[index]),
          ]);
        }).toList(),
        lineTouchData: LineTouchData(
            touchCallback:
                (FlTouchEvent? event, LineTouchResponse? touchResponse) {
              if (event is FlTapDownEvent ||
                  event is FlPointerHoverEvent ||
                  event is FlPanDownEvent) {
                setState(() {
                  _touch = true;
                });
              } else if (event is FlLongPressEnd || event is FlTapUpEvent) {
                setState(() {
                  _touch = false;
                });
              } else if (event is FlTapCancelEvent) {
                setState(() {
                  _touch = false;
                });
              } else if (event is FlPanStartEvent ||
                  event is FlLongPressMoveUpdate) {
                setState(() {
                  _touch = true;
                });
              } else if (event is FlPanEndEvent ||
                  event is FlPanCancelEvent) {
                setState(() {
                  _touch = false;
                });
              }
            },
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  FlLine(color: Colors.white54, strokeWidth: 0.8),
                  FlDotData(
                      show: true,
                      getDotPainter: (FlSpot spot, double radius,
                          LineChartBarData lc, int i) {
                        return FlDotCirclePainter(
                            color: const Color(0xFF312d53).withOpacity(0.5),
                            strokeColor: Colors.white54,
                            radius: 3.0);
                      }),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipRoundedRadius: 4,
                tooltipBgColor: Colors.black26,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    return LineTooltipItem(
                      _getToolTip(flSpot.x.toInt()),
                      Theme
                          .of(context)
                          .textTheme
                          .subtitle1!,
                      children: [
                        TextSpan(
                          text: "${_formatTooltip(flSpot.y)} ${widget.activeCoin!.cryptoId!}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ],
                    );
                  }).toList();
                }),
            enabled: _touch),
        lineBarsData: lineBarData,
      );
    }
    return Padding(
      padding:
      const EdgeInsets.only(right: 0.0, left: 0.0, top: 15, bottom: 0),
      child: _values.isEmpty
          ? Container(color: Colors.transparent, child: Center(child: Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Text(AppLocalizations.of(context)!.graph_no_data, style: Theme
            .of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Colors.white24),),
      )),)
          : LineChart(
        _mainData(),
        swapAnimationDuration: const Duration(milliseconds: 300),
        swapAnimationCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

final List<Color> _gradientColors = [
  const Color.fromRGBO(37, 125, 193, 0.1),
  const Color.fromRGBO(196, 196, 196, 0),
  const Color.fromRGBO(255, 255, 255, 0),
];
