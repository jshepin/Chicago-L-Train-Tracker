import 'package:CTA_Tracker/pages/train/stations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class StationTitle extends StatelessWidget {
  List<Station> stations;
  Station station;
  Line line;
  bool green = false;
  StationTitle(this.stations, this.station, this.line, {this.green});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSettings(),
      builder: (c, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: line.name == "Green"
                            ? EdgeInsets.only(top: 1.2)
                            : EdgeInsets.only(top: 1.08),
                        child: Text(
                          "${station.name}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      station.isAirport != null && station.isAirport
                          ? Padding(
                              padding: const EdgeInsets.only(top: 0, left: 5),
                              child: Container(
                                padding: EdgeInsets.all(1),
                                child: Tooltip(
                                  message: tr('icons.airport'),
                                  child: Icon(
                                    Icons.local_airport,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      station.ada && snapshot.data.showExtraInformation
                          ? Padding(
                              padding: const EdgeInsets.only(top: 0, left: 5),
                              child: FutureBuilder(
                                future: hasElevatorIssue(station.id),
                                builder: (c, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      padding: EdgeInsets.all(1),
                                      child: Tooltip(
                                        message: snapshot.data
                                            ? "Accessibility Related Issue"
                                            : tr('icons.ADA'),
                                        child: Icon(Icons.accessible_forward,
                                            size: 20,
                                            color: snapshot.data
                                                ? Colors.red
                                                : Colors.grey),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            )
                          : Container(),
                      station.parking && snapshot.data.showExtraInformation
                          ? Padding(
                              padding: const EdgeInsets.only(top: 0, left: 2),
                              child: Container(
                                padding: EdgeInsets.all(1),
                                child: Tooltip(
                                  message: tr('icons.parking'),
                                  child: Icon(
                                    Icons.local_parking,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      if (alerts != null && snapshot.data.showAlerts) ...[
                        alerts
                                .map((e) => (e.impactedServices
                                    .map((f) => f.id)
                                    .contains(station.id)))
                                .contains(true)
                            ? Tooltip(
                                message: "Station Issues",
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: isDark(context)
                                      ? Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                ),
                              )
                            : Container()
                      ]
                    ],
                  ),
                ),
                Row(
                  children: [
                    for (var color in station.lines) ...[
                      if ((line.name != color) ||
                          station.name == "Garfield" &&
                              line.name == "Green") ...[
                        Container(
                          margin: EdgeInsets.only(right: 4, top: 2),
                          child: Container(
                            height: 17,
                            width: 17,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: showDashed(color, station)
                                        ? colorFromLine("Purple", context)
                                        : Colors.transparent,
                                    width: 3),
                                color: showDashed(color, station)
                                    ? getPrimary(context)
                                    : colorFromLine(color, context),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                )),
                          ),
                        )
                      ]
                    ],
                  ],
                ),
                green
                    ? Container(
                        height: 10,
                      )
                    : Container(
                        height:
                            (stations.indexOf(station) == (stations.length - 1)
                                ? 0
                                : calculateDistance(station, stations) * 20),
                      ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
