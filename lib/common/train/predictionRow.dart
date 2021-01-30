import 'package:CTA_Tracker/pages/bus/stopView.dart';
import 'package:CTA_Tracker/pages/train/station_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CTA_Tracker/exports.dart';

class PredictionRow extends StatefulWidget {
  Station station;
  String distance;
  List<Station> stations;
  bool isConnected;
  SettingsData settings;
  Function callback;
  Stop stop;
  bool isBus;
  PredictionRow(this.settings,
      {stop,
      station,
      stations,
      this.distance,
      this.isConnected,
      this.callback}) {
    if (station != null && stations != null) {
      this.station = station;
      this.stations = stations;
      this.isBus = false;
    } else if (stop != null) {
      this.stop = stop;
      this.isBus = true;
    }
  }
  @override
  _PredictionRowState createState() => _PredictionRowState();
}

Future<List<int>> getStationSettings(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> data = prefs.getStringList("station$id") ?? ["0", "0", "0"];
  var intData = data.map((String e) => int.parse(e));
  return intData.toList();
}

class _PredictionRowState extends State<PredictionRow> {
  Line selectedLine;
  int selectedDestinationIndex;

  int selectedStyle = 0;
  bool allSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, bottom: 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark(context)
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Icon(widget.isBus
                                ? Icons.directions_bus
                                : Icons.train),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 50),
                                      child: widget.isBus
                                          ? Stop_view(widget.stop, true)
                                          : Station_view(
                                              widget.station,
                                              widget.stations,
                                              getLineFromColor("Red"),
                                              widget.station.lines.length > 1
                                                  ? Colors.black
                                                  : colorFromLine(
                                                      widget.station.lines[0],
                                                      context),
                                              true)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Container(
                                child: Text(
                                  "${widget.isBus ? widget.stop.name : widget.station.name} ",
                                  style: TextStyle(
                                    fontSize: widget.isBus ? 25 : 27,
                                  ),
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ),
                          if (widget.distance != null &&
                              double.parse(widget.distance) > 0.03) ...[
                            Text(
                              "${widget.distance == null ? "" : '-'} ${widget.distance == null ? "" : widget.distance}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              " ${widget.distance == null ? "" : 'home.distanceUnit'.tr()}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    if (widget.settings.showAlerts)
                      FutureBuilder(
                          future: getAlerts(widget.isBus
                              ? widget.stop.id
                              : widget.station.id),
                          builder: (c, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data.length > 0
                                  ? Tooltip(
                                      message: "Station Issues",
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
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
                                  : Container();
                            } else {
                              return Container();
                            }
                          })
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Tooltip(
                  message:
                      "Edit ${widget.isBus ? widget.stop.name : widget.station.name}",
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 13, left: 3, top: 12, bottom: 2),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => StatefulBuilder(
                                    builder: (context, setState) {
                                      return FutureBuilder(
                                        future: getStationSettings(widget.isBus
                                            ? widget.stop.id + "%BUS%"
                                            : widget.station.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            selectedStyle = snapshot.data[0];
                                            allSelected =
                                                (snapshot.data[1] == 0);

                                            if (selectedDestinationIndex ==
                                                null) {
                                              selectedDestinationIndex =
                                                  snapshot.data[2];
                                            }
                                            if (!widget.isBus) {
                                              if (!allSelected) {
                                                selectedLine = getLineFromColor(
                                                    widget.station.lines[
                                                        snapshot.data[1] - 1]);
                                              } else {
                                                if (widget
                                                        .station.lines.length ==
                                                    1) {
                                                  selectedLine =
                                                      getLineFromColor(widget
                                                          .station.lines[0]);
                                                } else {
                                                  selectedLine = new Line(
                                                      "",
                                                      "",
                                                      "D11A2C",
                                                      "D11A2C",
                                                      "D11A2C");
                                                }
                                              }
                                            }

                                            return EditDialog(widget, snapshot,
                                                widget.station, widget.isBus);
                                          } else {
                                            return Container();
                                          }
                                        },
                                      );
                                    },
                                  ));
                        },
                        child: Icon(
                          Icons.more_horiz,
                          color: isDark(context) ? Colors.white : Colors.black,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
        widget.isBus
            ? Predictions(Colors.black, true, false, widget.settings,
                stop: widget.stop)
            : Predictions(
                widget.station.lines.length > 1
                    ? Colors.black
                    : colorFromLine(widget.station.lines[0], context),
                true,
                false,
                widget.settings,
                station: widget.station),
      ]),
    );
  }
}

Future<void> setData(bool isBus, id, one, two, three) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<int> data = [];
  data.add(one);
  data.add(two);
  data.add(three);
  prefs.setStringList("station${isBus ? (id + '%BUS%') : id}",
      (data.map((e) => e.toString()).toList()));
}

Line getLineFromColor(String color) {
  List<Line> lines = getLines();
  for (var line in lines) {
    if (line.name == color) {
      return line;
    }
  }
  return lines[0];
}

class DirectionPrediction {
  String direction;
  List<Prediction> predictions;
  DirectionPrediction(this.direction, this.predictions);
}

class BusDirectionPrediction {
  String direction;
  List<BusPrediction> busPredictions;
  BusDirectionPrediction(this.direction, this.busPredictions);
}

bool shouldRemoveLines(id) {
  List<String> ids = ["40560", "40070", "41660", "40370"];
  return ids.contains(id);
}
