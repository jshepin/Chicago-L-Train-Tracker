import 'package:CTA_Tracker/exports.dart';
import 'package:flutter/material.dart';

class BusViewCard extends StatelessWidget {
  BusPrediction prediction;
  int selected;
  BusViewCard(this.selected, {this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 3, right: 10, left: 10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDark(context)
                  ? Color(0xff424242)
                  : Colors.grey[300].withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 2,
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: getPrimary(context)),
      padding: EdgeInsets.only(top: 3, bottom: 4, left: 7, right: 5),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
        ],
      ),
    );
  }
}
