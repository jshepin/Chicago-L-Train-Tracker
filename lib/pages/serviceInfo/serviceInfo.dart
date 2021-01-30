import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/dividerLine.dart';
import 'package:CTA_Tracker/exports.dart';

class Table {
  String name;
  List<String> colHeaders;
  List<String> rowHeaders;
  List<List<String>> data;
  Table(this.name, this.colHeaders, this.rowHeaders, this.data);
}

class ServiceInformation extends StatefulWidget {
  Line line;
  ServiceInformation(this.line);
  @override
  _ServiceInformationState createState() => _ServiceInformationState(line);
}

var selectedThemeOption = 0;

class _ServiceInformationState extends State<ServiceInformation> {
  Line line;
  _ServiceInformationState(this.line);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Table> tables = getServiceData(line.name);
    return Scaffold(
      backgroundColor: getPrimary(context),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                tooltip: "Back",
                                iconSize: 60,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.chevron_left,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Stations(line),
                                      ));
                                }),
                            Container(
                              padding: EdgeInsets.only(top: 3.2),
                              child: Text("Service Information",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    DividerLine(),
                    Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var table in tables) ...[
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: getPrimary(context),
                                    border: Border.all(
                                        color: isDark(context)
                                            ? line.darkColor
                                            : line.color,
                                        width: 2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        table.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var x = 0;
                                                  x < table.data.length;
                                                  x++) ...[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        child: Row(
                                                      children: [
                                                        for (var s in table
                                                                .rowHeaders[x]
                                                                .split(",") ??
                                                            []) ...[
                                                          if (table
                                                                  .rowHeaders[x]
                                                                  .split(",")
                                                                  .indexOf(s) ==
                                                              1) ...[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 4,
                                                                      top: 5),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ],
                                                          Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      right: 3,
                                                                      bottom: 2,
                                                                      top: 7),
                                                              padding: EdgeInsets.fromLTRB(
                                                                  4, 3, 4, 2.2),
                                                              decoration: BoxDecoration(
                                                                  color: isDark(context)
                                                                      ? line
                                                                          .darkColor
                                                                      : line
                                                                          .color,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                              child: Text(s,
                                                                  style: TextStyle(
                                                                      color: line.name == "Yellow"
                                                                          ? Colors.black
                                                                          : Colors.white,
                                                                      fontSize: 16.5)))
                                                        ]
                                                      ],
                                                    )),
                                                    Divider(),
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          for (var y = 0;
                                                              y <
                                                                  table.data[x]
                                                                      .length;
                                                              y++) ...[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  table.colHeaders[
                                                                      y],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17.5),
                                                                ),
                                                                TimeRow(
                                                                    table:
                                                                        table,
                                                                    x: x,
                                                                    y: y),
                                                              ],
                                                            ),
                                                            y == table.data[x].length - 1
                                                                ? Container()
                                                                : Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: 0,
                                                                        right:
                                                                            10),
                                                                    height: 20,
                                                                    child:
                                                                        Divider())
                                                          ]
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

List<List<String>> getElements(String s) {
  List<List<String>> cols = [];
  List<String> elements = [];
  var a = "";
  for (var x = 0; x < s.length; x++) {
    if (s[x] == "n") {
      cols.add(elements);
      elements = [];
    } else {
      if (s[x] == "a" || s[x] == "p") {
        elements.add(a);
        a = "";
        elements.add(s[x]);
      } else if (s[x] == "-") {
        elements.add('-');
        a = "";
      } else if (s[x] == "n") {
        elements.add('n');
        a = "";
      } else {
        if (a != " ") {
          a = a + s[x];
        }
      }
      if (x == s.length - 1) {
        cols.add(elements);
        elements = [];
      }
    }
  }
  return cols;
}
