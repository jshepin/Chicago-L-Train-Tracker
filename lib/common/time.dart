import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

class Time extends StatelessWidget {
  Prediction prediction;
  BusPrediction bPrediction;
  bool vstack;
  bool isBus;
  bool smallCard;
  Time({Prediction tPrediction, BusPrediction bPrediction, vstack, smallCard}) {
    if (tPrediction != null) {
      this.isBus = false;
      this.prediction = tPrediction;
    }
    if (bPrediction != null) {
      this.isBus = true;
      this.prediction = new Prediction(
          bPrediction.prdtm,
          bPrediction.stpid,
          bPrediction.stpid,
          bPrediction.stpnm,
          bPrediction.des,
          bPrediction.vid,
          bPrediction.rt,
          bPrediction.des,
          "",
          "",
          "",
          bPrediction.prdtm,
          "0",
          "1",
          bPrediction.dly ? "1" : "0",
          "",
          "",
          "0.0",
          " 0.0",
          " 0");
      this.bPrediction = bPrediction;
    }
    this.vstack = vstack ?? false;
    this.smallCard = smallCard ?? true;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          vstack ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        Container(height: vstack ? 3 : 0.8),
        Row(children: [
          Text(
            "${(prediction.isApp == "1") ? 'Now' : formatTime(convertShortColor(prediction.arrT), prediction.prdt, vstack)}",
            style: TextStyle(
                fontSize: smallCard ? 22 : 26, fontWeight: FontWeight.w600),
          ),
          if ((prediction.isApp == "0" &&
                  formatTime(convertShortColor(prediction.arrT),
                          prediction.prdt, vstack) !=
                      "Late") &&
              formatTime(convertShortColor(prediction.arrT), prediction.prdt,
                      vstack) !=
                  "Now") ...[
            Container(width: 5),
            if (formatTime(prediction.arrT, "", vstack) != "Late" ||
                formatTime(
                      prediction.arrT,
                      "",
                      vstack,
                    ) !=
                    "Now")
              Padding(
                padding: const EdgeInsets.only(top: 0.5),
                child: Text(
                  'Min',
                  style: TextStyle(fontSize: smallCard ? 18 : 20),
                ),
              )
          ],
        ]),
        Container(
          height: smallCard ? 3 : (isBus ? 5 : 10),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 1),
          child: Text(
            "${(prediction.isDly == "1" ? tr('predictionRow.delayed') : tr('predictionRow.onTime'))}",
            style: TextStyle(
                color: isDark(context)
                    ? ((prediction.isDly == "1"
                        ? Colors.red[400]
                        : (isBus
                            ? Colors.grey[400]
                            : textColorFromLine(
                                convertShortColor(prediction.rt), context))))
                    : ((prediction.isDly == "1"
                        ? Colors.red
                        : (isBus
                            ? Colors.grey[600]
                            : textColorFromLine(
                                convertShortColor(prediction.rt), context)))),
                fontSize: vstack ? (smallCard ? 16 : 18) : 16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
