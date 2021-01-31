import 'package:CTA_Tracker/exports.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Set<Polyline> getPolyLine(Station station, context) {
  Set<Polyline> polyLineSet = new Set();

  for (var q = 0; q < station.lines.length; q++) {
    List<LatLng> polylineCords = new List();
    List<List<double>> data = getCords(station.lines[q]);
    for (var x = 0; x < data.length; x++) {
      var row = data[x];
      polylineCords.add(LatLng(row[0], row[1]));
    }

    List<LatLng> greenPolyLine = new List();
    if (station.lines[q] == "Green") {
      for (var y = 0; y < getSecondGreen().length; y++) {
        var s = getSecondGreen()[y];
        greenPolyLine.add(LatLng(s[0], s[1]));
      }

      polyLineSet.add(Polyline(
        polylineId: PolylineId("secondgreen"),
        color: isDark(context) ? Color(0xff00974C) : Color(0xff00974C),
        width: 6,
        points: greenPolyLine,
      ));
    }

    polyLineSet.add(Polyline(
      polylineId: PolylineId(station.lines[q]),
      color: colorFromLine(station.lines[q], context),
      width: 6,
      points: polylineCords,
    ));
  }
  return polyLineSet;
}

Future<BitmapDescriptor> createCustomMarkerBitmap(String title, Color color) async {
  TextSpan span = new TextSpan(
    style: new TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
    ),
    text: title,
  );

  TextPainter tp = new TextPainter(
    text: span,
    textAlign: TextAlign.center,
  );

  tp.text = TextSpan(
    text: title,
    style: TextStyle(
        fontSize: 50.0,
        backgroundColor: Colors.black,
        color: Colors.white,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w700),
  );

  PictureRecorder recorder = new PictureRecorder();
  Canvas c = new Canvas(recorder);

  tp.layout();
  tp.paint(c, new Offset(0.0, 0.0));

  Picture p = recorder.endRecording();
  ByteData pngBytes = await (await p.toImage(tp.width.toInt() + 40, tp.height.toInt() + 20))
      .toByteData(format: ImageByteFormat.png);

  Uint8List data = Uint8List.view(pngBytes.buffer);

  return BitmapDescriptor.fromBytes(data);
}

String lastStationId = "";
String _mapStyle;
bool connected = true;
List<Alert> _alerts;
bool _fetchedAlerts = false;

class Station_view extends StatefulWidget {
  Station station;
  Color color;
  bool reload;
  List<Station> stations;
  Line line;
  Station_view(this.station, this.stations, this.line, this.color, this.reload);
  @override
  Station_viewState createState() => Station_viewState(station, stations, color, reload);
}

String reduce(String s) {
  var shortened = s
      .replaceAll("Service toward ", "Toward ")
      .replaceAll("Service at ", "")
      .replaceAll("Subway ", "");
  return shortened.substring(0, 1).toUpperCase() + shortened.substring(1);
}

var favorited = false;
SettingsData _settings = new SettingsData(false, false, false, false, false);

class Station_viewState extends State<Station_view> {
  Timer _timer;
  bool loadMap = false;

