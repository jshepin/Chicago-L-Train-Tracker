import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

class StationViewCard extends StatelessWidget {
  List<Prediction> predictions;
  StationViewCard(this.predictions);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (Prediction prediction in predictions) ...[
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainView(prediction, false, false),
                    ));
              },
              child: AppCard(
                margin: EdgeInsets.only(top: 5, bottom: 3, right: 10, left: 10),
                padding: EdgeInsets.only(top: 3, bottom: 4, left: 7, right: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${convertShortColor(prediction.rt)}",
                          style: TextStyle(
                              color: textColorFromLine(convertShortColor(prediction.rt), context),
                              fontSize: 23,
                              fontWeight: FontWeight.w600),
                        ),
                        prediction.destNm.toLowerCase() != "see train"
                            ? Text(
                                "${prediction.destNm} ${'general.bound'.tr()}",
                                style: TextStyle(fontSize: 19),
                              )
                            : Text(
                                "Unknown",
                                style: TextStyle(fontSize: 19),
                              )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2, top: 1),
                      child: Time(tPrediction: prediction),
                    ),
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
