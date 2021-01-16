import 'dart:async';
import 'dart:ui';
import 'package:CTA_Tracker/common/connectionIndicator.dart';
import 'package:CTA_Tracker/common/train/predictionRow.dart';
import 'package:CTA_Tracker/data/classes.dart';
import 'package:CTA_Tracker/data/colors.dart';
import 'package:CTA_Tracker/data/train/runData.dart';
import 'package:CTA_Tracker/data/train/station_data.dart';
import 'package:CTA_Tracker/data/train/trainData.dart';
import 'package:CTA_Tracker/pages/train/trainView/upcomingStations.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../home.dart';
import '../station_view.dart';
import '../stations.dart';

DateTime lastFetch = DateTime.now();

class TrainView extends StatefulWidget {
  Prediction prediction;
  bool isBus;
  bool reload;
  TrainView(this.prediction, this.isBus, this.reload);
  @override
  _TrainViewState createState() => _TrainViewState();
}

class TrainRunPrediction {
  String staId;
  String stpId;
  String staNm;
  String stpDe;
  String rn;
  String rt;
  String destSt;
  String destNm;
  String trDr;
  String prdt;
  String arrT;
  String isApp;
  String isSch;
  String isDly;
  String isFlt;
  TrainRunPrediction(
      this.staId,
      this.stpId,
      this.staNm,
      this.stpDe,
      this.rn,
      this.rt,
      this.destSt,
      this.destNm,
      this.trDr,
      this.prdt,
      this.arrT,
      this.isApp,
      this.isSch,
      this.isDly,
      this.isFlt);
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

var endOfLine = false;
bool changed = false;
String mainTime = "";
MainInfo mainInfo = new MainInfo("", "", "", "", "");

class MainInfo {
  String arrT;
  String isApp;
  String isDly;
  String name;
  String staId;
  MainInfo(this.name, this.staId, this.arrT, this.isApp, this.isDly);
}

class _TrainViewState extends State<TrainView> {
  _TrainViewState();
  Prediction updatedPrediction;
  String statusTitle = "";
  Prediction cachedUpdtedPrediction;
  Timer _timer;
  Color color = Colors.white;
  List<TrainRunPrediction> predictions;
  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 15), (Timer t) => update(t));
    super.initState();

    getData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void update(Timer timer) {
    if (!endOfLine) {
      setState(() {});
    } else {
      print("NOT FETCHING DATA");
    }
  }

  void getData() {
    // print("GETTING DATA");
    getRunData(widget.prediction.rn).then((s) {
      if (s != null && s.length > 0) {
        var x = s[0];
        setState(() {
          predictions = s;
        });
        if (!predictions
            .map((e) => e.staId)
            .contains(widget.prediction.staId)) {
          setState(() {
            statusTitle = "Train left Station";
          });
        } else {
          setState(() {
            statusTitle = "Awaiting arrival";
          });
        }
      }
    });
  }

  void setNewPrediction(Prediction p) {
    setState(() {
      updatedPrediction = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (updatedPrediction == null) {
      updatedPrediction = widget.prediction;
    }
    var dif = (DateTime.now()).difference(lastFetch);

    var secs = (dif.inSeconds);

    if (secs > 25) {
      getData();

      lastFetch = DateTime.now();
    } else {}
    // print(predictions.map((e) => e.staNm));

    if (predictions != null &&
        predictions.length > 0 &&
        predictions[0].staId != updatedPrediction.staId &&
        !predictions.map((e) => e.staId).contains(widget.prediction.staId)) {
      print("SETTING NEW PREDICTION");
      var s = predictions[0];
      setState(() {
        updatedPrediction = new Prediction(
            s.trDr,
            s.staId,
            s.stpId,
            s.staNm,
            s.stpDe,
            s.rn,
            s.rt,
            s.destSt,
            s.destNm,
            s.trDr,
            s.prdt,
            s.arrT,
            s.isApp,
            s.isSch,
            s.isDly,
            s.isFlt,
            "",
            "",
            "",
            "");
      });
    }

    color = textColorFromLine(convertShortColor(widget.prediction.rt), context);
    if (!changed) {
      print("eee");

      if (predictions != null && predictions.length > 0) {
        print("qqq");
        if (!predictions.map((e) => e.staId).contains(mainInfo.staId)) {
          print("saf");

          var p = predictions[0];
          mainInfo = new MainInfo(p.staNm, p.staId, p.arrT, p.isApp, p.isDly);
          setState(() {
            changed = false;
          });
        } else {
          print("ret");
          var found = false;

          for (var p in predictions) {
            if (!found && p.staId == widget.prediction.staId) {
              mainInfo =
                  new MainInfo(p.staNm, p.staId, p.arrT, p.isApp, p.isDly);
              mainTime = p.arrT;
              found = true;
            }
          }
        }
      } else {
        print("yyy");

        mainInfo = new MainInfo(
            updatedPrediction.staNm,
            updatedPrediction.staId,
            updatedPrediction.arrT,
            updatedPrediction.isApp,
            updatedPrediction.isDly);
        // mainTime = updatedPrediction.arrT;
      }
    } else {
      print("AA");
      if (predictions != null && predictions.length > 0) {
        if (predictions.map((e) => e.staId).contains(mainInfo.staId)) {
          print("ccc");

          for (var p in predictions) {
            if (p.staId == mainInfo.staId) {
              mainInfo =
                  new MainInfo(p.staNm, p.staId, p.arrT, p.isApp, p.isDly);
            }
          }
        } else {
          print("bbb");

          var p = predictions[0];
          mainInfo = new MainInfo(p.staNm, p.staId, p.arrT, p.isApp, p.isDly);
          setState(() {
            changed = false;
          });
        }
      }
    }

    if (predictions != null && predictions.length > 0) {
      var lastStopDiff =
          (getTimeFromString(predictions.last.arrT).difference(DateTime.now()));

      var lastStopDiffSec = (lastStopDiff.inSeconds);
      print(lastStopDiffSec);
      if (lastStopDiffSec < 25) {
        endOfLine = true;
      } else {
        endOfLine = false;
      }
    }

    return Scaffold(
      backgroundColor: getPrimary(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      tooltip: "Back",
                      iconSize: 60,
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.chevron_left,
                      ),
                      onPressed: () {
                        if (widget.reload) {
                          _timer.cancel();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ));
                        } else {
                          _timer.cancel();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Station_view(
                                      getStationFromID(widget.prediction.staId),
                                      getStations("Red"),
                                      getLineFromColor("Red"),
                                      Colors.purple,
                                      false)));
                        }
                      }),
                  Container(
                    padding: EdgeInsets.only(right: 12),
                    child: ConnectionIndicator(),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                color:
                    isDark(context) ? getSecondary(context) : Colors.grey[100],
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Container(
                      height: 270,
                      width: 270,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: isDark(context)
                                  ? Colors.transparent
                                  : Colors.grey[300].withOpacity(0.9),
                              spreadRadius: 3,
                              blurRadius: 10,
                            )
                          ],
                          color: getPrimary(context),
                          borderRadius: BorderRadius.all(Radius.circular(1000)),
                          border: Border.all(color: color, width: 2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark(context)
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              widget.isBus ? Icons.directions_bus : Icons.train,
                              size: 35,
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "${convertShortColorDisplay(updatedPrediction.rt)} ${convertShortColorDisplay(updatedPrediction.rt).contains('Line') ? '' : 'Line'}",
                              style: TextStyle(
                                  color: color,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6, bottom: 5),
                            child: Text(
                              "${updatedPrediction.destNm} Bound",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            mainInfo.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "${(mainInfo.isApp == "1") ? 'status.now'.tr() : formatTime(convertShortColor(mainInfo.arrT), updatedPrediction.prdt, false, preciseNow: true)}",
                                  style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.w600)),
                              if ((mainInfo.isApp == "0" &&
                                      formatTime(
                                              convertShortColor(mainInfo.arrT),
                                              updatedPrediction.prdt,
                                              false,
                                              preciseNow: true) !=
                                          "Late") &&
                                  formatTime(convertShortColor(mainInfo.arrT),
                                          updatedPrediction.prdt, false,
                                          preciseNow: true) !=
                                      "Now") ...[
                                Container(width: 5),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "min",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                )
                              ]
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 1),
                            child: Text(
                              "${(updatedPrediction.isDly == "1" ? tr('predictionRow.delayed') : tr('predictionRow.onTime'))}",
                              style: TextStyle(
                                  color: isDark(context)
                                      ? ((updatedPrediction.isDly == "1"
                                          ? Colors.red
                                          : color))
                                      : ((updatedPrediction.isDly == "1"
                                          ? Colors.red
                                          : color)),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (endOfLine)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "End of the line",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              if (!endOfLine)
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5, left: 6),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark(context)
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              widget.isBus ? Icons.directions_bus : Icons.train,
                              size: 25,
                            ),
                          ),
                          Text(
                            "#${updatedPrediction.rn}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      if (!endOfLine)
                        if (predictions != null && predictions.length > 0) ...[
                          UpcomingStations(predictions, widget, (var data) {
                            setState(() {
                              changed = true;
                              mainInfo = data;
                            });
                          })
                        ]

                      // })
                    ],
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}
