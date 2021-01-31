import 'dart:async';
import 'package:CTA_Tracker/pages/home.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import '../classes.dart';
import 'station_data.dart';

var cachedThemePref = 0;

Map<String, int> cachedInServiceTrains = {};
DateTime lastInServiceCall = DateTime.now();

var gotPredictionsData = false;
List<Alert> cachedAlerts = [];

List<Alert> getAlertsFromLine(List<Alert> alerts, String line) {
  List<Alert> lineAlerts = [];
  for (var alert in alerts) {
    for (var impactedService in alert.impactedServices) {
      if (impactedService.id == line) {
        lineAlerts.add(alert);
      }
    }
  }
  return lineAlerts;
}

DateTime lastLocationCall = DateTime.now();
Map<String, LineLocations> cachedLocations = {};
bool gotLocations = false;
Future<LineLocations> getLocations(String name) async {
  name = convertLongColor(name);
  bool isConnected = await checkConnection();
  if (isConnected) {
    try {
      var diff = DateTime.now().difference(lastLocationCall).inSeconds;
      if (diff < 20) {
      } else {
        gotLocations = false;
      }
      if (cachedLocations[name] != null && diff < 30) {
        return cachedLocations[name];
      }
      if (!gotLocations) {
        gotLocations = true;
        lastLocationCall = DateTime.now();
        var url =
            '${ConfigReader.getServerURL()}/inservicetrains?line=Brn,G,Org,P,Y,Red,Blue,Pink&token=${ConfigReader.getAPIKEY()}';
        var response = await http
            .get(url)
            .timeout(const Duration(seconds: 5), onTimeout: () {})
            .catchError((e) {
          return null;
        });
        var data = jsonDecode(response.body);

        for (int r = 0; r < data.length; r++) {
          //for every train line
          var l = data[r];
          String lineName = l["@name"];
          var trains = l["train"];
          List<Location> locations = [];
          if (trains.length > 0) {
            for (var t in trains) {
              //for every train on the line
              Location p = new Location(
                t["rn"],
                t["destSt"],
                t["destNm"],
                t["trDr"],
                t["nextStaId"],
                t["nextStpId"],
                t["nextStaNm"],
                t["prdt"],
                t["arrT"],
                t["isApp"],
                t["isDly"],
                t["flags"],
                t["lat"],
                t["lon"],
                t["heading"],
              );
              locations.add(p);
            }
          }
          cachedLocations[lineName] = new LineLocations(lineName, locations);
        }
        lastLocationCall = DateTime.now();
      } else {}
    } catch (e) {}
    return cachedLocations[name.toLowerCase()] ?? new LineLocations("", []);
  } else {
    return new LineLocations("", []);
  }
}

var gotData = false;
Map<String, List<Prediction>> cachedPredictions = {};
DateTime lastPredictionsCall = DateTime.now();

Future<List<Prediction>> getPredictions(String stationID, {bool homeView}) async {
  List<String> s = await getSavedStations();

  //get predictions based on mapid
  bool isConnected = await checkConnection();
  List<Prediction> predictions = [];
  bool deny = false;
  // if (homeView != null && homeView && s.length == 0) {
  //   deny = true;
  //   print("settting deny to true");
  // } else {
  //   print("nope");
  // }
  if (isConnected && !deny) {
    try {
      var diff = DateTime.now().difference(lastPredictionsCall).inSeconds;
      if (diff < 30) {
      } else {
        gotData = false;
      }
      if (cachedPredictions[stationID] != null && diff < 40) {
        return cachedPredictions[stationID];
      }
      if (!gotData) {
        gotData = true;
        lastPredictionsCall = DateTime.now();
        var url =
            '${ConfigReader.getServerURL()}/arrivalpredictions?stationID&token=${ConfigReader.getAPIKEY()}';
        print("FETCHING TRAIN DATA");
        var response = await http.get(url).timeout(const Duration(seconds: 5), onTimeout: () {
          return null;
          // return new http.Response({}, 404);
        }).catchError((e) {
          return null;
        });

        Map<String, dynamic> data = jsonDecode(response.body);
        var eta = data["eta"];
        for (int x = 0; x < eta.length; x++) {
          var s = eta[x];
          cachedPredictions.remove(s["staId"]);
        }
        for (int x = 0; x < eta.length; x++) {
          var s = eta[x];
          Prediction p = new Prediction(
              s["tmst"],
              s["staId"],
              s["stpId"],
              s["staNm"],
              s["stpDe"],
              s["rn"],
              s["rt"],
              s["destSt"],
              s["destNm"],
              s["trDr"],
              s["prdt"],
              s["arrT"],
              s["isApp"],
              s["isSch"],
              s["isDly"],
              s["isFlt"],
              s["flags"],
              s["lat"],
              s["lon"],
              s["heading"]);
          String staId = s["staId"];

          List<Prediction> predictions = cachedPredictions[staId] ?? [];
          predictions.add(p); //add new prediction
          cachedPredictions.update(staId, (value) {
            return predictions;
          }, ifAbsent: () => predictions);
        }
        lastPredictionsCall = DateTime.now();
      } else {}
    } catch (e) {}
    return cachedPredictions[stationID] ?? [];
  } else {
    if (cachedPredictions[stationID] != null) {
      return cachedPredictions[stationID];
    } else {
      return predictions;
    }
  }
}

formatTime(String prdt, String arrT, bool vstack, {bool preciseNow}) {
  var dif;
  dif = (getTimeFromString(prdt)).difference(DateTime.now());

  var mins = (dif.inSeconds / 60).floor();
  if (mins < 0) {
    return "Now";
  } else if (!(preciseNow ?? false) && mins <= 1) {
    return "Now";
  }
  return "$mins";
}

getTimeFromString(String t) {
  if (t.contains("T")) {
    var yymmdd = t.substring(0, t.indexOf("T"));
    var hhmmss = t.substring(t.indexOf("T") + 1);
    var hh = int.parse(hhmmss.substring(0, 2));
    if (hh != 12) {
      hh = hh % 12;
    }

    var yyyy = yymmdd.substring(0, 4);
    var mo = yymmdd.substring(5, 7);
    var dd = yymmdd.substring(8);

    var hs = hhmmss.substring(0, 2);
    var ms = hhmmss.substring(3, 5);
    var sss = hhmmss.substring(6, 8);

    return DateTime.parse("$yyyy-$mo-$dd $hs:$ms:$sss");
  } else {
    var yymmdd = t.substring(0, t.indexOf(" "));
    var hhmm = t.substring(t.indexOf(" ") + 1);
    var hh = int.parse(hhmm.substring(0, 2));
    if (hh != 12) {
      hh = hh % 12;
    }

    var yyyy = yymmdd.substring(0, 4);
    var mo = yymmdd.substring(4, 6);
    var dd = yymmdd.substring(6);

    var hs = hhmm.substring(0, 2);
    var ms = hhmm.substring(3, 5);

    return DateTime.parse("$yyyy-$mo-$dd $hs:$ms:00");
  }
}

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
