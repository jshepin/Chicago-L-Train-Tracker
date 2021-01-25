import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:CTA_Tracker/exports.dart';

class MapStationCard extends StatelessWidget {
  Station selectedStation;
  MapStationCard(this.selectedStation);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          height: 70,
          constraints: BoxConstraints(maxWidth: 430),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: isDark(context)
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.21),
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ],
              color: getPrimary(context),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
                    child: Text(
                      selectedStation.name,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: selectedStation.name.length > 19 ? 20 : 25),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                        ),
                        for (var color in selectedStation.lines) ...[
                          Tooltip(
                            message: showDashed(color, selectedStation)
                                ? "Purple Express"
                                : "$color Line",
                            child: Padding(
                              padding: showDashed(color, selectedStation)
                                  ? EdgeInsets.only(left: 4, right: 4)
                                  : EdgeInsets.only(left: 0),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                dashPattern: [7, 4.5],
                                radius: Radius.circular(100),
                                color: (showDashed(color, selectedStation)
                                    ? colorFromLine(color, context)
                                    : Colors.transparent),
                                strokeWidth: 3,
                                child: Container(
                                  height: showDashed(color, selectedStation)
                                      ? 21
                                      : 25,
                                  width: showDashed(color, selectedStation)
                                      ? 21
                                      : 25,
                                  decoration: BoxDecoration(
                                      color: showDashed(color, selectedStation)
                                          ? Colors.transparent
                                          : colorFromLine(color, context),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Center(
                                      child: Text(
                                    color.substring(0, 1),
                                    style: TextStyle(
                                        color: showDashed(
                                                color, selectedStation)
                                            ? (isDark(context)
                                                ? Colors.white
                                                : colorFromLine(color, context))
                                            : Colors.white,
                                        fontSize: ((color == "Purple" &&
                                                    getPurpleExpressIds()
                                                        .contains(
                                                            selectedStation
                                                                .id)) ||
                                                (selectedStation.pexp != null &&
                                                    selectedStation.pexp))
                                            ? 15
                                            : 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AccessiblilityRow(
                    selectedStation,
                    showAll: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
