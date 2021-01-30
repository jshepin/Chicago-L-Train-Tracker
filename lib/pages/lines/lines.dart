import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CTA_Tracker/exports.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
}

List<Line> getLines() {
  return orderedLines;
}

List<Line> orderedLines = [
  new Line("Red", ('colors.red'.tr()), "D11A2C", "e63042", "ff475a"),
  new Line("Brown", ('colors.brown'.tr()), "623B1B", "9e6536", "ad7f58",
      note: 'notes.brown'.tr(), loops: true),
  new Line("Blue", ('colors.blue'.tr()), "01A1DE", "01A1DE", "18b4f0"),
  new Line("Green", ('colors.green'.tr()), "00974C", "00974C", "07ad5b"),
  new Line("Pink", ('colors.pink'.tr()), "EB82A8", "EB82A8", "e691af",
      note: 'notes.pink'.tr(), loops: true),
  new Line("Orange", ('colors.orange'.tr()), "F04A20", "F04A20", "f75b34",
      note: "notes.orange".tr(), loops: true),
  new Line("Yellow", ('colors.yellow'.tr()), "F4D03F", "e3c502", "e3c502"),
  new Line("Purple", ('colors.purple'.tr()), "382884", "705cd1", "9889e0",
      loops: true, note: 'notes.purple'.tr()),
];
List<BusRoute> busRoutes = [];
bool trainSelected = true;

class Lines extends StatefulWidget {
  @override
  _LinesState createState() => _LinesState();
}

List<String> getNames() {
  List<String> names = [];
  for (var x = 0; x < orderedLines.length; x++) {
    names.add(orderedLines[x].name);
  }
  return names;
}

bool editMode = false;
List<String> defaultNames = [
  "Red",
  "Brown",
  "Blue",
  "Green",
  "Pink",
  "Orange",
  "Yellow",
  "Purple"
];

class _LinesState extends State<Lines> {
  void getOrderedLines({reset}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Line> lines = getLines();
    List<Line> oLines = [];
    List<String> orderedNames =
        prefs.getStringList("orderedLines") ?? defaultNames;
    if (reset != null && reset) {
      orderedNames = defaultNames;
      prefs.setStringList("orderedLines", orderedNames);
      setState(() {
        editMode = false;
      });
    }
    for (var x = 0; x < orderedNames.length; x++) {
      for (var y = 0; y < lines.length; y++) {
        if (orderedNames[x] == lines[y].name) {
          oLines.add(lines[y]);
        }
      }
    }
    setState(() {
      orderedLines = oLines;
    });
  }

  void fetchBusRoutes() async {
    if (busRoutes.length == 0) {
      List<BusRoute> routes = getBusRoutes();
      setState(() {
        busRoutes = routes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getOrderedLines();
    fetchBusRoutes();
    return Scaffold(
      backgroundColor: getPrimary(context),
      bottomNavigationBar: BtmBar(),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onHorizontalDragEnd: (x) {
                setState(() {
                  trainSelected = !trainSelected;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(trainSelected ? 'Lines' : 'Routes',
                            style: Theme.of(context).textTheme.headline1),
                      ),
                      Row(
                        children: [
                          editMode && trainSelected
                              ? IconButton(
                                  tooltip: "Reset",
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 27,
                                  ),
                                  onPressed: () {
                                    getOrderedLines(reset: true);
                                  },
                                )
                              : Container(),
                          if (trainSelected)
                            IconButton(
                              tooltip: editMode
                                  ? tr('lines.saveChanges')
                                  : tr('lines.editOrder'),
                              icon: Icon(
                                editMode ? Icons.done : Icons.edit,
                                size: editMode ? 27 : 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  editMode = !editMode;
                                });
                              },
                            ),
                          Tooltip(
                              message: 'Search',
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  size: 32,
                                ),
                                onPressed: () {
                                  showSearch(
                                      context: context, delegate: DataSearch());
                                },
                              ))
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1, bottom: 1),
                    child: DividerLine(),
                  ),
                  Padding(
                    padding: trainSelected
                        ? EdgeInsets.only(top: 3, bottom: 6)
                        : EdgeInsets.only(top: 3, bottom: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                trainSelected = true;
                              });
                            },
                            child: MenuButton("Train", trainSelected, true),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                editMode = false;
                                trainSelected = false;
                              });
                            },
                            child: MenuButton("Bus", !trainSelected, false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  editMode
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tap and hold a card to reorder it",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  if (!trainSelected)
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: getBusRoutes().length,
                          itemBuilder: (c, i) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RouteItem(
                                  route: getBusRoutes()[i],
                                ),
                                DividerLine(),
                              ],
                            );
                          }),
                    ),
                  if (trainSelected)
                    editMode
                        ? Container(
                            child: Expanded(
                              child: ReorderableListView(
                                scrollDirection: Axis.vertical,
                                onReorder: (oldIndex, newIndex) async {
                                  var copied = orderedLines;
                                  Line removedValue = copied[oldIndex];
                                  bool lastIndex =
                                      newIndex == orderedLines.length;

                                  setState(() {
                                    orderedLines.removeAt(oldIndex);
                                    lastIndex
                                        ? orderedLines.add(removedValue)
                                        : orderedLines.insert(
                                            newIndex, removedValue);
                                  });

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  prefs.setStringList(
                                      "orderedLines", getNames());
                                  setState(() {});
                                },
                                children: [
                                  for (var line in orderedLines) ...[
                                    Container(
                                        key: ValueKey(line.name),
                                        child: LineItem(
                                            line: line, editMode: editMode)),
                                  ]
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: orderedLines.length,
                                itemBuilder: (c, i) {
                                  Line line = orderedLines[i];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Stations(line)),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            LineItem(
                                                line: line, editMode: editMode)
                                          ],
                                        ),
                                      ),
                                      DividerLine()
                                    ],
                                  );
                                }),
                          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  String title;
  bool selected;
  bool isTrain;
  MenuButton(this.title, this.selected, this.isTrain);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 2.0,
              color: selected ? Colors.blue[300] : Colors.blue[100]),
        ),
      ),
      child: Center(
        child: Text(
          isTrain ? "Trains" : "Buses",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

List<Stop> getStops() {
  List<Stop> stopsData = getBusStops()
      .map((e) => new Stop(e[0].toString(), e[1].toString(), e[2], e[3], e[4],
          e[5], e[6].toString(), e[7].toString(), e[8] == 1))
      .toList();
  return stopsData;
}
