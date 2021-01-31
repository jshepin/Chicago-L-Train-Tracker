import 'package:flutter/material.dart';

class BusRoute {
  String id;
  String longName;
  String routeType;
  BusRoute(this.id, this.longName, this.routeType);
}

class StationWithDistance {
  Station station;
  Stop stop;
  bool isBus;
  String distance;
  StationWithDistance(this.distance, {station, stop}) {
    if (station != null) {
      this.isBus = false;
      this.station = station;
    } else if (stop != null) {
      this.stop = stop;
      this.isBus = true;
    }
  }
}

class Line {
  String note;
  String name;
  Color color;
  bool loops;
  Color darkColor;
  Color darkText;
  String displayName;

  Line(name, displayName, color, darkColor, darkText, {this.note, this.loops}) {
    this.name = name;
    this.displayName = displayName;
    this.darkText = Color(int.parse(darkText.substring(0, 6), radix: 16) + 0xFF000000);
    this.color = Color(int.parse(color.substring(0, 6), radix: 16) + 0xFF000000);
    this.darkColor = Color(int.parse(darkColor.substring(0, 6), radix: 16) + 0xFF000000);
  }
}

class Station {
  String note;
  String id;
  String name;
  List<String> lines;
  double lat;
  double long;
  bool ada;
  bool parking;
  bool isAirport;
  bool pexp;
  Station(id, name, lines, lat, long, this.ada, this.parking,
      {this.note, this.isAirport, this.pexp}) {
    this.id = id;
    this.name = name;
    this.lines = lines;
    this.lat = double.parse(lat);
    this.long = double.parse(long);
  }
}

class BusPrediction {
  String tmstmp;
  String typ;
  String stpnm;
  String stpid;
  String vid;
  int dstp;
  String rt;
  String rtdd;
  String rtdir;
  String des;
  String prdtm;
  String tablockid;
  String tatripid;
  bool dly;
  String prdctdn;
  String zone;

  BusPrediction(
      this.tmstmp,
      this.typ,
      this.stpnm,
      this.stpid,
      this.vid,
      this.dstp,
      this.rt,
      this.rtdd,
      this.rtdir,
      this.des,
      this.prdtm,
      this.tablockid,
      this.tatripid,
      this.dly,
      this.prdctdn,
      this.zone);
}

class Prediction {
  String tmst;
  String staId;
  String stpId;
  String staNm;
  String stpDe;
  String rn;
  String rt;
  String destSt;
  String destNm;
  String trDr;
  String prdt;
  String arrT;
  String isApp;
  String isSch;
  String isDly;
  String isFlt;
  String flags;
  String lat;
  String lon;
  String heading;
  Prediction(
      this.tmst,
      this.staId,
      this.stpId,
      this.staNm,
      this.stpDe,
      this.rn,
      this.rt,
      this.destSt,
      this.destNm,
      this.trDr,
      this.prdt,
      this.arrT,
      this.isApp,
      this.isSch,
      this.isDly,
      this.isFlt,
      this.flags,
      this.lat,
      this.lon,
      this.heading);
}

class Service {
  String type;
  String description;
  String name;
  String id;
  String backColor;
  String textColor;
  Service(this.type, this.description, this.name, this.id, this.backColor, this.textColor);
}

class Alert {
  String id;
  String headline;
  String shortDescription;
  int severityScore;
  String severityColor;
  String eventStart;
  String eventEnd;
  bool tbd;
  bool majorAlert;
  List<Service> impactedServices;
  Alert(this.id, this.headline, this.shortDescription, this.severityScore, this.severityColor,
      this.eventStart, this.eventEnd, this.tbd, this.majorAlert, this.impactedServices);
}

class LineLocations {
  String name;
  List<Location> locations;
  LineLocations(this.name, this.locations);
}

class Location {
  String rn;
  String destSt;
  String destNm;
  String trDr;
  String nextStaId;
  String nextStpId;
  String nextStaNm;
  String prdt;
  String arrT;
  String isApp;
  String isDly;
  String flags;
  String lat;
  String lon;
  String heading;
  Location(
      this.rn,
      this.destSt,
      this.destNm,
      this.trDr,
      this.nextStaId,
      this.nextStpId,
      this.nextStaNm,
      this.prdt,
      this.arrT,
      this.isApp,
      this.isDly,
      this.flags,
      this.lat,
      this.lon,
      this.heading);
}

class Result {
  String leading;
  String title;
  List<String> lines;
  IconData icon;
  int itemType; //0 for train line, 1 for train station, 2 for bus line, 3 for bus station
  var passData;
  Result(this.leading, this.title, this.itemType, this.passData, {this.lines, this.icon});
}

class Stop {
  String id;
  String code;
  String name;
  String desc;
  double lat;
  double lon;
  String locationType;
  String parent;
  bool isAda;
  Stop(this.id, this.code, this.name, this.desc, this.lat, this.lon, this.locationType, this.parent,
      this.isAda);
}
