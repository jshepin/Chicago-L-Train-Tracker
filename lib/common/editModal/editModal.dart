import 'package:CTA_Tracker/common/train/predictionRow.dart';
import 'package:CTA_Tracker/data/classes.dart';
import 'package:CTA_Tracker/data/colors.dart';
import 'package:CTA_Tracker/pages/lines/lines.dart';
import 'package:CTA_Tracker/pages/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colorCircle.dart';
import '../dividerLine.dart';
import 'boxTemplate.dart';

class EditDialog extends StatefulWidget {
  var widget;
  var station;
  var snapshot;
  var isBus;
  EditDialog(this.widget, this.snapshot, this.station, this.isBus);
  // Function callback;

  @override
  _EditDialogState createState() => _EditDialogState();
}

int selectedStyle = 0;
bool _allSelected = true;
Line _selectedLine = getLines()[0];
int _selectedDestinationIndex;

class _EditDialogState extends State<EditDialog> {
  @override
  void initState() {
    // TODO: implement initStat
    var index = widget.snapshot.data[1] - 1;

    var line =
        widget.isBus ? "Red" : widget.station.lines[index == -1 ? 0 : index];

    var x = getLineFromColor(line);

    setState(() {
      _selectedLine = x;
      selectedStyle = widget.snapshot.data[0];
      _allSelected = index == -1;
      _selectedDestinationIndex = widget.snapshot.data[1];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.only(right: 5, bottom: 5),
      contentPadding: EdgeInsets.fromLTRB(11, 9, 11, 0),
      buttonPadding: EdgeInsets.all(0),
      content: Container(
        constraints: BoxConstraints(maxWidth: 300),
        height: !widget.widget.isBus &&
                widget.widget.station.lines.length > 1 &&
                !shouldRemoveLines(widget.widget.station.id)
            ? 404
            : 290,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 22),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: DividerLine(),
            ),
            Text("Card Size: ${selectedStyle == 0 ? 'Compact' : 'Large'}",
                style: TextStyle(fontSize: 19)),
            Container(
              height: 7,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () async {
                      setData(
                          widget.widget.isBus,
                          widget.widget.isBus
                              ? widget.widget.stop.id
                              : widget.station.id,
                          0,
                          widget.snapshot.data[1],
                          widget.snapshot.data[2]);
                      if (this.widget.widget.callback != null) {
                        this.widget.widget.callback();
                      }

                      setState(() {
                        selectedStyle = 0;
                      });
                    },
                    child: BoxTemplate(67, 67, selectedStyle == 0)),
                Container(width: 5),
                GestureDetector(
                  onTap: () async {
                    await setData(
                        widget.widget.isBus,
                        widget.widget.isBus
                            ? widget.widget.stop.id
                            : widget.widget.station.id,
                        1,
                        widget.snapshot.data[1],
                        widget.snapshot.data[2]);
                    if (this.widget.widget.callback != null) {
                      this.widget.widget.callback();
                    }
                    setState(() {
                      selectedStyle = 1;
                    });
                  },
                  child: BoxTemplate(75, 90, selectedStyle == 1),
                ),
              ],
            ),
            Container(
              height: 7,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: DividerLine(),
            ),
            if (!widget.widget.isBus &&
                widget.widget.station.lines.length > 1 &&
                !shouldRemoveLines(widget.widget.station.id)) ...[
              SettingsLabel("Default line", "Line that shows by default "),
              Container(
                height: 7,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: GestureDetector(
                        onTap: () async {
                          await setData(
                              widget.widget.isBus
                                  ? widget.widget.stop.id
                                  : widget.widget.isBus,
                              widget.widget.station.id,
                              widget.snapshot.data[0],
                              0,
                              0);
                          if (this.widget.widget.callback != null) {
                            this.widget.widget.callback();
                          }

                          setState(() {
                            _selectedDestinationIndex = 0;
                            _allSelected = true;
                          });
                        },
                        child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border: Border.all(
                                    color: _allSelected ?? true
                                        ? (isDark(context)
                                            ? Colors.white
                                            : Colors.grey[400])
                                        : Colors.transparent,
                                    width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "All",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                    ),
                    Container(
                      width: 6,
                    ),
                    for (var color in widget.widget.station.lines) ...[
                      Container(
                        margin: EdgeInsets.only(right: 3),
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                                color: (!_allSelected &&
                                        color == _selectedLine.name)
                                    ? (isDark(context)
                                        ? Colors.white
                                        : Colors.grey[400])
                                    : Colors.transparent,
                                width: 2)),
                        child: GestureDetector(
                          onTap: () async {
                            setData(
                                widget.widget.isBus
                                    ? widget.widget.stop.id
                                    : widget.widget.isBus,
                                widget.station.id,
                                widget.snapshot.data[0],
                                widget.station.lines.indexOf(color) + 1,
                                0);
                            if (this.widget.widget.callback != null) {
                              this.widget.widget.callback();
                            }

                            setState(() {
                              _allSelected = false;
                              _selectedDestinationIndex = 0;
                              _selectedLine = getLineFromColor(color);
                            });
                          },
                          child: ColorCircle(
                              color: color, selectedStation: widget.station),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: DividerLine(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Unfavorite',
              style: TextStyle(
                  color: isDark(context) ? Colors.red[400] : Colors.red)),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<String> savedStations =
                prefs.getStringList("savedStations") ?? [];
            if (savedStations.contains(widget.widget.isBus
                ? widget.widget.stop.id + "%BUS%"
                : widget.widget.station.id.toString())) {
              savedStations.remove(widget.widget.isBus
                  ? widget.widget.stop.id + '%BUS%'
                  : widget.widget.station.id.toString());
            }
            prefs.setStringList('savedStations', savedStations);
            if (this.widget.widget.callback != null) {
              this.widget.widget.callback();
            }
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            if (this.widget.widget.callback != null) {
              this.widget.widget.callback();
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
