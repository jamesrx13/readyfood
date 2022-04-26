import 'package:chart_components/bar_chart_component.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/card_container.dart';

class ChartsBarPage extends StatefulWidget {
  final DataSnapshot allPedidosCompletados;
  const ChartsBarPage({Key? key, required this.allPedidosCompletados})
      : super(key: key);

  @override
  State<ChartsBarPage> createState() => _ChartsBarPageState();
}

class _ChartsBarPageState extends State<ChartsBarPage> {
  List<String> chartLabels = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  List<int> years = [];
  List<List<double>> chartValues = [];
  void _allYears() {
    for (var element in widget.allPedidosCompletados.children) {
      int yearTemp =
          DateTime.parse(element.child('dateEnd').value.toString()).year;
      if (!years.contains(yearTemp)) {
        years.add(yearTemp);
      }
    }
    setState(() {});
    _setDataByYear();
  }

  void _setDataByYear() {
    for (var year in years) {
      List<double> chartDataTemp = [];
      double enero = 0,
          febrero = 0,
          marzo = 0,
          abril = 0,
          mayo = 0,
          junio = 0,
          julio = 0,
          agosto = 0,
          septiembre = 0,
          octubre = 0,
          noviembre = 0,
          diciembre = 0;
      for (var pedido in widget.allPedidosCompletados.children) {
        DateTime pedidoEndTemp =
            DateTime.parse(pedido.child('dateEnd').value.toString());
        if (pedidoEndTemp.year == year) {
          switch (pedidoEndTemp.month) {
            case 1:
              enero++;
              break;
            case 2:
              febrero++;
              break;
            case 3:
              marzo++;
              break;
            case 4:
              abril++;
              break;
            case 5:
              mayo++;
              break;
            case 6:
              junio++;
              break;
            case 7:
              julio++;
              break;
            case 8:
              agosto++;
              break;
            case 9:
              septiembre++;
              break;
            case 10:
              octubre++;
              break;
            case 11:
              noviembre++;
              break;
            case 12:
              diciembre++;
              break;
          }
        }
      }
      chartDataTemp = [
        enero,
        febrero,
        marzo,
        abril,
        mayo,
        junio,
        julio,
        agosto,
        septiembre,
        octubre,
        noviembre,
        diciembre
      ];
      chartValues.add(chartDataTemp);
    }
  }

  @override
  void initState() {
    _allYears();
    super.initState();
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
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.black54,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const CardContainer(
                child: Center(
                  child: Text(
                    'Analíticas anuales',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: years.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Colors.white,
                        elevation: 10.0,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                child: Text(
                                  years[index].toString(),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: BarChart(
                                  labels: chartLabels,
                                  data: chartValues[index],
                                  displayValue: true,
                                  // reverse: true,
                                  getColor: _getChartColorByValue,
                                  getIcon: (value) => const Icon(
                                    Icons.arrow_drop_up_rounded,
                                    color: Colors.black38,
                                  ),
                                  barWidth:
                                      MediaQuery.of(context).size.width * .13,
                                  barSeparation:
                                      MediaQuery.of(context).size.width * .05,
                                  animationDuration:
                                      const Duration(milliseconds: 2000),
                                  animationCurve: Curves.easeInOutSine,
                                  itemRadius: 30,
                                  iconHeight: 24,
                                  footerHeight: 24,
                                  headerValueHeight: 16,
                                  roundValuesOnText: false,
                                  lineGridColor: Colors.lightBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getChartColorByValue(valueDay) {
    if (valueDay <= 5) {
      return Colors.redAccent;
    } else if (valueDay <= 10 && valueDay > 5) {
      return Colors.orangeAccent;
    } else if (valueDay <= 20 && valueDay > 10) {
      return Colors.blueAccent;
    } else {
      return Colors.green;
    }
  }
}
