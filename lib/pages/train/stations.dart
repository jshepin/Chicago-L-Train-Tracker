import 'package:CTA_Tracker/common/train/stations/circle.dart';
import 'package:CTA_Tracker/pages/alerts/serviceAlerts.dart'; //
import 'package:CTA_Tracker/pages/serviceInfo/serviceInfo.dart';
import 'package:CTA_Tracker/pages/train/station_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

String cachedName = "";
List<String> getPurpleExpressIds() {
  return [
    "40540",
    "41320",
    "41210",
    "40530",
    "41220",
    "40660",
    "40800",
    "40710",
    "40460",
    "40380",
    "40260",
    "41700",
    "40680",
    "40850",
    "40160",
    "40040",
    "40730"
  ];
}

Future<bool> hasElevatorIssue(String name) async {
  var data = await getAlerts(name);
  for (var alert in data) {
    if (alert.headline.toLowerCase().contains("elevator")) {
      return true;
    }
  }

  return false;
}

class Stations extends StatefulWidget {
  @override
  Line line;
  Stations(this.line);
  _StationsState createState() => _StationsState(line);
}

List<Alert> alerts;
SettingsData stationSettings;
List<Station> cachedGreenLine = [];
List<Station> cachedPurpleExpress = [];

List<Station> getPurpleExpress() {
  List<Station> stations = getStationData();
  List<Station> purpleExpress = [];
  List<String> ids = getPurpleExpressIds();
  if (cachedPurpleExpress.length > 0) {
    return cachedPurpleExpress;
  }
  for (int y = 0; y < ids.length; y++) {
    for (int x = 0; x < stations.length; x++) {
      if (ids[y] == stations[x].id) {
        purpleExpress.add(stations[x]);
      }
    }
  }

  cachedPurpleExpress = purpleExpress;
  return cachedPurpleExpress;
}

List<Station> getGreenLineTrack() {
  List<String> names = ["Garfield", "King Drive", "Cottage Grove"];
  List<Station> stations = getStationData();
  List<Station> green = [];
  if (cachedGreenLine.length > 0) {
    return cachedGreenLine;
  }
  for (int y = 0; y < names.length; y++) {
    for (int x = 0; x < stations.length; x++) {
      if (names[y] == stations[x].name && stations[x].lines.contains("Green")) {
        green.add(stations[x]);
      }
    }
  }

  cachedGreenLine = green;
  return green;
}

Color colorFromLine(String name, context) {
  List<Line> lines = getLines();
  for (int x = 0; x < lines.length; x++) {
    if (lines[x].name == name) {
      return isDark(context) ? lines[x].darkColor : lines[x].color;
    }
  }
}

Color textColorFromLine(String name, context) {
  List<Line> lines = getLines();
  for (int x = 0; x < lines.length; x++) {
    if (lines[x].name == name) {
      return isDark(context) ? lines[x].darkText : lines[x].color;
    }
  }
}

List<Station> getStations(String name) {
  List<Station> stations = getStationData();
  List<Station> lineStations = [];

  for (var i = 0; i < stations.length; i++) {
    if (stations[i].lines.contains(name)) {
      lineStations.add(stations[i]);
    }
  }
  List<String> sortedCodes = getLineOrders(name);
  List<Station> sortedStations = [];
  for (var x = 0; x < sortedCodes.length; x++) {
    for (var y = 0; y < lineStations.length; y++) {
      if (lineStations[y].id == sortedCodes[x]) {
        sortedStations.add(lineStations[y]);
      }
    }
  }
  return sortedStations;
}

class _StationsState extends State<Stations> {
  List<Station> stations = [];
  Line line;
  _StationsState(this.line);

