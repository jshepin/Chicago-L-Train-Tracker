import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class Layers extends StatelessWidget {
  List<Line> lines;
  bool dropdown;
  Function toggleTrainsCallback;
  Function toggleStationsCallback;
  Function toggleLayerCallback;
  Function toggleDropdownCallback;
  Layers(
      {this.lines,
      this.dropdown,
      this.toggleTrainsCallback,
      this.toggleStationsCallback,
      this.toggleLayerCallback,
      this.toggleDropdownCallback});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 3, top: 5),
        padding: EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: isDark(context) ? Colors.transparent : Colors.grey.withOpacity(0.21),
                spreadRadius: 3,
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: getPrimary(context).withOpacity(0.99)),
        height: dropdown ? 270 : 42,
        width: 110,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  this.toggleDropdownCallback();
                },
                child: Container(
                  width: 115,
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 3, top: 2),
                  child: Row(
                    children: [
                      !dropdown
                          ? Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            )
                          : Icon(Icons.arrow_drop_up, size: 30),
                      Padding(
                        padding: EdgeInsets.fromLTRB(3, 7, 8, 8),
                        child: Text(
                          "Layers",
                          style: TextStyle(fontSize: 19),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              dropdown ? DividerLine() : Container(),
              Container(height: 3),
              if (dropdown) ...[
                GestureDetector(
                  onTap: () {
                    this.toggleTrainsCallback();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, right: 11, left: 7, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Trains",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          Icon(
                            Icons.check,
                            size: 23,
                            color: showTrains
                                ? (isDark(context) ? Colors.white : Colors.black)
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 0),
                  child: Container(
                    color: isDark(context) ? Colors.grey[700] : Colors.grey[200],
                    height: 1,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    this.toggleStationsCallback();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, right: 11, left: 7, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Stations",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          Icon(
                            Icons.check,
                            size: 23,
                            color: showStations
                                ? (isDark(context) ? Colors.white : Colors.black)
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 6, bottom: 0), child: DividerLine()),
                for (var x in lines) ...[
                  GestureDetector(
                    onTap: () {
                      this.toggleLayerCallback(x);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6, right: 11, left: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 5,
                              ),
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  color: isDark(context) ? x.darkColor : x.color,
                                  borderRadius: BorderRadius.all(Radius.circular(100))),
                              child: Center(
                                  child: Text(
                                x.name.substring(0, 1),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                              )),
                            ),
                            Container(
                                child: Icon(
                              Icons.check,
                              size: 23,
                              color: mapLayers[lines.indexOf(x)]
                                  ? (isDark(context) ? Colors.white : Colors.black)
                                  : Colors.transparent,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 0),
                    child: DividerLine(),
                  ),
                ]
              ],
            ],
          ),
        ));
  }
}
