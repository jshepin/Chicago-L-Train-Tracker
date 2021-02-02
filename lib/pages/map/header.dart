import 'package:CTA_Tracker/data/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../exports.dart';

class MapHeader extends StatelessWidget {
  bool all;
  Line line;
  MapHeader(this.all, this.line);
  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.fromLTRB(3, 8, 6.5, 0),
      child: Container(
        margin: EdgeInsets.fromLTRB(3, 8, 6.5, 0),
        height: all ? 60 : 70,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: tr('icons.back'),
              padding: EdgeInsets.all(0),
              iconSize: 60,
              icon: Icon(
                Icons.chevron_left,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        curve: Curves.fastLinearToSlowEaseIn,
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50),
                        child: Stations(line)));
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.2, right: 10),
                  child: Text("${line.displayName} ${'general.line'.tr()}",
                      style: TextStyle(
                        fontSize: 37,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                if (!all) ...[
                  Row(
                    children: [
                      for (var x in getDirection(line.name)) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: Text(
                            "$x ${getDirection(line.name).indexOf(x) == 0 ? '- ' : ''}",
                            style: TextStyle(
                                fontSize: 16,
                                color: isDark(context) ? Colors.grey[400] : Colors.grey[600]),
                          ),
                        )
                      ]
                    ],
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
