import 'package:chart_components/bar_chart_component.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/pages/chat_bar_page.dart';
import 'package:ready_food/pages/plates_analitics_page.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/widgets.dart';

class AnaliticPage extends StatefulWidget {
  const AnaliticPage({Key? key}) : super(key: key);

  @override
  State<AnaliticPage> createState() => _AnaliticPageState();
}

class _AnaliticPageState extends State<AnaliticPage> {
  List<PlateModel> allPlates = [];
  PlateModel moreSoldPlate = PlateModel(
    id: '',
    description: '',
    imageUrl: '',
    name: '',
    countSold: 0,
    price: 0,
    hasStock: false,
    isSpecial: false,
  );
  int allSoldCountPlate = 0;
  int soldCountPlate = 0;
  int pedidosRechazados = 0, pedidosCompletados = 0;
  List<String> dayOfTheWeek = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo',
  ];
  List<double> dataofTable = [];
  late DataSnapshot allPedidosCompletados;

  void getDataAllPlates() async {
    DateTime today = DateTime.now();
    DatabaseReference allPlatesRef = FirebaseDatabase.instance
        .ref('restaurants/$currentUserId/pedidosFinalizados');
    DataSnapshot allPlatesSnapshot = await allPlatesRef.get();
    for (var pedido in allPlatesSnapshot.children) {
      DateTime dateEndPedidoTemp =
          DateTime.parse(pedido.child('dateEnd').value.toString());
      if (dateEndPedidoTemp.year == today.year &&
          dateEndPedidoTemp.month == today.month &&
          dateEndPedidoTemp.day == today.day) {
        pedido.child('platesOfPedido').children.forEach(
          (element) {
            PlateModel temPlate = PlateModel(
              id: element.key.toString(),
              countSold:
                  int.parse(element.child('plateCount').value.toString()),
              description: element.child('plateDescription').value.toString(),
              hasStock: element.child('hasStock').value as bool,
              imageUrl: element.child('plateImageUrl').value.toString(),
              isSpecial: element.child('isSpecial').value as bool,
              name: element.child('plateName').value.toString(),
              price: int.parse(element.child('platePrice').value.toString()),
            );
            allPlates.add(temPlate);
          },
        );
      }
    }
    Map tempMap = {};
    for (var plato in allPlates) {
      if (tempMap.containsKey(plato.id)) {
        tempMap.update(plato.id, (value) => value += plato.countSold);
      } else {
        tempMap.addAll({plato.id: plato.countSold});
      }
    }
    int comparevalue = 1;
    String idPlate = '';
    tempMap.forEach((key, value) {
      if (value > comparevalue) {
        comparevalue = value;
        soldCountPlate = value as int;
        idPlate = key;
      }
      allSoldCountPlate += value as int;
    });
    for (var element in allPlates) {
      if (element.id == idPlate) {
        moreSoldPlate = element;
      }
    }

    setState(() {});
  }

  void getPediosData() async {
    DataSnapshot pedidosRechazadosRef = await FirebaseDatabase.instance
        .ref('restaurants/$currentUserId/pedidosRechazados')
        .get();
    DataSnapshot pedidosCompletadosRef = await FirebaseDatabase.instance
        .ref('restaurants/$currentUserId/pedidosFinalizados')
        .get();
    pedidosRechazados =
        pedidosRechazadosRef.exists ? pedidosRechazadosRef.children.length : 0;
    pedidosCompletados = pedidosCompletadosRef.exists
        ? pedidosCompletadosRef.children.length
        : 0;
    allPedidosCompletados = pedidosCompletadosRef;
    insertDataToChart(pedidosCompletadosRef);
    setState(() {});
  }

  void insertDataToChart(DataSnapshot complitePedido) {
    DateTime now = DateTime.now();
    int weekDay = now.weekday;
    double lunes = 0,
        martes = 0,
        miercoles = 0,
        jueves = 0,
        viernes = 0,
        sabado = 0,
        domingo = 0;
    DateTime initWeek = now.subtract(Duration(days: (weekDay - 1)));
    for (var i = 0; i < weekDay; i++) {
      DateTime dayCurrentWeekTemp = initWeek.add(Duration(days: i));
      for (var element in complitePedido.children) {
        DateTime timeTemp =
            DateTime.parse(element.child('dateEnd').value.toString());
        if (now.year == timeTemp.year) {
          if (dayCurrentWeekTemp.month == timeTemp.month &&
              dayCurrentWeekTemp.day == timeTemp.day) {
            switch (i) {
              case 0:
                lunes++;
                break;
              case 1:
                martes++;
                break;
              case 2:
                miercoles++;
                break;
              case 3:
                jueves++;
                break;
              case 4:
                viernes++;
                break;
              case 5:
                sabado++;
                break;
              case 6:
                domingo++;
                break;
            }
          }
        }
      }
    }
    dataofTable = [lunes, martes, miercoles, jueves, viernes, sabado, domingo];
    setState(() {});
  }

  @override
  void initState() {
    getDataAllPlates();
    getPediosData();
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
                height: 15.0,
              ),
              const CardContainer(
                child: Center(
                  child: Text(
                    'Analíticas',
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _indicator('Plato más vendido hoy'),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.white,
                          elevation: 10.0,
                          child: allPlates.isNotEmpty
                              ? SizedBox(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width * .9,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 150,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                          ),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'lib/img/loading.gif',
                                            image: moreSoldPlate.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5.0,
                                          top: 15.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: Text(
                                                moreSoldPlate.name,
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                moreSoldPlate.price.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                'Vendido: $soldCountPlate',
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      CircularPercentIndicator(
                                        radius: 60.0,
                                        lineWidth: 10.0,
                                        center: Text(
                                            '${((soldCountPlate * 100) / allSoldCountPlate).round()}%'),
                                        animation: true,
                                        progressColor: GLOBAL_COLOR,
                                        percent:
                                            soldCountPlate / allSoldCountPlate,
                                      ),
                                      Center(
                                        child: IconButton(
                                          iconSize: 30.0,
                                          icon: const Icon(
                                              Icons.arrow_forward_ios),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        PlatesAnaliticPage(
                                                          allPlates: allPlates,
                                                          allSoldCountPlate:
                                                              allSoldCountPlate,
                                                        )));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 150,
                                  child: Center(
                                    child: Text('Sin registro de platos!'),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _indicator('Pedidos'),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.white,
                          elevation: 10.0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .9,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Completados',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CircularPercentIndicator(
                                        footer:
                                            Text(pedidosCompletados.toString()),
                                        radius: 60.0,
                                        lineWidth: 10.0,
                                        center: (pedidosRechazados +
                                                    pedidosCompletados) !=
                                                0
                                            ? Text(
                                                '${(pedidosCompletados * 100 / (pedidosRechazados + pedidosCompletados)).round()}%')
                                            : const Text('0'),
                                        animation: true,
                                        progressColor: Colors.green,
                                        percent: pedidosCompletados /
                                            (pedidosRechazados +
                                                pedidosCompletados),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                      Center(
                                        child: Text(
                                          (pedidosRechazados +
                                                  pedidosCompletados)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Rechazados',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CircularPercentIndicator(
                                        footer:
                                            Text(pedidosRechazados.toString()),
                                        radius: 60.0,
                                        lineWidth: 10.0,
                                        center: (pedidosRechazados +
                                                    pedidosCompletados) !=
                                                0
                                            ? Text(
                                                '${(pedidosRechazados * 100 / (pedidosRechazados + pedidosCompletados)).round()}%')
                                            : const Text('0'),
                                        animation: true,
                                        progressColor: Colors.redAccent,
                                        percent: pedidosRechazados /
                                            (pedidosRechazados +
                                                pedidosCompletados),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _indicator('Pedidos en esta semana'),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.white,
                          elevation: 10.0,
                          child: SizedBox(
                            height: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BarChart(
                                labels: dayOfTheWeek,
                                data: dataofTable,
                                displayValue: true,
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
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChartsBarPage(
                                        allPedidosCompletados:
                                            allPedidosCompletados)));
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Center(
                              child: Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Ver más',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _indicator(String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Center(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          )
        ],
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
