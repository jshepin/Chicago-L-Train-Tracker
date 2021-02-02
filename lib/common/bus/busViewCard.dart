import 'package:CTA_Tracker/exports.dart';
import 'package:flutter/material.dart';

class BusViewCard extends StatelessWidget {
  BusPrediction prediction;
  int selected;
  BusViewCard(this.selected, {this.prediction});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.only(top: 5, bottom: 3, right: 10, left: 10),
      padding: EdgeInsets.only(top: 3, bottom: 4, left: 7, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1,
              ),
              Text(
                "${prediction.des} ${selected == 0 ? 'Rt. #' : ''}${selected == 0 ? prediction.rt : ''}",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
              Container(height: 1),
              Text(
                "Bus #${prediction.vid}",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2, top: 1),
            child: Time(bPrediction: prediction),
          ),
        ],
      ),
    );
  }
}