  void getTopBar() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(isDark(context));
  }

  @override
  void initState() {
    fetchSettings();
    setState(() {
      selectedStation = station;
    });
    _timer = Timer.periodic(Duration(seconds: 20), (Timer t) => update(t));
    Future.delayed(const Duration(milliseconds: 400), () => initLoadMap());
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void initLoadMap() {
    setState(() {
      loadMap = true;
    });
  }

  var count = 0;
  void update(Timer timer) {
    setState(() {});
  }

  void fetchSettings() async {
    SettingsData s = await getSettings();
    setState(() {
      _settings = s;
    });
  }

  void fetchAlerts(String name) async {
    if (this.mounted) {
      if (!_fetchedAlerts || lastStationId != selectedStation.id) {
        lastStationId = selectedStation.id;
        var data = await getAlerts(name);
        if (this.mounted) {
          setState(() {
            _alerts = data;
          });
        }

        _fetchedAlerts = true;
      }
    }
  }

  Station selectedStation;
  Station station;
  Color color;
  bool reload;
  List<Station> stations;
  Station_viewState(this.station, this.stations, this.color, this.reload);
  GoogleMapController mapController;

  Future<Set<Marker>> getMarkers(Station station) async {
    Set<Marker> markerSet = new Set();

    for (var q = 0; q < station.lines.length; q++) {
      List<Station> oStations = getStations(station.lines[q]);
      for (int x = 0; x < oStations.length; x++) {
        Station s = oStations[x];
        bool iOS = defaultTargetPlatform == TargetPlatform.iOS;

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
              "assets/markers/${station.lines[q] == "Yellow" ? "Foo" : station.lines[q]}${iOS ? 'iOS' : ''}.png");
        }
        markerSet.add(Marker(
            anchor: Offset(0.5, 0.82),
            markerId: MarkerId("${s.name}${s.lat}${s.long}${q}"),
            position: LatLng(s.lat, s.long),
            icon: icon,
            onTap: () {
              setState(() {
                count++;
                selectedStation = s;
              });
            }));
      }
    }

    if (station.lines[0] == "Green") {
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
    return markerSet;
  }

  @override
  Widget build(BuildContext context) {
    getTopBar();
    if (isDark(context) &&
        _settings != null &&
        _settings.showDarkMap != null &&
        _settings.showDarkMap) {
      rootBundle.loadString('assets/darkMapStyle.txt').then((string) {
        _mapStyle = string;
      });
    } else {
      rootBundle.loadString('assets/mapstyle.txt').then((string) {
        _mapStyle = string;
      });
    }
    fetchAlerts(selectedStation.id);

    return Scaffold(
      backgroundColor: getPrimary(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getSavedStations(),
              builder: (c, snap) {
                if (snap.hasData) {
                  favorited = snap.data.contains(selectedStation.id);
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
                                    if (reload) {
                                      _timer.cancel();
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
                                    tooltip: 'icons.favorite'.tr(),
                                    iconSize: 28,
                                    icon: Icon(
                                      favorited ? Icons.favorite : Icons.favorite_border,
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      List<String> savedStations =
                                          prefs.getStringList("savedStations") ?? [];
                                      if (savedStations.contains(selectedStation.id.toString())) {
                                        setState(() {
                                          favorited = false;
                                        });
                                        savedStations.remove(selectedStation.id.toString());
                                      } else {
                                        setState(() {
                                          favorited = true;
                                        });
                                        savedStations.add(selectedStation.id.toString());
                                      }
                                      prefs.setStringList('savedStations', savedStations);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: IconButton(
                                      tooltip: 'icons.refresh'.tr(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, bottom: 0),
                              child: Text(
                                selectedStation.name,
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 6, top: 4),
                                  child: ConnectionIndicator(),
                                ),
                                _settings.showExtraInformation && selectedStation.lines.length > 1
                                    ? Container()
                                    : AccessiblilityRow(selectedStation)
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            selectedStation.lines.length > 1
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                        ),
                                        for (var color in selectedStation.lines) ...[
                                          ColorCircle(
                                              color: color, selectedStation: selectedStation),
                                        ],
                                      ],
                                    ),
                                  )
                                : Container(),
                            _settings.showExtraInformation && selectedStation.lines.length > 1
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10, right: 5),
                                    child: AccessiblilityRow(selectedStation),
                                  )
                                : Container(),
                          ],
                        ),
                        if (station.note != null) ...[
                          Container(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Text(
                              station.note,
                              style: TextStyle(height: 1.4, fontSize: 16),
                            ),
                          ),
                        ],
                        Padding(
                          padding: EdgeInsets.only(top: 6, bottom: 4),
                          child: DividerLine(),
                        ),
                        _settings.showMap
                            ? Container(
                                child: SingleChildScrollView(
                                    child: Predictions(
                                  color,
                                  false,
                                  _settings.showMap,
                                  _settings,
                                  station: selectedStation,
                                  tabletShrink: true,
                                )),
                              )
                            : Predictions(
                                color,
                                false,
                                _settings.showMap,
                                _settings,
                                tabletShrink: true,
                                station: selectedStation,
                              ),
                        if (_settings.showAlerts && (_alerts != null)) ...[
                          for (var alert in _alerts) ...[
                            Padding(
                              padding: EdgeInsets.only(left: 11, bottom: 5, top: 9),
                              child: Text(
                                "There ${_alerts.length != 1 ? 'are' : 'is'} ${_alerts.length} alert${_alerts.length != 1 ? "s" : ''} for this station",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            AlertCard(alert)
                          ],
                        ],
                        if (_settings.showMap)
                          loadMap
                              ? Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: FutureBuilder(
                                        future: getMarkers(selectedStation),
                                        builder: (c, markerSnapshot) {
                                          if (markerSnapshot.hasData) {
                                            return Container(
                                                height: 450,
                                                child: GoogleMap(
                                                  mapType: MapType.normal,
                                                  gestureRecognizers: Set()
                                                    ..add(Factory<PanGestureRecognizer>(
                                                        () => PanGestureRecognizer()))
                                                    ..add(Factory<VerticalDragGestureRecognizer>(
                                                        () => VerticalDragGestureRecognizer())),
                                                  polylines: getPolyLine(selectedStation, context),
                                                  onMapCreated: (GoogleMapController controller) {
                                                    controller = controller;
                                                    controller.setMapStyle(_mapStyle);
                                                  },
                                                  initialCameraPosition: CameraPosition(
                                                      target: LatLng(selectedStation.lat,
                                                          selectedStation.long),
                                                      zoom: 14
                                                      // zoom: 16,
                                                      ),
                                                  markers: markerSnapshot.data,
                                                ));
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(color),
                                  )),
                                )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
