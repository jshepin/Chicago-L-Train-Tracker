import 'package:CTA_Tracker/exports.dart';
import 'package:CTA_Tracker/pages/alerts/serviceAlerts.dart';
import 'package:CTA_Tracker/pages/bus/RouteSwiper.dart';
import 'package:flutter/material.dart';

class RouteView extends StatefulWidget {
  BusRoute route;
  RouteView(this.route);
  @override
  _RouteViewState createState() => _RouteViewState();
}

Future<List<Alert>> getEmptyAlerts() async {
  List<Alert> x = [];
  return x;
}

class _RouteViewState extends State<RouteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPrimary(context),
      body: SafeArea(
          child: FutureBuilder(
        future: getSettings(),
        builder: (context, settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            SettingsData settings = settingsSnapshot.data;
            return FutureBuilder(
                future: settings.showAlerts ? getAlerts(widget.route.id) : getEmptyAlerts(),
                builder: (context, alertSnapshot) {
                  if (alertSnapshot.hasData) {
                    List<Alert> alerts = alertSnapshot.data;
                    return FutureBuilder(
                      future: getStopsFromID(widget.route.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> directions = snapshot.data[0].directions;
                          return Column(
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
                                          child: Text('Stops',
                                              style: TextStyle(
                                                  fontSize: 40, fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        children: [
                                          if (alerts != null) ...[
                                            if (alerts.length > 0) ...[
                                              Stack(
                                                children: <Widget>[
                                                  IconButton(
                                                    tooltip: "Alerts",
                                                    iconSize: 31,
                                                    padding: EdgeInsets.only(),
                                                    icon: Icon(
                                                      Icons.bus_alert,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => ServiceAlerts(
                                                              widget.route.id,
                                                              busRoute: widget.route,
                                                            ),
                                                          ));
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
                                                          color: Colors.red),
                                                      child: Text(
                                                        alerts != null
                                                            ? alerts.length.toString()
                                                            : "",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ]
                                          ],
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18, top: 0),
                                child: Text(
                                  "Click a Stop to view the schedule",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: isDark(context) ? Colors.grey[400] : Colors.grey[600]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: DividerLine(),
                              ),
                              RouteSwiper(snapshot, directions, settings)
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                });
          } else {
            return Container();
          }
        },
      )),
    );
  }
}
