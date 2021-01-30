import 'dart:math';
import 'package:CTA_Tracker/data/train/station_data.dart';
import 'package:CTA_Tracker/pages/lines/lines.dart';
import 'package:geolocator/geolocator.dart';
import '../classes.dart';

double calculateDistance(Station station, List<Station> stations) {
  var index = stations.indexOf(station);

  double lat1 = station.lat;
  double lon1 = station.long;

  double lat2 = stations[index + 1].lat;
  double lon2 = stations[index + 1].long;
  double theta = lon1 - lon2;
  double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
  dist = acos(dist);
  dist = rad2deg(dist);
  dist = dist * 60 * 1.1515;

  return dist;
}

double deg2rad(double deg) {
  return (deg * pi / 180.0);
}

double rad2deg(double rad) {
  return (rad * 180.0 / pi);
}

Future<List<StationWithDistance>> findClosestStation() async {
  List<StationWithDistance> s = [];
  try {
    List<Station> stations = getStationData();
    List<Stop> stops = getStops();
    Position position = await getLastKnownPosition();
    var lat = position.latitude ?? 0;
    var lon = position.longitude ?? 0;
    List<double> distances = [];
    List<double> stopDistances = [];

    for (var x = 0; x < stops.length; x++) {
      double lat1 = lat;
      double lon1 = lon;

      double lat2 = stops[x].lat;
      double lon2 = stops[x].lon;
      double theta = lon1 - lon2;
      double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
          cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
      dist = acos(dist);
      dist = rad2deg(dist);
      dist = dist * 60 * 1.1515;

      stopDistances.add(dist);
    }

    for (var x = 0; x < stations.length; x++) {
      double lat1 = lat;
      double lon1 = lon;

      double lat2 = stations[x].lat;
      double lon2 = stations[x].long;
      double theta = lon1 - lon2;
      double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
          cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
      dist = acos(dist);
      dist = rad2deg(dist);
      dist = dist * 60 * 1.1515;

      distances.add(dist);
    }
    var smallest = 10000000.00;
    var smallestIndex = 0;
    var smallestStopDist = 10000000.00;
    var smallestStopIndex = 0;

    for (int x = 0; x < distances.length; x++) {
      if (distances[x] < smallest) {
        smallest = distances[x];
        smallestIndex = x;
      }
    }

    for (int x = 0; x < stopDistances.length; x++) {
      if (stopDistances[x] < smallestStopDist) {
        smallestStopDist = stopDistances[x];
        smallestStopIndex = x;
      }
    }

    if (smallest <= 10) {
      s.add(new StationWithDistance(smallest.toStringAsFixed(2) ?? "",
          station: stations[smallestIndex]));
    }
    if (smallestStopDist <= 10) {
      s.add(new StationWithDistance(smallest.toStringAsFixed(2) ?? "",
          stop: stops[smallestStopIndex]));
    }

    return s;
  } catch (e) {
    return null;
  }
}
