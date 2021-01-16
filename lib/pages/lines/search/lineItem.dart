import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class LineItem extends StatelessWidget {
  Line line;
  bool editMode;
  LineItem({this.line, this.editMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
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
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 0, right: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: isDark(context) ? line.darkColor : line.color,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: Center(
                        child: Text(
                      line.name.substring(0, 1),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700),
                    )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 2, top: 3.5),
                          child: Text(
                            line.displayName,
                            style: TextStyle(fontSize: 23),
                          )),
                      Container(height: 2),
                      Row(
                        children: [
                          for (var x in line.name == "Green"
                              ? ["Harlem/Lake", "Cottage Gr. or 63rd"]
                              : getDirection(line.name)) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                "$x ${getDirection(line.name).indexOf(x) == 0 ? '-' : ''}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: isDark(context)
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                              ),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: editMode
                    ? EdgeInsets.only(left: 4, right: 10)
                    : EdgeInsets.only(left: 4, right: 3),
                child: Icon(
                  editMode ? Icons.reorder : Icons.chevron_right,
                  size: editMode ? 30 : 35,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
