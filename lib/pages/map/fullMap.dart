import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:core';
import 'package:CTA_Tracker/exports.dart';

Station selectedStation;
Location selectedTrain;

bool includesAll(arr, arr2) {
  if (arr.length != arr2.length) {
    return false;
  }
  arr2 = arr2.map((e) => convertLongColor(e));
  for (int x = 0; x < arr.length; x++) {
    var value1 = arr[x];
    if (!arr2.contains(value1)) {
      return false;
    }
  }
  return true;
}

GoogleMapController fullController;
bool dropdown = true;
SettingsData fullMapSettings;
String _mapStyle;
String selectedColor;
bool showStations = false;
bool showTrains = false;
List<bool> mapLayers = [false, false, false, false, false, false, false, false];
Set<Polyline> getFullPolyline(List<bool> layers, context) {
  Set<Polyline> polyLineSet = new Set();
  List<Line> lines = getLines();
  List<Line> lineLayers = [];
  for (int x = 0; x < layers.length; x++) {
    lineLayers.add(lines[x]);
  }
  for (int x = 0; x < lineLayers.length; x++) {
    Line line = lineLayers[x];
    List<LatLng> polylineCords = new List();
    List<List<double>> data = getCords(line.name);

    for (var x = 0; x < data.length; x++) {
      var row = data[x];
      polylineCords.add(LatLng(row[0], row[1]));
    }

    List<LatLng> greenPolyLine = new List();

    var secondGreen = getSecondGreen();
    if (line.name == "Green") {
      for (var y = 0; y < secondGreen.length; y++) {
        var s = secondGreen[y];
        greenPolyLine.add(LatLng(s[0], s[1]));
      }

      polyLineSet.add(Polyline(
        polylineId: PolylineId("secondgreen"),
        color: isDark(context)
            ? Color(0xff00974C).withOpacity(layers[x] ? 1.0 : 0.30)
            : Color(0xff00974C).withOpacity(layers[x] ? 1.0 : 0.30),
        width: 6,
        points: greenPolyLine,
      ));
    }

    polyLineSet.add(Polyline(
      polylineId: PolylineId(line.name),
      color: isDark(context)
          ? line.darkColor.withOpacity(layers[x] ? 1.0 : 0.30)
          : line.color.withOpacity(layers[x] ? 1.0 : 0.30),
      width: 6,
      points: polylineCords,
    ));
  }
  return polyLineSet;
}

var count = 0;

class FullMap extends StatefulWidget {
  Line line;
  bool all;
  FullMap(line, {all}) {
    this.line = line;
    this.all = all ?? false;
  }

  @override
  _FullMapState createState() => _FullMapState(line, all);
}

