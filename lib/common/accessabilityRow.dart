import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

class AccessiblilityRow extends StatelessWidget {
  Station station;
  bool showAll;
  bool isTrainRow;
  AccessiblilityRow(this.station, {this.showAll, this.isTrainRow});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSettings(),
        builder: (c, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: isTrainRow != null
                  ? EdgeInsets.only(right: 0)
                  : EdgeInsets.only(right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (station.isAirport != null && station.isAirport)
                    Container(
                      padding:
                          EdgeInsets.only(left: 7, top: 1, bottom: 1, right: 1),
                      child: Tooltip(
                        message: tr('icons.airport'),
                        child: Icon(
                          Icons.local_airport,
                          size: isTrainRow != null ? 20 : 25,
                        ),
                      ),
                    ),
                  if (station.ada &&
                      (snapshot.data.showExtraInformation || showAll != null))
                    FutureBuilder(
                      future: hasElevatorIssue(station.id),
                      builder: (c, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 5, top: 1, bottom: 1, right: 1),
                            child: Tooltip(
                              message: snapshot.data
                                  ? "Accessibility Related Issue"
                                  : tr('icons.ADA'),
                              child: Icon(
                                Icons.accessible_forward,
                                size: isTrainRow != null ? 20 : 25,
                                color: snapshot.data
                                    ? Colors.red
                                    : (isDark(context)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  if (station.parking &&
                      (snapshot.data.showExtraInformation || showAll != null))
                    Container(
                      padding:
                          EdgeInsets.only(left: 2, top: 1, bottom: 1, right: 1),
                      child: Tooltip(
                        message: tr('icons.parking'),
                        child: Icon(
                          Icons.local_parking,
                          size: isTrainRow != null ? 20 : 25,
                        ),
                      ),
                    )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
