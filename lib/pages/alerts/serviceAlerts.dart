import 'package:CTA_Tracker/exports.dart';
import 'package:flutter/material.dart';

class ServiceAlerts extends StatefulWidget {
  String id;
  Line line;
  BusRoute busRoute;
  bool isBus;
  ServiceAlerts(this.id, {line, busRoute}) {
    if (line != null) {
      this.isBus = false;
      this.line = line;
    } else if (busRoute != null) {
      this.isBus = true;
      this.busRoute = busRoute;
    }
  }
  @override
  _ServiceAlertsState createState() => _ServiceAlertsState();
}

var selectedThemeOption = 0;
var alerts;

class _ServiceAlertsState extends State<ServiceAlerts> {
  @override
  void initState() {
    fetchAlerts(widget.id);
    super.initState();
  }

  void fetchAlerts(String id) async {
    var data = await getAlerts(id);
    setState(() {
      alerts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPrimary(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: alerts == null
              ? Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 10),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => widget.isBus
                                            ? RouteView(widget.busRoute)
                                            : Stations(widget.line),
                                      ));
                                }),
                            Container(
                              padding: EdgeInsets.only(top: 4),
                              child: Text("Alerts",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if (!widget.isBus)
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 5, top: 0, right: 10),
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                      color: widget.isBus
                                          ? Colors.red
                                          : (isDark(context)
                                              ? widget.line.darkColor
                                              : widget.line.color),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Center(
                                      child: Text(
                                    widget.line.name.substring(0, 1),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700),
                                  )),
                                ),
                              Container(
                                child: Text(
                                    "${widget.isBus ? 'Route #' : ''}${widget.isBus ? widget.busRoute.id : widget.line.name}",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 8),
                          child: DividerLine(),
                        ),
                        if (alerts != null && alerts.length == 0) ...[
                          Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(),
                              child: Text(
                                "Yay, no alerts today",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                        for (Alert alert in alerts) ...[
                          AlertCard(alert),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 7),
                            child: DividerLine(),
                          ),
                        ]
                      ]),
                ),
        ),
      ),
    );
  }
}

String dateString(String s) {
  var mm = s.substring(5, 7);
  var dd = s.substring(8, 10);
  if (!s.contains("T")) {
    return "$mm/$dd";
  } else {
    var hour = int.parse(s.substring(11, 13));
    bool isAM = hour < 12;
    hour = hour % 12;
    var min = s.substring(14, 16);
    return "$mm/$dd $hour:$min ${isAM ? "AM" : "PM"}";
  }
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
