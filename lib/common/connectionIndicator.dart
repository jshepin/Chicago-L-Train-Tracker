import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:CTA_Tracker/exports.dart';

bool showDashed(String color, Station s) {
  return (color == "Purple" &&
      (getPurpleExpressIds().contains(s.id) || (s.pexp != null && s.pexp)));
}

class ConnectionIndicator extends StatefulWidget {
  bool background;
  ConnectionIndicator({this.background});
  @override
  _ConnectionIndicatorState createState() => _ConnectionIndicatorState();
}

class _ConnectionIndicatorState extends State<ConnectionIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Timer _timer;
  bool connectedIndicator = true;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) => refresh());
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _controller.repeat();
    super.initState();
  }

  void refresh() async {
    bool connected = await checkConnection();
    setState(() {
      connectedIndicator = connected;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: connectedIndicator ? 56 : 150,
      padding: EdgeInsets.fromLTRB(4, 1, 5, 1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: widget.background ?? false
              ? (isDark(context) ? Colors.black : Colors.white)
              : Colors.transparent),
      child: AnimatedBuilder(
        animation: _controller.view,
        builder: (context, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5, top: 1.51),
                height: 9,
                width: 9,
                decoration: BoxDecoration(
                    color: (!connectedIndicator
                            ? Color(0xffCD6155)
                            : Color(0xff2ECC71))
                        .withOpacity(
                            0.5 * sin(_controller.value * 2 * pi) + 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              Text(
                connectedIndicator ? "Live" : "No Connection",
                style: TextStyle(
                    color: !connectedIndicator
                        ? Color(0xffCD6155)
                        : Color(0xff2ECC71),
                    fontSize: 17),
              ),
            ],
          );
        },
      ),
    );
  }
}
