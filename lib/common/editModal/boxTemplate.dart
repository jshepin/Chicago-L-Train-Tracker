import 'package:CTA_Tracker/data/colors.dart';
import 'package:CTA_Tracker/data/train/trainData.dart';
import 'package:flutter/material.dart';

class BoxTemplate extends StatefulWidget {
  double width;
  double height;
  bool selected;
  BoxTemplate(this.width, this.height, this.selected);
  @override
  _BoxTemplateState createState() => _BoxTemplateState();
}

class _BoxTemplateState extends State<BoxTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: Border.all(color: widget.selected ? Color(0xff2ECC71) : Colors.grey[300], width: 2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Icon(
          Icons.check,
          size: 30,
          color: widget.selected
              ? Color(0xff2ECC71)
              : isDark(context)
                  ? Colors.white
                  : Colors.black,
        ),
      ),
    );
  }
}
