import 'package:CTA_Tracker/common/accessabilityRow.dart';
import 'package:CTA_Tracker/data/colors.dart';
import 'package:CTA_Tracker/data/train/station_data.dart';
import 'package:CTA_Tracker/data/train/trainData.dart';
import 'package:CTA_Tracker/exports.dart';
import 'package:CTA_Tracker/pages/train/trainView/trainView.dart';
import 'package:flutter/material.dart';
import '../stations.dart';

class UpcomingStations extends StatelessWidget {
  Function callback;

  List<TrainRunPrediction> predictions;
  TrainView widget;
  UpcomingStations(this.predictions, this.widget, this.callback);
  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.all(7),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (TrainRunPrediction p in predictions) ...[
                    GestureDetector(
                      onTap: () {
                        this.callback(new MainInfo(p.staNm, p.staId, p.arrT, p.isApp, p.isDly));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(p.staNm,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: p.staId == widget.prediction.staId
                                                ? FontWeight.w500
                                                : FontWeight.w400)),
                                  ),
                                ),
                                Row(children: [
                                  Text(
                                    "${(p.isApp == "1") ? "Now" : formatTime(convertShortColor(p.arrT), p.prdt, false, preciseNow: true)}",
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                                  ),
                                  if ((p.isApp == "0" &&
                                          formatTime(convertShortColor(p.arrT), p.prdt, false,
                                                  preciseNow: true) !=
                                              "Late") &&
                                      formatTime(convertShortColor(p.arrT), p.prdt, false,
                                              preciseNow: true) !=
                                          "Now") ...[
                                    Container(width: 4),
                                    if (formatTime(p.arrT, "", false, preciseNow: true) != "Late" ||
                                        formatTime(p.arrT, "", false, preciseNow: true) != "Now")
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0.5),
                                        child: Text(
                                          "min",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                  ],
                                ]),
                              ],
                            ),
                            Container(
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (String line in getStationFromID(p.staId).lines) ...[
                                        Container(
                                          margin: EdgeInsets.only(right: 4),
                                          child: Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: colorFromLine(line, context),
                                            ),
                                          ),
                                        )
                                      ],
                                    ],
                                  ),
                                  AccessiblilityRow(
                                    getStationFromID(p.staId),
                                    isTrainRow: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (predictions.indexOf(p) != predictions.length - 1)
                      Container(height: 8, child: Divider()),
                  ]
                ],
              ),
            ),
          )),
    );
  }
}
