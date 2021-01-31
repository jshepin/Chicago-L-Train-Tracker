import 'package:CTA_Tracker/common/train/stationViewCard.dart';
import 'package:CTA_Tracker/pages/train/stations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:CTA_Tracker/exports.dart';

List<DirectionPrediction> getDestinationPredictions(
    List<Prediction> predictions, Station station) {
  List<DirectionPrediction> directionPredictions = [];
  if (station.lines.length > 1) {
    for (var l in station.lines) {
      List<Prediction> subPredictions = [];
      for (var p in predictions) {
        if (convertShortColorDisplay(p.rt) == l) {
          subPredictions.add(p);
        }
      }
      if (subPredictions.length > 0) {
        directionPredictions.add(new DirectionPrediction(l, subPredictions));
      }
    }
  } else {
    return [new DirectionPrediction("", predictions)];
  }
  directionPredictions.insert(0, new DirectionPrediction("", predictions));
  return directionPredictions;
}

class Predictions extends StatefulWidget {
  Station station;
  Stop stop;
  Color color;
  bool vstack;
  bool showMap;
  bool isBus;
  bool tabletShrink;

  SettingsData settings;
  Predictions(this.color, this.vstack, this.showMap, this.settings,
      {station, stop, this.tabletShrink}) {
    if (station != null) {
      this.station = station;
      this.isBus = false;
    } else if (stop != null) {
      this.stop = stop;
      this.isBus = true;
    }
  }
  @override
  _PredictionsState createState() => _PredictionsState();
}

class _PredictionsState extends State<Predictions> {
  int selected = 0;
  bool changed = false;
  bool setPreference = false;
  SettingsData cachedSettings;
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.isBus
          ? getBusPredictions(widget.stop.id)
          : getPredictions(widget.station.id),
      builder: (c, data) {
        if (data.hasData) {
          List<DirectionPrediction> dPredictions = [];
          if (!widget.isBus)
            dPredictions = getDestinationPredictions(data.data, widget.station);
          return FutureBuilder(
              future: getStationSettings(
                  widget.isBus ? widget.stop.id + "%BUS%" : widget.station.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!changed &&
                      (!setPreference || widget.settings != cachedSettings)) {
                    if (snapshot.data[1] == 0) {
                      selected = 0;
                    } else {
                      for (int x = 0; x < dPredictions.length; x++) {
                        if (convertShortColor(
                                dPredictions[x].predictions[0].rt) ==
                            widget.station.lines[snapshot.data[1] - 1]) {
                          selected = x;
                        }
                      }
                    }
                    cachedSettings = widget.settings;
                    setPreference = true;
                  }
                  return Container(
                      constraints:
                          widget.tabletShrink != null && widget.tabletShrink
                              ? BoxConstraints(maxWidth: 500)
                              : BoxConstraints(),
                      child: data.data.length > 0
                          ? (widget.vstack
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (dPredictions.length > 2)
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int x = 0;
                                                  x < dPredictions.length;
                                                  x++) ...[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 7, right: 4),
                                                  height:
                                                      selected == x ? 13 : 9,
                                                  width: selected == x ? 13 : 9,
                                                  decoration: BoxDecoration(
                                                      color: x == 0
                                                          ? (isDark(context)
                                                                  ? Colors.white
                                                                  : Colors.grey[
                                                                      350])
                                                              .withOpacity(
                                                                  selected == x
                                                                      ? 0.8
                                                                      : 0.7)
                                                          : ((colorFromLine(convertShortColor(dPredictions[x].predictions[0].rt), context)))
                                                              .withOpacity(
                                                                  selected == x
                                                                      ? 1.0
                                                                      : 0.8),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                )
                                              ]
                                            ],
                                          ),
                                        widget.isBus
                                            ? Row(
                                                children: [
                                                  InnerCard(
                                                      snapshot.data[0] == 0,
                                                      busPrediction: data.data),
                                                ],
                                              )
                                            : Container(
                                                height: snapshot.data[0] == 0
                                                    ? 116
                                                    : 145, //smallcard ?
                                                child: dPredictions.length > 2
                                                    ? Container(
                                                        constraints: BoxConstraints(
                                                            minWidth:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width),
                                                        width: dPredictions[
                                                                        selected]
                                                                    .predictions
                                                                    .length *
                                                                (145.0) +
                                                            50,
                                                        child: new Swiper(
                                                          index: selected,
                                                          key: ValueKey(
                                                              selected),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return InnerCard(
                                                              snapshot.data[
                                                                      0] ==
                                                                  0,
                                                              prediction:
                                                                  dPredictions[
                                                                          index]
                                                                      .predictions,
                                                            );
                                                          },
                                                          onIndexChanged: (i) {
                                                            setState(() {
                                                              changed = true;
                                                              selected = i;
                                                            });
                                                          },
                                                          itemCount:
                                                              dPredictions
                                                                  .length,
                                                        ),
                                                      )
                                                    : InnerCard(
                                                        snapshot.data[0] == 0,
                                                        prediction: data.data,
                                                      ),
                                              )
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      height: (dPredictions.length > 2
                                          ? 200
                                          : (widget.settings.showMap
                                              ? 200
                                              : 250)),
                                      child: dPredictions.length > 2
                                          ? Container(
                                              child: new Swiper(
                                                key:
                                                    ValueKey(widget.station.id),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return StationViewCard(
                                                      dPredictions[index]
                                                          .predictions);
                                                },
                                                onIndexChanged: (i) {
                                                  setState(() {
                                                    selected = i;
                                                  });
                                                },
                                                itemCount: dPredictions.length,
                                              ),
                                            )
                                          : StationViewCard(data.data),
                                    ),
                                    if (dPredictions.length > 2)
                                      HDots(
                                        selected,
                                        dPredictions: dPredictions,
                                      )
                                  ],
                                ))
                          : Center(
                              child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                  ),
                                  Text(
                                    'No Data',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            )));
                } else {
                  return Container();
                }
              });
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            child: Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            )),
          );
        }
      },
    );
  }
}

class HDots extends StatelessWidget {
  List<DirectionPrediction> dPredictions;
  List<BusDirectionPrediction> busDPredictions;
  bool isBus;
  int selected;
  HDots(this.selected, {dPredictions, busDPredictions}) {
    if (dPredictions != null) {
      this.isBus = false;
      this.dPredictions = dPredictions;
    } else if (busDPredictions != null) {
      this.isBus = true;
      this.busDPredictions = busDPredictions;
    }
  }
  double getHeight(x) {
    return selected == x ? 13 : 9;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int x = 0;
            x < (isBus ? busDPredictions.length : dPredictions.length);
            x++) ...[
          Container(
            margin: EdgeInsets.only(top: 7, right: 4), //
            height: getHeight(x), //
            width: getHeight(x), //
            decoration: BoxDecoration(
              color: x == 0
                  ? (isBus
                      ? Colors.grey[700].withOpacity(selected == x ? 0.9 : 0.4)
                      : (isDark(context) ? Colors.white : Colors.grey[350])
                          .withOpacity(selected == x ? 0.8 : 0.7))
                  : (isBus
                      ? Colors.grey[700].withOpacity(selected == x ? 0.9 : 0.4)
                      : ((colorFromLine(
                              convertShortColor(
                                  dPredictions[x].predictions[0].rt),
                              context)))
                          .withOpacity(selected == x ? 1.0 : 0.8)),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          )
        ]
      ],
    );
  }
}
