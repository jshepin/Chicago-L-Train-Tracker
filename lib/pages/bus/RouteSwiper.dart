import 'package:CTA_Tracker/common/train/stations/circle.dart';
import 'package:CTA_Tracker/pages/bus/stopView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../exports.dart';

class RouteSwiper extends StatefulWidget {
  var snapshot;
  List<String> directions;
  SettingsData settings;
  RouteSwiper(this.snapshot, this.directions, this.settings);
  @override
  _RouteSwiperState createState() => _RouteSwiperState();
}

class _RouteSwiperState extends State<RouteSwiper> {
  var selectedDirection = 0;
  double getWidth(x) {
    return selectedDirection == x ? 15 : 11;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Swiper(
        onIndexChanged: (i) {
          setState(() {
            selectedDirection = i;
          });
        },
        itemCount: widget.snapshot.data.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          List<StopPreview> stops = widget.snapshot.data[i].stops;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 3),
                    child: Container(
                      child: Text(
                          widget.snapshot.data[selectedDirection].direction,
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int x = 0; x < widget.directions.length; x++) ...[
                          Container(
                              margin: EdgeInsets.only(top: 7, right: 4),
                              height: getWidth(x),
                              width: getWidth(x),
                              decoration: BoxDecoration(
                                  color: x == 0
                                      ? Colors.grey[700].withOpacity(
                                          selectedDirection == x ? 1.0 : 0.8)
                                      : (isDark(context)
                                              ? Colors.white
                                              : Colors.grey[400])
                                          .withOpacity(selectedDirection == x
                                              ? 0.8
                                              : 0.7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))))
                        ]
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: DividerLine(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          padding: EdgeInsets.only(bottom: 3.5, top: 0),
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Column(children: [
                            for (var stop in stops) ...[
                              FutureBuilder(
                                  future: getAlerts(stop.id),
                                  builder: (c, snapshot) {
                                    if (snapshot.hasData) {
                                      return CCircle(
                                          stop: stop,
                                          isAlert: widget.settings.showAlerts &&
                                              snapshot.data.length > 0);
                                    } else {
                                      return Container();
                                    }
                                  }),
                              if (stops.indexOf(stop) != stops.length - 1)
                                Container(height: 20)
                            ],
                          ]),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5, top: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (StopPreview stop in stops) ...[
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Stop_view(
                                                getStopFromID(
                                                    stop.id.toString()),
                                                false),
                                          ));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          color: Colors.transparent,
                                          child: Text(
                                            stop.name,
                                            style: TextStyle(fontSize: 19),
                                          ),
                                        ),
                                        Container(
                                          height: 14.995,
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
          );
        },
      ),
    );
  }
}
