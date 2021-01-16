import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CTA_Tracker/exports.dart';

class Welcome extends StatefulWidget {
  int index;
  Welcome(this.index);
  @override
  _WelcomeState createState() => _WelcomeState(index);
}

class _WelcomeState extends State<Welcome> {
  int index;
  _WelcomeState(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80,
              ),
              Container(
                height: 550,
                child: Swiper(
                    index: index,
                    key: ValueKey(index),
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          child: Image.asset("assets/welcome/$index.png",
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.contain));
                    },
                    onIndexChanged: (i) async {
                      // print("index is $index and I is  $i");
                      if (!((index == 0 && i == 4) ||
                          (index == 1 && i == 0) ||
                          (index == 0 && i == 0))) {
                        if (i == 0) {
                          await setWelcomeShown(true);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 50),
                                  child: Home()));
                        }
                        setState(() {
                          index = i;
                        });
                      } else {
                        setState(() {
                          index = 0;
                        });
                      }
                    }),
              ),
              Container(
                height: 20,
              ),
              Container(
                width: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    for (var x = 0; x < 5; x++) ...[
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: index == x ? Colors.grey : Colors.grey[350],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      )
                    ]
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> getWelcomeShown() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("welcomeShown") ?? false;
}

Future<void> setWelcomeShown(bool s) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("welcomeShown", s);
}
