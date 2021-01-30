import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    Key key,
    @required this.color,
    @required this.selectedStation,
  }) : super(key: key);

  final String color;
  final Station selectedStation;

  bool isPurpleExp() {
    return color == "Purple" &&
        getPurpleExpressIds().contains(selectedStation.id);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          isPurpleExp() ? "Purple Express" : "$color ${'general.line'.tr()}",
      child: Padding(
        padding: isPurpleExp() ? EdgeInsets.all(3) : EdgeInsets.only(left: 0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: [7, 4.5],
          radius: Radius.circular(100),
          color: isPurpleExp()
              ? colorFromLine(color, context)
              : Colors.transparent,
          strokeWidth: 3,
          child: Container(
            height: isPurpleExp() ? 22 : 27,
            width: isPurpleExp() ? 22 : 27,
            decoration: BoxDecoration(
                color: isPurpleExp()
                    ? Colors.transparent
                    : colorFromLine(color, context),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Center(
                child: Text(
              color.substring(0, 1),
              style: TextStyle(
                  color: isPurpleExp()
                      ? (isDark(context)
                          ? Colors.white
                          : colorFromLine(color, context))
                      : Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            )),
          ),
        ),
      ),
    );
  }
}
