import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class MapTrainCard extends StatelessWidget {
  Location selectedTrain;
  String selectedColor;
  MapTrainCard(this.selectedTrain, this.selectedColor);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          height: 59,
          decoration: BoxDecoration(
              color: getPrimary(context),
              border: Border.all(
                  width: 2, color: colorFromLine(selectedColor ?? "", context)),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Next Stop",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          "${selectedTrain.nextStaNm.length <= 18 ? selectedTrain.nextStaNm : (selectedTrain.nextStaNm.substring(0, 18) + '...')}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${selectedTrain.destNm} Bound",
                      style: TextStyle(fontSize: 19),
                    ),
                    Container(height: 2),
                    Text(
                      "#${selectedTrain.rn}",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Train {}
