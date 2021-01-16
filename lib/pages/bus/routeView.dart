import 'package:CTA_Tracker/common/train/stations/circle.dart';
import 'package:CTA_Tracker/exports.dart';
import 'package:CTA_Tracker/pages/alerts/serviceAlerts.dart';
import 'package:CTA_Tracker/pages/bus/stopView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
  var selectedDirection = 0;
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
                future: settings.showAlerts
                    ? getAlerts(widget.route.id)
                    : getEmptyAlerts(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text('Stops',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w600)),
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
                                                            builder: (context) =>
                                                                ServiceAlerts(
                                                              widget.route.id,
                                                              busRoute:
                                                                  widget.route,
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
                                                      padding: EdgeInsets.only(
                                                          left: 5.3, top: 1),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                100),
                                                          ),
                                                          color: Colors.red),
                                                      child: Text(
                                                        alerts != null
                                                            ? alerts.length
                                                                .toString()
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
                                padding:
                                    const EdgeInsets.only(left: 18, top: 0),
                                child: Text(
                                  "Click a Stop to view the schedule",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: isDark(context)
                                          ? Colors.grey[400]
                                          : Colors.grey[600]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: DividerLine(),
                              ),
                              Expanded(
                                child: Swiper(
                                  onIndexChanged: (i) {
                                    setState(() {
                                      selectedDirection = i;
                                    });
                                  },
                                  itemCount: snapshot.data.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    List<StopPreview> stops =
                                        snapshot.data[i].stops;

                                    return Container(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2, left: 3),
                                                child: Container(
                                                  child: Text(
                                                      snapshot
                                                          .data[
                                                              selectedDirection]
                                                          .direction,
                                                      style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    for (int x = 0;
                                                        x < directions.length;
                                                        x++) ...[
                                                      x == 0
                                                          ? Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      top: 7,
                                                                      right: 4),
                                                              height:
                                                                  selectedDirection == x
                                                                      ? 15
                                                                      : 11,
                                                              width:
                                                                  selectedDirection == x
                                                                      ? 15
                                                                      : 11,
                                                              decoration: BoxDecoration(
                                                                  color: (isDark(context)
                                                                          ? Colors
                                                                              .white
                                                                          : Colors.grey[
                                                                              400])
                                                                      .withOpacity(selectedDirection ==
                                                                              x
                                                                          ? 0.8
                                                                          : 0.7),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(20))))
                                                          : Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 7,
                                                                      right: 4),
                                                              height:
                                                                  selectedDirection ==
                                                                          x
                                                                      ? 15
                                                                      : 11,
                                                              width:
                                                                  selectedDirection ==
                                                                          x
                                                                      ? 15
                                                                      : 11,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey[700]
                                                                      .withOpacity(selectedDirection ==
                                                                              x
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
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                                child: DividerLine(),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 3.5,
                                                                  top: 1),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey[
                                                                      800],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                          child: Column(
                                                              children: [
                                                                for (var stop
                                                                    in stops) ...[
                                                                  Column(
                                                                    children: [
                                                                      FutureBuilder(
                                                                          future: getAlerts(stop
                                                                              .id),
                                                                          builder:
                                                                              (c, snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              return CCircle(stop: stop, isAlert: settings.showAlerts && snapshot.data.length > 0);
                                                                            } else {
                                                                              return Container();
                                                                            }
                                                                          }),
                                                                      stops.indexOf(stop) !=
                                                                              stops.length -
                                                                                  1
                                                                          ? Container(
                                                                              height: 20)
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                ],
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5, top: 3),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 2,
                                                          ),
                                                          for (StopPreview stop
                                                              in stops) ...[
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => Stop_view(
                                                                            getStopFromID(stop.id.toString()),
                                                                            false),
                                                                      ));
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              5),
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            stop.name,
                                                                            style:
                                                                                TextStyle(fontSize: 19),
                                                                          ),
                                                                          Container()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          14.955,
                                                                    )
                                                                  ],
                                                                ))
                                                          ],
                                                          Container(
                                                            height: 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
