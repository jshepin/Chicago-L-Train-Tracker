import 'dart:async';
import 'dart:ui';
import 'package:CTA_Tracker/data/alertsData.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

String lastStationId = "";
bool connected = true;

class Stop_view extends StatefulWidget {
  Stop stop;
  bool reload;
  Stop_view(this.stop, this.reload);
  @override
  Stop_viewState createState() => Stop_viewState();
}

var favorited = false;
SettingsData _settings = new SettingsData(false, false, false, false, false);

class Stop_viewState extends State<Stop_view> {
  Timer _timer;

  void getTopBar() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(isDark(context));
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 20), (Timer t) => update(t));
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  var count = 0;
  void update(Timer timer) {
    setState(() {});
  }

  Station station;
  bool showDesc = false;
  List<Station> stations;
  @override
  Widget build(BuildContext context) {
    getTopBar();
    return Scaffold(
      backgroundColor: getPrimary(context),
      body: SafeArea(
        child: SingleChildScrollView(
            child: FutureBuilder(
                future: getAlerts(widget.stop.id),
                builder: (context, alertSnapshot) {
                  if (alertSnapshot.hasData) {
                    var _alerts = alertSnapshot.data;
                    return FutureBuilder(
                      future: getSettings(),
                      builder: (context, settingsSnapshot) {
                        if (settingsSnapshot.hasData) {
                          _settings = settingsSnapshot.data;
                          return FutureBuilder(
                              future: getSavedStations(),
                              builder: (c, snap) {
                                if (snap.hasData) {
                                  favorited = snap.data.contains(widget.stop.id + "%BUS%");
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  tooltip: "Back",
                                                  iconSize: 60,
                                                  padding: EdgeInsets.all(0),
                                                  icon: Icon(
                                                    Icons.chevron_left,
                                                  ),
                                                  onPressed: () {
                                                    _timer.cancel();
                                                    if (widget.reload) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => Home(),
                                                          ));
                                                    } else {
                                                      _timer.cancel();
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 3),
                                                  child: Text('station.title'.tr(),
                                                      style: TextStyle(
                                                        fontSize: 35,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(right: 5),
                                                  child: IconButton(
                                                    tooltip: 'Favorite',
                                                    iconSize: 28,
                                                    icon: Icon(
                                                      favorited
                                                          ? Icons.favorite
                                                          : Icons.favorite_border,
                                                    ),
                                                    onPressed: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences.getInstance();

                                                      List<String> savedStations =
                                                          prefs.getStringList("savedStations") ??
                                                              [];
                                                      if (savedStations.contains(
                                                          widget.stop.id.toString() + "%BUS%")) {
                                                        print("unfavoriting");
                                                        setState(() {
                                                          favorited = false;
                                                        });
                                                        savedStations.remove(
                                                            widget.stop.id.toString() + "%BUS%");
                                                      } else {
                                                        var busCount = 0;
                                                        for (var s in savedStations) {
                                                          if (s.contains("%BUS%")) {
                                                            busCount++;
                                                          }
                                                        }
                                                        if (busCount < 9) {
                                                          setState(() {
                                                            favorited = true;
                                                          });
                                                          print("favoriting " +
                                                              widget.stop.id.toString());

                                                          savedStations.add(
                                                              widget.stop.id.toString() + "%BUS%");
                                                        } else {
                                                          print('exceeded');
                                                          _showMyDialog(context);
                                                        }
                                                      }
                                                      prefs.setStringList(
                                                          'savedStations', savedStations);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 5),
                                                  child: IconButton(
                                                      tooltip: "Refresh",
                                                      iconSize: 34,
                                                      icon: Icon(Icons.refresh),
                                                      onPressed: () async {
                                                        bool s = await checkConnection();
                                                        setState(() {
                                                          connected = s;
                                                        });
                                                      }),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, bottom: 3),
                                          child: Text(
                                            widget.stop.name,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 28),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "Stop #${widget.stop.id}",
                                                style: TextStyle(
                                                    fontSize: 21, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                if (_settings.showExtraInformation &&
                                                    widget.stop.isAda)
                                                  Icon(Icons.accessible_forward),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8, left: 7),
                                                  child: ConnectionIndicator(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        if (widget.stop.desc.length > 0) ...[
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  showDesc = !showDesc;
                                                });
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    child: Row(
                                                      children: [
                                                        showDesc
                                                            ? Icon(Icons.arrow_drop_down_rounded)
                                                            : Icon(Icons.arrow_right_rounded),
                                                        Text(
                                                          "Info",
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (showDesc)
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, bottom: 3),
                                                      child: Text(
                                                        widget.stop.name + widget.stop.desc,
                                                        overflow: TextOverflow.clip,
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            color: isDark(context)
                                                                ? Colors.grey[400]
                                                                : Colors.grey[7600]),
                                                      ),
                                                    ),
                                                ],
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(top: 1, bottom: 5),
                                            child: DividerLine(),
                                          ),
                                        ],
                                        FutureBuilder(
                                            future: getBusPredictions(widget.stop.id),
                                            builder: (c, data) {
                                              if (data.hasData) {
                                                return StopViewCard(data.data, widget.stop, false);
                                              } else {
                                                return Container();
                                              }
                                            }),
                                        if (_settings.showAlerts && (_alerts != null)) ...[
                                          for (var alert in _alerts) ...[
                                            Padding(
                                              padding: EdgeInsets.only(left: 11, bottom: 5, top: 9),
                                              child: Text(
                                                "There ${_alerts.length != 1 ? 'are' : 'is'} ${_alerts.length} alert${_alerts.length != 1 ? "s" : ''} for this stop",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            AlertCard(alert)
                                          ],
                                        ],
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              });
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                })),
      ),
    );
  }
}

Future<void> _showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Max number of stations added'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'There is a maximum number of 9 bus stations you can have, please consider removing another in order to add this. Thanks'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