class _FullMapState extends State<FullMap> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) => refresh());

    if (all != null && all) {
      mapLayers = [true, true, true, true, true, true, true, true];
    } else {
      List<Line> l = getLines();
      for (int x = 0; x < l.length; x++) {
        if (l[x].name == line.name) {
          mapLayers[x] = true;
        } else {
          mapLayers[x] = false;
        }
      }
    }
    getLocations("Red");
    fetchSettings();
    selectedStation = null;
    selectedTrain = null;
    showStations = !all;
    dropdown = all;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void getTopBar() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(isDark(context));
  }

  void fetchSettings() async {
    SettingsData s = await getSettings();
    setState(() {
      fullMapSettings = s;
    });
  }

  void refresh() async {
    if (showTrains) {
      setState(() {});
      count++;
    }
  }

  Future<Set<Marker>> getFullMarkers(List<bool> layers) async {
    Set<Marker> markerSet = new Set();
    List<Line> lines = getLines();
    List<Line> lineLayers = [];
    for (int x = 0; x < layers.length; x++) {
      if (layers[x]) {
        lineLayers.add(lines[x]);
      }
    }

    if (showTrains) {
      List<String> layerStrings = getLines().map((e) => e.displayName).toList();

      var c = 0;
      for (var x = 0; x < layers.length; x++) {
        if (layers[x]) {
          LineLocations lineLocations = await getLocations(layerStrings[c]);
          List<Location> locations = lineLocations.locations;
          for (var p in locations) {
            if (selectedTrain != null) {
              var rn = selectedTrain.rn;
              if (rn == p.rn) {
                if (selectedTrain != p) {
                  // "resetting selected train");
                  setState(() {
                    selectedTrain = p;
                  });
                }
              }
            }
            if (p.lat != null && p.lon != null) {
              markerSet.add(Marker(
                  rotation: (double.parse(p.heading)),
                  anchor: Offset(0.5, 0.82),
                  markerId: MarkerId("${p.rn}${p.lat}${p.lon}$count"),
                  position: LatLng(double.parse(p.lat), double.parse(p.lon)),
                  icon: BitmapDescriptor.fromAsset(
                      "assets/arrows/${layerStrings[c]}${defaultTargetPlatform == TargetPlatform.iOS ? 'IOS' : ''}.png"),
                  onTap: () {
                    setState(() {
                      selectedStation = null;
                      selectedTrain = p;
                      selectedColor = layerStrings[x];
                    });
                  }));
            }
          }
        }
        c++;
      }
    }
    if (showStations) {
      for (int x = 0; x < lineLayers.length; x++) {
        Line line = lineLayers[x];

        List<Station> oStations = getStations(line.name);
        for (int x = 0; x < oStations.length; x++) {
          Station s = oStations[x];

          var icon;

          List<String> icons = [
            "Red,P,Y",
            "Pink,Org,G,P,Brn,Blue",
            "Pink,Org,G,P,Brn",
            "Pink,Org,Red,P,Brn,Blue",
            "Red,P",
            "Pink,Org,P,Brn",
            "P,Brn",
            "Red,P,Brn",
            "Pink,G",
            "Org,G,Red",
            "Pink,Org,G,Red,P,Brn,Blue",
          ];

          if (s.lines.length > 1) {
            icon = BitmapDescriptor.fromAsset(
                "assets/markers/Transfer${defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : ''}.png");
            for (var r = 0; r < icons.length; r++) {
              bool isIcon = true;
              int index = 0;

              List<String> ls = icons[r].split(",");
              if (includesAll(ls, s.lines)) {
                index = r;
              } else {
                isIcon = false;
              }

              if (isIcon) {
                icon = BitmapDescriptor.fromAsset(
                    "assets/markers/${index.toString()}${defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : ''}.png");
              }
            }
          } else {
            icon = BitmapDescriptor.fromAsset(
                "assets/markers/${line.name == "Yellow" ? "Foo" : line.name}${defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : ''}.png");
          }

          markerSet.add(Marker(
              anchor: Offset(0.5, 0.82),
              markerId: MarkerId("${s.name}${s.lat}${s.long}"),
              position: LatLng(s.lat, s.long),
              icon: icon,
              onTap: () {
                setState(() {
                  selectedStation = s;
                  selectedTrain = null;
                });
              }));
        }

        if (line.name == "Green") {
          markerSet.add(Marker(
              markerId: MarkerId("King Drive"),
              position: LatLng(41.78013, -87.615546),
              icon: BitmapDescriptor.fromAsset(
                  "assets/markers/Green${defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : ''}.png"),
              onTap: () {
                setState(() {
                  selectedStation = getGreenLineTrack()[1];
                });
              }));

          markerSet.add(Marker(
              markerId: MarkerId("Cottage Grove"),
              position: LatLng(41.780309, -87.605857),
              icon: BitmapDescriptor.fromAsset(
                  "assets/markers/Green${defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : ''}.png"),
              onTap: () {
                setState(() {
                  selectedStation = getGreenLineTrack()[2];
                });
              }));
        }
      }
    }
    return markerSet;
  }

  Line line;
  bool all;
  _FullMapState(line, all) {
    this.line = line;
    this.all = all;
  }
  @override
  Widget build(BuildContext context) {
    getLocations("Red");
    getTopBar();
    if (isDark(context) &&
        fullMapSettings != null &&
        fullMapSettings.showDarkMap != null) {
      if (fullMapSettings.showDarkMap) {
        rootBundle.loadString('assets/darkMapStyle.txt').then((string) {
          _mapStyle = string;
        });
      } else {
        rootBundle.loadString('assets/mapstyle.txt').then((string) {
          _mapStyle = string;
        });
      }
    }
    List<Line> lines = getLines();
    return Scaffold(
      bottomNavigationBar: Visibility(visible: all, child: BtmBar()),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
                future: getFullMarkers(mapLayers),
                builder: (context, markers) {
                  if (markers.hasData) {
                    return GoogleMap(
                      indoorViewEnabled: false,
                      rotateGesturesEnabled: false,
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer()))
                        ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer())),
                      polylines: getFullPolyline(mapLayers, context),
                      onMapCreated: (GoogleMapController controller) {
                        fullController = controller;
                        fullController.setMapStyle(_mapStyle);
                      },
                      initialCameraPosition: CameraPosition(
                        target: all
                            ? LatLng(41.920288, -87.692974)
                            : getCenter(line.name).center,
                        zoom: all ? 11 : getCenter(line.name).zoom,
                      ),
                      markers: markers.data,
                    );
                  } else {
                    return Container();
                  }
                }),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !all
                        ? Container(
                            margin: EdgeInsets.fromLTRB(3, 8, 6.5, 0),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark(context)
                                        ? Colors.transparent
                                        : Colors.grey.withOpacity(0.21),
                                    spreadRadius: 3,
                                    blurRadius: 4,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: getPrimary(context)),
                            height: all ? 60 : 70,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  tooltip: tr('icons.back'),
                                  padding: EdgeInsets.all(0),
                                  iconSize: 60,
                                  icon: Icon(
                                    Icons.chevron_left,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            type: PageTransitionType.fade,
                                            duration:
                                                Duration(milliseconds: 50),
                                            child: Stations(line)));
                                  },
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 2.2, right: 10),
                                      child: Text(
                                          "${line.displayName} ${'general.line'.tr()}",
                                          style: TextStyle(
                                            fontSize: 37,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    if (!all) ...[
                                      Row(
                                        children: [
                                          for (var x
                                              in getDirection(line.name)) ...[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 1),
                                              child: Text(
                                                "$x ${getDirection(line.name).indexOf(x) == 0 ? '- ' : ''}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: isDark(context)
                                                        ? Colors.grey[400]
                                                        : Colors.grey[600]),
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Layers(
                      lines: lines,
                      dropdown: dropdown,
                      toggleTrainsCallback: () {
                        setState(() {
                          showTrains = !showTrains;
                        });
                      },
                      toggleDropdownCallback: () {
                        setState(() {
                          dropdown = !dropdown;
                        });
                      },
                      toggleLayerCallback: (x) {
                        setState(() {
                          mapLayers[lines.indexOf(x)] =
                              !mapLayers[lines.indexOf(x)];
                        });
                      },
                      toggleStationsCallback: () {
                        setState(() {
                          showStations = !showStations;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            showTrains
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: all
                          ? EdgeInsets.only(
                              right: 8,
                              top: 8,
                            )
                          : EdgeInsets.only(
                              right: 12,
                              top: 13,
                            ),
                      child: ConnectionIndicator(background: true),
                    ),
                  )
                : Container(),
            if (selectedTrain != null)
              MapTrainCard(selectedTrain, selectedColor),
            if (selectedStation != null) MapStationCard(selectedStation)
          ],
        ),
      ),
    );
  }
}
