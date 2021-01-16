import 'package:CTA_Tracker/pages/bus/stopView.dart';
import 'package:CTA_Tracker/pages/lines/search/searchData.dart';
import 'package:CTA_Tracker/pages/train/station_view.dart';
import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class DataSearch extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          size: 30,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: IconButton(
          icon: Icon(
            // progress: null,
            Icons.arrow_back_ios, size: 30,
          ),
          onPressed: () {
            close(context, null);
          }),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.red,
            hintStyle: TextStyle(color: theme.primaryTextTheme.title.color)),
        textTheme: theme.textTheme.copyWith(
            title: theme.textTheme.title
                .copyWith(color: theme.primaryTextTheme.title.color)));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<BusRoute> suggestionList = getBusRoutes();
    List<Station> stations = getStationData();
    List<Result> results = getResults(stations, suggestionList, query);
    return GetSearchResult(results: results, stations: stations);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<BusRoute> suggestionList = getBusRoutes();
    List<Station> stations = getStationData();
    List<Result> results = getResults(stations, suggestionList, query);
    return GetSearchResult(results: results, stations: stations);
  }
}

class GetSearchResult extends StatelessWidget {
  const GetSearchResult({
    Key key,
    @required this.results,
    @required this.stations,
  }) : super(key: key);

  final List<Result> results;
  final List<Station> stations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, i) => ListTile(
        onTap: () {
          if (results[i].itemType == 1) {
            //if it's a train station
            print("opening train station");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Station_view(results[i].passData,
                      stations, getLines()[0], Colors.red, false)),
            );
          } else if (results[i].itemType == 2) {
            print("opening bus route view");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RouteView(results[i].passData)),
            );
          } else {
            print("opening stop  view");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Stop_view(results[i].passData, false)),
            );
          }
        },
        leading: Container(
          child: results[i].icon != null
              ? Icon(
                  results[i].icon,
                )
              : Text(results[i].leading),
        ),
        title: Text(results[i].title, style: TextStyle(fontSize: 19)),
        trailing: results[i].lines == null
            ? Text("")
            : Container(
                width: 135,
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (String line in results[i].lines) ...[
                      Container(
                        margin: EdgeInsets.only(right: 4),
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: colorFromLine(line, context),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
      ),
    );
  }
}
