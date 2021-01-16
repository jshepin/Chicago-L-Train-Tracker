import 'dart:async';
import 'dart:developer';
import 'package:CTA_Tracker/data/train/trainData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import 'classes.dart';

bool gotAlerts = false;

Future<List<Alert>> getAlerts(String line) async {
  //get predictions based on mapid
  bool isConnected = await checkConnection();
  List<Alert> parsedAlerts = [];

  if (isConnected) {
    try {
      if (cachedAlerts.length != 0) {
        return getAlertsFromLine(cachedAlerts, line);
      }

      if (!gotAlerts) {
        var url =
            '${ConfigReader.getServerURL()}/alerts?token=${ConfigReader.getAPIKEY()}';
        var response = await http
            .get(url)
            .timeout(const Duration(seconds: 5), onTimeout: () {})
            .catchError((e) {
          return null;
        });

        Map<String, dynamic> data = jsonDecode(response.body);
        var alerts = data["Alert"];
        for (var x = 0; x < alerts.length; x++) {
          List<Service> impactedServices = [];
          var a = alerts[x];
          for (int y = 0; y < a["ImpactedService"].length; y++) {
            var v = a["ImpactedService"][y];
            impactedServices.add(new Service(
                v["ServiceType"],
                v["ServiceTypeDescription"],
                v["ServiceName"],
                v["ServiceId"],
                v["ServiceBackColor"],
                v["ServiceTextColor"]));
          }
          Alert alert = new Alert(
              a["AlertId"],
              a["Headline"],
              a["ShortDescription"],
              int.parse(a["SeverityScore"]),
              a["SeverityColor"],
              a["EventStart"],
              a["EventEnd"],
              (a["TBD"] == "1"),
              (a["MajorAlert"] == "1"),
              impactedServices);
          parsedAlerts.add(alert);
        }
        cachedAlerts = parsedAlerts;
      }
      return getAlertsFromLine(cachedAlerts, line) ?? [];
    } catch (e) {}

    return getAlertsFromLine(cachedAlerts, line) ?? [];
  } else {
    return [];
  }
}
