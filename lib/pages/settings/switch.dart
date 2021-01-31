import 'package:CTA_Tracker/data/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  String title;
  String subtitle;
  bool enabled;
  Function callback;
  ToggleSwitch(this.title, this.subtitle, this.enabled, this.callback);
  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(widget.title, style: TextStyle(fontSize: 21)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            widget.subtitle,
            style: TextStyle(
                height: 1.3,
                fontSize: 17,
                color: isDark(context) ? Colors.grey[400] : Colors.grey[600]),
          ),
        ),
        trailing: CupertinoSwitch(
          value: widget.enabled,
          onChanged: (bool value) async {
            this.widget.callback(value);
          },
        ),
      ),
    );
  }
}
