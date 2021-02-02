import 'package:CTA_Tracker/data/bus/allBusRoutes.dart';
import '../classes.dart';

var cachedCSV;
List<BusRoute> getBusRoutes() {
  if (cachedCSV == null) {
    var csvTable = routes();
    cachedCSV = csvTable
        .map((e) => new BusRoute(e[0].toString(), e[1].toString(), e[2].toString()))
        .toList();
  }
  return cachedCSV;
}
