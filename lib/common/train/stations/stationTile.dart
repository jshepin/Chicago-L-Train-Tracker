import 'package:CTA_Tracker/pages/train/stations.dart';
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
                Row(
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
                    AccessiblilityRow(
                      station,
                      isTrainRow: true,
                    ),
                    if (alerts != null &&
                        snapshot.data.showAlerts &&
                        alerts
                            .map((e) => (e.impactedServices
                                .map((f) => f.id)
                                .contains(station.id)))
                            .contains(true)) ...[
                      Tooltip(
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
                    ]
                  ],
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
