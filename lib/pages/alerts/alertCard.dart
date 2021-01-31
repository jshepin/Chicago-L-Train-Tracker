import 'package:CTA_Tracker/data/classes.dart';
import 'package:CTA_Tracker/pages/alerts/serviceAlerts.dart';
import 'package:flutter/material.dart';

class AlertCard extends StatefulWidget {
  Alert alert;
  AlertCard(this.alert);
  @override
  _AlertCardState createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(widget.alert.headline.toString() ?? "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            Container(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    widget.alert.eventStart == null || widget.alert.eventStart == ""
                        ? Container()
                        : Text(dateString(widget.alert.eventStart.toString()),
                            style: TextStyle(fontSize: 17)),
                    widget.alert.eventEnd == null || widget.alert.eventEnd == ""
                        ? Container()
                        : Text(" - " + dateString(widget.alert.eventEnd.toString()),
                            style: TextStyle(fontSize: 17)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: selected
                  ? Icon(Icons.arrow_drop_down, size: 30)
                  : Icon(Icons.arrow_right, size: 30),
            ),
            if (selected) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(widget.alert.shortDescription.replaceAll("\n", "") ?? "",
                    style: TextStyle(fontSize: 17)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
