import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      manager: ThemeManager(),
      builder: (ThemeMode themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CTA',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: Home(),
          themeMode: themeMode,
          darkTheme: ThemeData(
            fontFamily: 'Roboto',
            brightness: Brightness.dark,
            textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 49,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
          theme: ThemeData(
            fontFamily: 'Roboto',
            brightness: Brightness.light,
            textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 49,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
          ),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

bool connected = true;
var showCard = true;
var _settingsData = new SettingsData(false, false, false, false, false);
var _connection;
var _gotWelcome;

class _HomeState extends State<Home> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    print("initstate");
    _timer = Timer.periodic(Duration(seconds: 15), (Timer t) => update(t));
    getWelcomeShown().then((value) {
      setState(() {
        _gotWelcome = value;
      });
    });
    getSettings().then((value) {
      setState(() {
        _settingsData = value;
      });
    });
    checkConnection().then((value) {
      setState(() {
        _connection = value;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void update(Timer timer) {
    setState(() {});
  }

  void getTopBar() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(isDark(context));
  }

  @override
  Widget build(BuildContext context) {
    getTopBar();
    if (_gotWelcome != null) {
      return Scaffold(
          backgroundColor: getPrimary(context),
          bottomNavigationBar: BtmBar(),
          body: FutureBuilder(
            future: getPredictions("40080"),
            builder: (c, snap) {
              if (snap.hasData) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'home.title'.tr(),
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 2),
                                    child: ConnectionIndicator(),
                                  ),
                                  IconButton(
                                    tooltip: tr('icons.refresh'),
                                    iconSize: 34,
                                    icon: Icon(Icons.refresh),
                                    onPressed: () async {
                                      bool s = await checkConnection();
                                      setState(() {
                                        connected = s;
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: [
                              if (_settingsData.closestStationEnabled) ...[
                                FutureBuilder<List<StationWithDistance>>(
                                  future: findClosestStation(),
                                  builder: (c, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.length == 0) {
                                        return Container();
                                      }
                                      return Column(
                                        children: [
                                          if (_connection != null)
                                            for (StationWithDistance s
                                                in snapshot.data) ...[
                                              PredictionRow(
                                                _settingsData,
                                                stop: s.isBus ? s.stop : null,
                                                station:
                                                    s.isBus ? null : s.station,
                                                stations: s.isBus
                                                    ? null
                                                    : getStations(
                                                        s.station.lines[0]),
                                                distance: s.distance,
                                                isConnected: _connection,
                                                callback: () {
                                                  setState(() {});
                                                },
                                              ),
                                            ]
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                Container(
                                  height: 10,
                                )
                              ],
                              FutureBuilder(
                                future: getSavedStations(),
                                builder: (c, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.length == 0) {
                                      return Center(
                                        child: Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 500),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: getPrimary(context),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: isDark(context)
                                                      ? Colors.transparent
                                                      : Colors.grey
                                                          .withOpacity(0.2),
                                                  spreadRadius: 3,
                                                  blurRadius: 7,
                                                ),
                                              ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 17),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Hi there 👋 ",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "Welcome to Loop, favorited stops and stations will appear here.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          for (var id in snapshot.data) ...[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0, bottom: 0),
                                                child: DividerLine()),
                                            id.contains("%BUS%")
                                                ? PredictionRow(
                                                    _settingsData,
                                                    stop: getStationFromID(id),
                                                    callback: () {
                                                      setState(() {});
                                                    },
                                                  )
                                                : PredictionRow(
                                                    _settingsData,
                                                    station:
                                                        getStationFromID(id),
                                                    stations: getStations(
                                                        getStationFromID(id)
                                                            .lines[0]),
                                                    callback: () {
                                                      setState(() {});
                                                    },
                                                  ),
                                            Container(
                                              height: 10,
                                            )
                                          ],
                                        ],
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ));
    } else {
      return Container();
    }
  }
}

Future<List<String>> getSavedStations() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("savedStations") ?? [];
}

Future<bool> getWelcomeShown() async {
  return true;
}

Future<void> setWelcomeShown(bool s) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("welcomeShown", s);
}
