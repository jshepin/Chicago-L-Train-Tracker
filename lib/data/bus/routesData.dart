import 'package:CTA_Tracker/data/train/trainData.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';

class StopPreview {
  String id;
  String name;
  double lat;
  double lon;
  StopPreview(this.id, this.name, this.lat, this.lon);
}

class RouteData {
  List<StopPreview> stops;
  String direction;
  List<String> directions;
  RouteData(this.direction, this.stops, this.directions);
}

Map<String, List<RouteData>> cachedStops = {};
Future<List<RouteData>> getStopsFromID(String id) async {
  //get predictions based on mapid
  if (cachedStops[id] != null) {
    return cachedStops[id];
  }
  print("getting stops from server");
  bool isConnected = await checkConnection();

  if (isConnected) {
    try {
      if (true) {
        var url =
            '${ConfigReader.getServerURL()}/stops?id=$id&token=${ConfigReader.getAPIKEY()}';
        var response = await http
            .get(url)
            .timeout(const Duration(seconds: 5), onTimeout: () {})
            .catchError((e) {
          return null;
        });
        Map<String, dynamic> data = jsonDecode(response.body);
        List<StopPreview> previews = [];
        List<RouteData> rData = [];

        print("stops length is ${data['stops'].length}");

        for (var y = 0; y < data['stops'].length; y++) {
          previews = [];
          //for each direction
          var stops = data["stops"][y];
          stops = stops["stops"]["stops"];
          for (var x = 0; x < stops.length; x++) {
            //for each stop
            var s = stops[x];
            StopPreview stop =
                new StopPreview(s["stpid"], s["stpnm"], s["lat"], s["lon"]);
            previews.add(stop);
          }
          List<String> directions = [];
          for (var d = 0; d < data['directions'].length; d++) {
            directions.add(data['directions'][d]);
          }
          rData.add(new RouteData(
              data['stops'][y]['dir'].toString(), previews, directions));
        }

        cachedStops.update(id, (value) {
          return rData;
        }, ifAbsent: () => rData);
      }
      return cachedStops[id];
    } catch (e) {
      print(e.toString());
    }
    return cachedStops[id] ?? [];
  } else {
    return [];
  }
}
