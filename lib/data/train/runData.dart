import 'dart:async';
import 'package:CTA_Tracker/data/train/trainData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:CTA_Tracker/exports.dart';

DateTime lastPredictionsCall = DateTime.now();

Future<List<TrainRunPrediction>> getRunData(String run) async {
  //get predictions based on mapid
  bool isConnected = await checkConnection();

  if (isConnected) {
    try {
      if (true) {
        var url =
            '${ConfigReader.getServerURL()}/trainRunData?run=$run&key=${ConfigReader.getAPIKEY()}';
        var response = await http
            .get(url)
            .timeout(const Duration(seconds: 5), onTimeout: () {})
            .catchError((e) {
          return null;
        });

        Map<String, dynamic> data = jsonDecode(response.body);
        var eta = data["ctatt"]['eta'];
        var errorCd = data['ctatt']['errCd'];
        if (errorCd != "0") {
          return [];
        }
        List<TrainRunPrediction> predictions = [];
        for (int x = 0; x < eta.length; x++) {
          var s = eta[x];
          TrainRunPrediction p = new TrainRunPrediction(
              s["staId"],
              s["stpId"],
              s["staNm"],
              s["stpDe"],
              s["rn"],
              s['rt'],
              s["destSt"],
              s["destNm"],
              s["trDr"],
              s["prdt"],
              s["arrT"],
              s["isApp"],
              s["isSch"],
              s["isDly"],
              s["isFlt"]);
          predictions.add(p);
        }
        return predictions;
      }
    } catch (e) {}
  }
}