  void getTopBar() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(isDark(context));
  }

  void fetchAlerts(String name) async {
    if (alerts == null || cachedName != line.name) {
      cachedName = line.name;
      var data = await getAlerts(convertLongColor(name));
      if (this.mounted) {
        setState(() {
          setState(() {
            alerts = data;
          });
        });
      }
    }
  }

  @override
  getLineStations() {
    List<Station> sortedStations = getStations(line.name);
    setState(() {
      this.stations = sortedStations;
    });
  }

  int selectedItem = 0;
  void fetchSettings() async {
    if (stationSettings == null) {
      SettingsData s = await getSettings();
      setState(() {
        stationSettings = s;
      });
    }
  }

  Widget build(BuildContext context) {
    getLineStations();
    fetchSettings();
    getTopBar();
    fetchAlerts(convertLongColor(line.name));
    return Scaffold(
      backgroundColor: getPrimary(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
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
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(tr('btmBar.btmBar1'),
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (alerts != null) ...[
                        if (alerts.length > 0) ...[
                          Stack(
                            children: <Widget>[
                              IconButton(
                                tooltip: "Alerts",
                                iconSize: 31,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.railway_alert,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ServiceAlerts(
                                              convertLongColor(line.name),
                                              line: line)));
                                },
                              ),
                              Positioned(
                                top: 9,
                                left: 20.4,
                                child: Container(
                                  height: 18.5,
                                  width: 18.5,
                                  padding: EdgeInsets.only(left: 5.3, top: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      color: line.color),
                                  child: Text(
                                    alerts != null
                                        ? alerts.length.toString()
                                        : "",
                                    style: TextStyle(
                                      color: line.name == "Yellow"
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]
                      ],
                      IconButton(
                        tooltip: tr('station.subtitle'),
                        iconSize: 31,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.info_outline_rounded),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceInformation(line),
                              ));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: IconButton(
                          tooltip: tr('icons.map'),
                          iconSize: 31,
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.map_rounded),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullMap(line),
                                ));
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 0),
              child: Text(
                tr('stations.subTitle'),
                style: TextStyle(
                    fontSize: 18,
                    color:
                        isDark(context) ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: DividerLine(),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 30,
                                  padding: EdgeInsets.only(bottom: 3.5, top: 1),
                                  decoration: BoxDecoration(
                                      color: isDark(context)
                                          ? line.darkColor
                                          : line.color,
                                      borderRadius: line.name == "Purple"
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))
                                          : BorderRadius.all(
                                              Radius.circular(30))),
                                  child: Column(children: [
                                    for (var station in stations) ...[
                                      Column(
                                        children: [
                                          CCircle(station: station),
                                          Container(
                                              height: (stations
                                                          .indexOf(station) ==
                                                      (stations.length - 1)
                                                  ? 0
                                                  : calculateDistance(
                                                          station, stations) *
                                                      20)),
                                          if (station.name == "Garfield" &&
                                                  line.name == "Green" ||
                                              (station.lines.length > 1 &&
                                                  (stations.indexOf(station) !=
                                                      (stations.length -
                                                          1)))) ...[
                                            Container(
                                              height: line.name == "Green"
                                                  ? 19.6
                                                  : 19.2,
                                            )
                                          ],
                                        ],
                                      ),
                                    ],
                                    if (line.loops != null &&
                                        line.loops &&
                                        line.name != "Purple") ...[
                                      Container(height: 10),
                                      Icon(
                                          Icons
                                              .keyboard_arrow_down_sharp, //keyboard_arrow_down_sharp,
                                          color: Colors.white),
                                      Icon(
                                          Icons
                                              .keyboard_arrow_down_sharp, //keyboard_arrow_down_sharp,
                                          color: Colors.white),
                                    ]
                                  ]),
                                ),
                                if (line.name == "Purple") ...[
                                  Container(
                                    width: 30,
                                    padding: EdgeInsets.only(bottom: 3, top: 1),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Column(children: [
                                      for (var x = 0; x < 7; x++) ...[
                                        Container(
                                          margin: EdgeInsets.only(top: 5.8),
                                          height: 7,
                                          decoration: BoxDecoration(
                                              color: isDark(context)
                                                  ? line.darkColor
                                                  : line.color,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular((1)))),
                                          width: 30,
                                        )
                                      ],
                                      for (var station
                                          in getPurpleExpress()) ...[
                                        for (var x = 0; x < 3; x++) ...[
                                          ExpressBar(line: line)
                                        ],
                                        Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            Column(
                                              children: [
                                                ExpressBar(line: line),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 8),
                                                  height: 6.6,
                                                  decoration: BoxDecoration(
                                                      color: isDark(context)
                                                          ? line.darkColor
                                                          : line.color,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  (1)))),
                                                  width: 30,
                                                ),
                                              ],
                                            ),
                                            CCircle(station: station),
                                          ],
                                        ),
                                      ],
                                      ExpressBar(line: line)
                                    ]),
                                  ),
                                ],
                                line.name == "Green"
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              width: 30,
                                              padding: EdgeInsets.only(
                                                  bottom: 3.5, top: 1),
                                              decoration: BoxDecoration(
                                                  color: line.color,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              child: Column(children: [
                                                CCircle(
                                                    station:
                                                        getGreenLineTrack()[0]),
                                                Container(
                                                  height: 39,
                                                ),
                                                CCircle(
                                                    station:
                                                        getGreenLineTrack()[1]),
                                                Container(
                                                  height: 18,
                                                ),
                                                CCircle(
                                                    station:
                                                        getGreenLineTrack()[2]),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 2,
                                  ),
                                  for (var station in stations) ...[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Station_view(
                                                      station,
                                                      stations,
                                                      line,
                                                      isDark(context)
                                                          ? line.darkColor
                                                          : line.color,
                                                      false),
                                            ));
                                      },
                                      child: StationTitle(
                                          stations, station, line,
                                          green: false),
                                    )
                                  ],
                                  Container(
                                    height: 4,
                                  ),
                                  for (var station in getGreenLineTrack()) ...[
                                    line.name == "Green"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 9),
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Station_view(
                                                                station,
                                                                stations,
                                                                line,
                                                                isDark(context)
                                                                    ? line
                                                                        .darkColor
                                                                    : line
                                                                        .color,
                                                                false),
                                                      ));
                                                },
                                                child: StationTitle(
                                                    stations, station, line,
                                                    green: true)),
                                          )
                                        : Container(),
                                  ],
                                  if (line.name == "Purple") ...[
                                    Container(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5, bottom: 5),
                                        child: Text(
                                          'purple.purpleEx'.tr(),
                                          style: TextStyle(
                                              height: 1.4, fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 2),
                                        child: Container(
                                            child: Text('purple.moreInfo'.tr(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16))),
                                      ),
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => new AlertDialog(
                                                  title: new Text(
                                                      'purple.title'.tr()),
                                                  content: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 350),
                                                    child: new Text(
                                                        'purple.purpleLongEx'
                                                            .tr(),
                                                        style: TextStyle(
                                                            height: 1.4)),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                          'View Schedule'.tr()),
                                                      onPressed: () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ServiceInformation(
                                                                      line),
                                                            ));
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child:
                                                          Text('Dismiss'.tr()),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                ));
                                      },
                                    ),
                                    for (var station in getPurpleExpress()) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 9),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Station_view(
                                                            station,
                                                            stations,
                                                            line,
                                                            isDark(context)
                                                                ? line.darkColor
                                                                : line.color,
                                                            false),
                                                  ));
                                            },
                                            child: StationTitle(
                                                stations, station, line,
                                                green: true)),
                                      )
                                    ],
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (line.note != null) ...[
                        Container(
                          constraints: BoxConstraints(maxWidth: 450),
                          child: Text(
                            line.note,
                            style: TextStyle(height: 1.4, fontSize: 16),
                          ),
                        ),
                      ],
                      Container(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
