import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class RouteItem extends StatelessWidget {
  BusRoute route;
  RouteItem({this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RouteView(route)),
        );
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 53,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: Container(
              padding: EdgeInsets.only(bottom: 0, top: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, top: 0, right: 10),
                        height: 40,
                        width: 40,
                        child: Center(
                            child: Text(
                          route.id,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w700),
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6, top: 3.5),
                        child: Text(
                          route.longName,
                          style: TextStyle(fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
