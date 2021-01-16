import 'package:CTA_Tracker/data/classes.dart';
import 'package:CTA_Tracker/data/bus/routesData.dart';
import 'package:CTA_Tracker/data/colors.dart';
import 'package:flutter/material.dart';

class CCircle extends StatelessWidget {
  Station station;
  StopPreview stop;
  bool isBus;
  bool isAlert;
  CCircle({Station station, StopPreview stop, this.isAlert}) {
    if (station != null) {
      this.isBus = false;
      this.station = station;
    } else if (stop != null) {
      this.isBus = true;
      this.stop = stop;
    }
  }
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 3),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        border: isBus
            ? Border.all(color: Colors.transparent, width: 0)
            : (station.lines.length > 1
                ? Border.all(color: Colors.black, width: 3)
                : (station.name == "Garfield" && station.lines.contains("Green")
                    ? Border.all(color: Colors.black, width: 4)
                    : Border.all(color: Colors.transparent))),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: isAlert != null && isAlert
          ? Tooltip(
              message: "Station Issues",
              child: isDark(context)
                  ? Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
            )
          : Container(),
    );
  }
}
