import 'package:CTA_Tracker/exports.dart';
import 'package:CTA_Tracker/pages/settings/switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class SettingsData {
  bool closestStationEnabled;
  bool showExtraInformation;
  bool showMap;
  bool showDarkMap;
  bool showAlerts;
  SettingsData(this.closestStationEnabled, this.showExtraInformation, this.showMap,
      this.showDarkMap, this.showAlerts);
}

Future<SettingsData> getSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return new SettingsData(
      prefs.getBool("closestStationEnabled") ?? true,
      prefs.getBool("showExtraInformation") ?? true,
      prefs.getBool("showMap") ?? true,
      prefs.getBool("showDarkMap") ?? true,
      prefs.getBool("showAlerts") ?? true);
}

var selectedThemeOption = 0;
var themeOptions = [
  'Use System',
  'settings.theme.dark'.tr(),
  'settings.theme.light'.tr(),
];

SettingsData sSettings = new SettingsData(false, false, false, false, false);
bool gotten = false;
final InAppReview _inAppReview = InAppReview.instance;
String _appStoreId = '1550464970';
bool _isAvailable;

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inAppReview
          .isAvailable()
          .then(
            (bool isAvailable) => setState(
              () => _isAvailable = isAvailable && !Platform.isAndroid,
            ),
          )
          .catchError((_) => setState(() => _isAvailable = false));
    });

    fetchSettings();
    super.initState();
  }

  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: _appStoreId,
      );

  void getThemeMode(context) {
    var themeMode = ThemeModeHandler.of(context).themeMode;
    var index = 0;
    if (themeMode == ThemeMode.system) {
      index = 0;
    } else if (themeMode == ThemeMode.dark) {
      index = 1;
    } else {
      index = 2;
    }
    setState(() {
      selectedThemeOption = index;
    });
  }

  void getTopBar() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(isDark(context));
  }

  void fetchSettings() async {
    SettingsData s = await getSettings();
    if (!gotten) {
      gotten = true;
      setState(() {
        sSettings = s;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getThemeMode(context);
    getTopBar();
    const loadingMessage = 'LOADING';
    const availableMessage = 'AVAILABLE';
    const unavailableMessage = 'UNAVAILABLE';

    return Scaffold(
      bottomNavigationBar: BtmBar(),
      backgroundColor: getPrimary(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'InAppReview status: ${_isAvailable == null ? loadingMessage : _isAvailable ? availableMessage : unavailableMessage}',
                ),
                RaisedButton(
                  onPressed: _requestReview,
                  child: Text('Request Review'),
                ),
                RaisedButton(
                  onPressed: _openStoreListing,
                  child: Text('Open Store Listing'),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('btmBar.btmBar2'.tr(), style: Theme.of(context).textTheme.headline1),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: DividerLine(),
                ),
                ToggleSwitch(
                    'settings.accessibility.title'.tr(),
                    'settings.accessibility.subtitle'.tr(),
                    sSettings.showExtraInformation, (value) async {
                  setState(() {
                    sSettings.showExtraInformation = value;
                  });

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("showExtraInformation", value);
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 2),
                  child: DividerLine(),
                ),
                ToggleSwitch(
                    'settings.closestStation.title'.tr(),
                    'settings.closestStation.subtitle'.tr(),
                    sSettings.closestStationEnabled, (value) async {
                  setState(() {
                    sSettings.closestStationEnabled = value;
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("closestStationEnabled", value);
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 2),
                  child: DividerLine(),
                ),
                ToggleSwitch('settings.showMap.title'.tr(), 'settings.showMap.subtitle'.tr(),
                    sSettings.showMap, (value) async {
                  setState(() {
                    sSettings.showMap = value;
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("showMap", value);
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: DividerLine(),
                ),
                MergeSemantics(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('settings.theme.theme'.tr(), style: TextStyle(fontSize: 21)),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: DropdownButton<String>(
                        value: themeOptions[selectedThemeOption],
                        iconSize: 20,
                        elevation: 16,
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String newValue) async {
                          var newIndex = themeOptions.indexOf(newValue);
                          setState(() {
                            selectedThemeOption = newIndex;
                          });

                          if (newIndex == 0) {
                            ThemeModeHandler.of(context).saveThemeMode(ThemeMode.system);
                          } else if (newIndex == 1) {
                            ThemeModeHandler.of(context).saveThemeMode(ThemeMode.dark);
                          } else {
                            ThemeModeHandler.of(context).saveThemeMode(ThemeMode.light);
                          }
                        },
                        items: themeOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 5),
                  child: DividerLine(),
                ),
                if (sSettings.showMap &&
                    (selectedThemeOption == 0 || selectedThemeOption == 1)) ...[
                  ToggleSwitch('settings.darkMap.title'.tr(), 'settings.darkMap.subtitle'.tr(),
                      sSettings.showDarkMap, (value) async {
                    setState(() {
                      sSettings.showDarkMap = value;
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool("showDarkMap", value);
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 2),
                    child: DividerLine(),
                  ),
                ],
                if (sSettings.closestStationEnabled) ...[
                  MergeSemantics(
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SettingsLabel(
                              'settings.location.title'.tr(),
                              'Location data never leaves your device',
                            ),
                            Container(
                              height: 5,
                            ),
                            FutureBuilder(
                              future: checkLocationEnabled(),
                              builder: (i, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.contains("denied")) {
                                    return Text('settings.location.disabled'.tr(),
                                        style: TextStyle(fontSize: 18, color: Colors.red));
                                  } else {
                                    return Container(
                                      child: Text(snapshot.data,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  snapshot.data == 'settings.location.enabled'.tr()
                                                      ? Colors.green
                                                      : Colors.red)),
                                    );
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          tooltip: 'icons.refresh'.tr(),
                          iconSize: 30,
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            setState(() {});
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 2),
                    child: DividerLine(),
                  ),
                ],
                ToggleSwitch('Show Alerts', 'Display station alerts/issues prominently',
                    sSettings.showAlerts, (value) async {
                  setState(() {
                    sSettings.showAlerts = value;
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("showAlerts", value);
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 2),
                  child: DividerLine(),
                ),
                MergeSemantics(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text("Contact/Bug Fix", style: TextStyle(fontSize: 21)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'settings.contact.info'.tr(),
                        style: TextStyle(
                            height: 1.3,
                            fontSize: 17,
                            color: isDark(context) ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                    trailing: defaultTargetPlatform != TargetPlatform.iOS
                        ? Tooltip(
                            message: "Contact developer",
                            child: RaisedButton(
                                color: getSecondary(context),
                                child: Text('settings.contact.button'.tr()),
                                onPressed: () async {
                                  var url =
                                      "mailto:chicagoloopapp@gmail.com?subject='Loop' App inquiry - ${defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : 'Android'}";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                }),
                          )
                        : Text(""),
                  ),
                ),
                DividerLine(),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      "Realtime predictions data is provided by the CTA but not gaurenteed to be 100% accurate. Please take this into consideration as we have no control their system - Thank You",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDark(context) ? Colors.orange : Colors.blue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsLabel extends StatelessWidget {
  String title;
  String description;
  SettingsLabel(this.title, this.description);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 21)),
        Container(
          padding: EdgeInsets.only(top: 3),
          child: Text(
            description,
            style: TextStyle(
                fontSize: 17, color: isDark(context) ? Colors.grey[400] : Colors.grey[600]),
          ),
        ),
        Container(
          height: 5,
        ),
      ],
    );
  }
}

Future<String> checkLocationEnabled() async {
  try {
    Position position = await getLastKnownPosition();
    return position != null ? 'settings.location.enabled'.tr() : 'settings.location.disabled'.tr();
  } catch (e) {
    return 'settings.location.disabled'.tr();
  }
}
