import 'package:CTA_Tracker/pages/serviceInfo/serviceInfo.dart';
import 'package:flutter/material.dart';

class TimeRow extends StatelessWidget {
  const TimeRow({
    Key key,
    @required this.table,
    @required this.x,
    @required this.y,
  }) : super(key: key);

  final table;
  final int x;
  final int y;
  final primary = 18.5;
  final secondary = 15.0;
  @override
  Widget build(BuildContext context) {
    List<List<String>> elements = getElements(table.data[x][y]);
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var col in elements) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (table.data[x][y].contains("-")) ...[
                  for (var e in col) ...[
                    if (e == "a" || e == "p") ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 1.5),
                        child: Text(e.contains("a") ? "am" : "pm",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: secondary)),
                      )
                    ] else if (e == "-") ...[
                      Text(
                        " - ",
                        style: TextStyle(fontSize: primary),
                      ),
                    ] else if (e == "n") ...[
                      Text(
                        " ",
                        style: TextStyle(fontSize: primary),
                      ),
                    ] else ...[
                      Text(
                        e,
                        style: TextStyle(fontSize: primary),
                      ),
                    ]
                  ]
                ] else ...[
                  Text(
                    table.data[x][y],
                    style: TextStyle(fontSize: 18),
                  ),
                ]
              ],
            ),
          ],
        ],
      ),
    );
  }
}
