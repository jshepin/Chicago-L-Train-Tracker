import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

List<BusRoute> getItems(List<BusRoute> s, query) {
  List<BusRoute> routes = [];
  for (BusRoute route in s) {
    if (queryContains(route.id, query) || queryContains(route.longName, query)) {
      routes.add(route);
    }
  }
  return routes;
}

List<Result> getResults(trains, busses, query) {
  List<Result> results = [];

  List<Station> stations = [];
  for (Station station in trains) {
    if (queryContains(station.name, query) || queryContains(station.id, query)) {
      stations.add(station);
    }
  }

  List<BusRoute> routes = [];
  for (BusRoute route in busses) {
    if (queryContains(route.id, query) || queryContains(route.longName, query)) {
      routes.add(route);
    }
  }

  List<Stop> stopsData = getStops();
  List<Stop> stops = [];
  for (Stop s in stopsData) {
    if (queryContains(s.name, query) || queryContains(s.id, query)) {
      stops.add(s);
    }
  }

  List<Result> a =
      stations.map((e) => new Result("", e.name, 1, e, icon: Icons.train, lines: e.lines)).toList();
  List<Result> b = routes.map((e) => new Result(e.id, e.longName, 2, e)).toList();
  List<Result> c =
      stops.map((e) => new Result("", e.name, 3, e, icon: Icons.directions_bus)).toList();
  for (var x in a) {
    results.add(x);
  }
  for (var x in b) {
    results.add(x);
  }
  for (var x in c) {
    results.add(x);
  }

  return results;
}

bool queryContains(String option, String query) {
  if (query.length == 0) {
    return true;
  }
  option = option.toLowerCase();
  query = query.toLowerCase();
  return option.contains(query);
}
