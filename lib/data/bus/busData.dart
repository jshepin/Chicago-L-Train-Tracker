import 'dart:async';
import 'package:CTA_Tracker/data/train/trainData.dart';
import 'package:CTA_Tracker/pages/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import '../classes.dart';

Map<String, List<BusPrediction>> cachedBusPredictions = {};
Map<String, DateTime> lastBusPredictionsCall = {};
Map<String, bool> gotBusData = {};
Future<List<BusPrediction>> getBusPredictions(String stationID) async {
  bool isConnected = await checkConnection();
  List<BusPrediction> busPredictions = [];
  if (isConnected) {
    try {
      var diff = DateTime.now()
          .difference(lastBusPredictionsCall[stationID] ?? DateTime.now())
          .inSeconds;
      if (diff >= 20) {
        gotBusData.update(stationID, (value) {
          return false;
        }, ifAbsent: () => false);
      }

      if (cachedBusPredictions[stationID] != null && diff < 30) {
        return cachedBusPredictions[stationID];
      } else {
        if (!(gotBusData[stationID] ?? false)) {
          //if the data has not been fetched already
          List<String> favorites = await getSavedStations();
          List<String> busIds = [];
          for (var s in favorites) {
            if (s.contains("%BUS%")) {
              busIds.add(s.replaceAll("%BUS%", ""));
            }
          }
          if (!busIds.contains(stationID)) {
            busIds.add(stationID);
          }

          for (var id in busIds) {
            lastBusPredictionsCall.update(id, (value) {
              return DateTime.now();
            }, ifAbsent: () => DateTime.now());
            gotBusData.update(id, (value) {
              return true;
            }, ifAbsent: () => true);
          }

          for (var x = 0; x < 2; x++) {
            String idString = busIds.join(',');
            var url =
                '${ConfigReader.getServerURL()}/busPredictions?stpid=$idString&token=${ConfigReader.getAPIKEY()}';
            print("$url");
            var response = await http
                .get(url)
                .timeout(const Duration(seconds: 5), onTimeout: () {})
                .catchError((e) {
              return null;
            });

            Map<String, dynamic> data = jsonDecode(response.body);
            var errors = data["bustime-response"]["error"] ?? [];
            print("errors $errors");
            for (var e in errors) {
              String sid = e['stpid'].toString().replaceAll("\n", "");
              print("ERROR FOR ID $sid");
              if (sid.length > 0) {
                cachedBusPredictions.update(sid, (value) {
                  return [];
                }, ifAbsent: () => []);
              }

              lastBusPredictionsCall.update(sid, (value) {
                return DateTime.now();
              }, ifAbsent: () => DateTime.now());
            }
            var eta = data["bustime-response"]['prd'];
            if (eta == null) {}
            for (int x = 0; x < eta.length; x++) {
              var s = eta[x];
              cachedBusPredictions.remove(s["stpid"]);
            }
            for (int x = 0; x < eta.length; x++) {
              var s = eta[x];
              BusPrediction p = new BusPrediction(
                s["tmstmp"],
                s["typ"],
                s["stpnm"],
                s["stpid"],
                s["vid"],
                s["dstp"],
                s["rt"],
                s["rtdd"],
                s["rtdir"],
                s["des"],
                s["prdtm"],
                s["tablockid"],
                s["tatripid"],
                s["dly"],
                s["prdctdn"],
                s["zone"],
              );
              String staId = s["stpid"];
              List<BusPrediction> predictions =
                  cachedBusPredictions[staId] ?? [];
              predictions.add(p);
              cachedBusPredictions.update(staId, (value) {
                return predictions;
              }, ifAbsent: () => predictions);
            }
          }
        } else {}
      }
    } catch (e) {}

    return cachedBusPredictions[stationID] ?? [];
  } else {
    if (cachedBusPredictions[stationID] != null) {
      return cachedBusPredictions[stationID];
    } else {
      return busPredictions;
    }
  }
}

List<List<String>> splitArray(arr, len) {
  print("got arrayt $arr and arr length ${arr.length}");
  List<List<String>> chunks = [];
  if (arr.length <= len) {
    chunks.add(arr);
    print("size less than or equal to $len");
    return chunks;
  }
  int i = 0;
  int n = arr.length;
  while (i < n) {
    chunks.add(arr.sublist(i, i += len));
  }
  print("returning $chunks");
  return chunks;
}
