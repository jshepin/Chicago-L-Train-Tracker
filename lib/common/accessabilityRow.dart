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
    // return Text(station.to);
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
                  station.isAirport != null && station.isAirport
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0, left: 5),
                          child: Container(
                            padding: EdgeInsets.all(1),
                            child: Tooltip(
                              message: tr('icons.airport'),
                              child: Icon(
                                Icons.local_airport,
                                size: isTrainRow != null ? 20 : 25,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  station.ada &&
                          (snapshot.data.showExtraInformation ||
                              showAll != null)
                      ? FutureBuilder(
                          future: hasElevatorIssue(station.id),
                          builder: (c, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 0, left: 5),
                                child: Container(
                                  padding: EdgeInsets.all(1),
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
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      : Container(),
                  station.parking &&
                          (snapshot.data.showExtraInformation ||
                              showAll != null)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0, left: 2),
                          child: Container(
                            padding: EdgeInsets.all(1),
                            child: Tooltip(
                              message: tr('icons.parking'),
                              child: Icon(
                                Icons.local_parking,
                                size: isTrainRow != null ? 20 : 25,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
