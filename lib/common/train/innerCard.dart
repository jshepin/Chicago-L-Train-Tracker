import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class InnerCard extends StatelessWidget {
  var predictions;
  bool smallCard;
  bool isBus;
  InnerCard(this.smallCard, {prediction, busPrediction}) {
    if (prediction != null) {
      this.predictions = prediction;
      this.isBus = false;
    } else if (busPrediction != null) {
      this.predictions = busPrediction;
      this.isBus = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4),
      child: Row(
        children: [
          for (var prediction in predictions) ...[
            GestureDetector(
              onTap: () {
                if (!isBus) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainView(prediction, isBus, true),
                      ));
                }
              },
              child: Container(
                constraints: BoxConstraints(minWidth: smallCard ? 120 : 120),
                margin: isDark(context)
                    ? EdgeInsets.only(top: 5, right: 8, bottom: 3, left: 3)
                    : EdgeInsets.only(top: 5, right: 6, bottom: 3, left: 3),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: isDark(context) ? Color(0xff424242) : Colors.grey[200],
                      spreadRadius: 2,
                      blurRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  color: getPrimary(context),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "${isBus ? 'Rt. #' : ''}${isBus ? prediction.rt : convertShortColorDisplay(prediction.rt)}",
                        style: TextStyle(
                            color: isBus
                                ? (isDark(context) ? Colors.grey[400] : Colors.grey[600])
                                : textColorFromLine(convertShortColor(prediction.rt), context),
                            fontSize: smallCard ? 20 : 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: smallCard
                          ? EdgeInsets.only(top: 2, bottom: 1)
                          : EdgeInsets.only(top: 6, bottom: 5),
                      child: Text(
                        "${isBus ? (prediction != null && prediction.des != null ? prediction.des : '') : prediction.destNm}",
                        style: TextStyle(
                          fontSize: smallCard ? 18 : 20,
                        ),
                      ),
                    ),
                    if (isBus)
                      Text(
                        "Bus #${prediction.vid}",
                        style: TextStyle(fontSize: smallCard ? 20 : 19),
                      ),
                    Container(
                      height: smallCard ? 0 : 4,
                    ),
                    isBus
                        ? Time(bPrediction: prediction, vstack: true, smallCard: smallCard)
                        : Time(tPrediction: prediction, vstack: true, smallCard: smallCard)
                  ],
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
