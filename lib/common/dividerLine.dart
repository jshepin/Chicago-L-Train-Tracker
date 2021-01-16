import 'package:CTA_Tracker/data/colors.dart';
import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  const DividerLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: isDark(context) ? Color(0xff4a4a4a) : Colors.grey[200],
      height: 1,
    );
  }
}
