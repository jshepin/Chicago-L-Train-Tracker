import 'package:CTA_Tracker/data/classes.dart';
import 'package:CTA_Tracker/data/colors.dart';
import 'package:flutter/material.dart';

class ExpressBar extends StatelessWidget {
  const ExpressBar({
    Key key,
    @required this.line,
  }) : super(key: key);

  final Line line;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      height: 6.6,
      decoration: BoxDecoration(
          color: isDark(context) ? line.darkColor : line.color,
          borderRadius: BorderRadius.all(Radius.circular((1)))),
      width: 30,
    );
  }
}
