import 'package:CTA_Tracker/common/train/predictionRow.dart';
import 'package:CTA_Tracker/common/train/predictions.dart';
import 'package:CTA_Tracker/data/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'busViewCard.dart';

class StopViewCard extends StatefulWidget {
  List<BusPrediction> predictions;
  bool reload;
  Stop stop;
  StopViewCard(this.predictions, this.stop, this.reload);
  @override
  _StopViewCardState createState() => _StopViewCardState();
}

class _StopViewCardState extends State<StopViewCard> {
  List<BusDirectionPrediction> getBusDestinationPredictions(
      List<BusPrediction> predictions, Stop station) {
    List<BusDirectionPrediction> busDirectionPredictions = [];
    busDirectionPredictions.add(new BusDirectionPrediction("All", predictions));
    for (var r in getBusDirections(predictions)) {
      List<BusPrediction> ps = [];
      for (var p in predictions) {
        if (p.rt == r) {
          ps.add(p);
        }
      }
      busDirectionPredictions.add(new BusDirectionPrediction(r, ps));
    }
    return busDirectionPredictions;
  }

  List<String> getBusDirections(List<BusPrediction> predictions) {
    List<String> routes = [];
    for (var p in predictions) {
      if (!routes.contains(p.rt)) {
        routes.add(p.rt);
      }
    }
    return routes;
  }

  List<BusDirectionPrediction> busDPredictions = [];
  List<String> directions = [];
  int busSelected = 0;
  bool busChanged = false;
  @override
  Widget build(BuildContext context) {
    // fetchAlerts(widget.stop.id);
    busDPredictions =
        getBusDestinationPredictions(widget.predictions, widget.stop);
    directions = getBusDirections(widget.predictions);
    directions.insert(0, "All");
    return Container(
      child: SingleChildScrollView(
          child: Column(
        children: [
          if (busDPredictions.length > 1) ...[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  directions[busSelected] == 'All'
                      ? 'All Routes'
                      : "Route #${directions[busSelected]}",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "No predictions right now",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
          busDPredictions.length > 2
              ? Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width),
                  height: 200,
                  child: new Swiper(
                    index: busSelected,
                    key: ValueKey(busSelected),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (BusPrediction p
                                  in busDPredictions[index].busPredictions) ...[
                                BusViewCard(
                                  busSelected,
                                  prediction: p,
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                    onIndexChanged: (i) {
                      setState(() {
                        busChanged = true;
                        busSelected = i;
                      });
                    },
                    itemCount: busDPredictions.length,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      for (BusPrediction p
                          in busDPredictions[0].busPredictions) ...[
                        BusViewCard(busSelected, prediction: p),
                      ]
                    ],
                  ),
                ),
          if (busDPredictions.length > 2)
            HDots(
              busSelected,
              busDPredictions: busDPredictions,
            )
        ],
      )),
    );
  }
}
