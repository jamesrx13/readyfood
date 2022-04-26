import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/widgets/card_container.dart';

class PlatesAnaliticPage extends StatefulWidget {
  final List<PlateModel> allPlates;
  final int allSoldCountPlate;
  const PlatesAnaliticPage(
      {Key? key, required this.allPlates, required this.allSoldCountPlate})
      : super(key: key);

  @override
  State<PlatesAnaliticPage> createState() => _PlatesAnaliticPageState();
}

class _PlatesAnaliticPageState extends State<PlatesAnaliticPage> {
  List<MaterialAccentColor> colors = [
    Colors.amberAccent,
    Colors.blueAccent,
    Colors.redAccent,
    Colors.indigoAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
    Colors.deepOrangeAccent,
    Colors.purpleAccent,
  ];
  Random rnd = Random();
  List<PlateModel> newlistPlates = [];

  void newList() {
    Map tempMap = {};
    for (var plato in widget.allPlates) {
      if (tempMap.containsKey(plato.id)) {
        tempMap.update(plato.id, (value) => value += plato.countSold);
      } else {
        tempMap.addAll({plato.id: plato.countSold});
      }
    }
    tempMap.forEach((key, value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1)
        ])),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              const CardContainer(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      'Ventas de hoy',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              CardContainer(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .7,
                  child: widget.allPlates.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.allPlates.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.allPlates[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7.0,
                                      ),
                                      Text(
                                        widget.allPlates[index].price
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CircularPercentIndicator(
                                    center: Text(
                                        '${((widget.allPlates[index].countSold * 100) / widget.allSoldCountPlate).round()}%'),
                                    radius: 45.0,
                                    progressColor:
                                        colors[rnd.nextInt(colors.length)],
                                    animation: true,
                                    percent: widget.allPlates[index].countSold /
                                        widget.allSoldCountPlate,
                                    lineWidth: 7.0,
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('Sin platos'),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
