import 'package:CTA_Tracker/data/bus/allBusRoutes.dart';
import '../classes.dart';

List<BusRoute> getBusRoutes() {
  var csvTable = routes();

  return csvTable
      .map((e) =>
          new BusRoute(e[0].toString(), e[1].toString(), e[2].toString()))
      .toList();
}
