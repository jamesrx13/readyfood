import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ready_food/models/worker_model.dart';
import 'package:ready_food/pages/worker_my_profile.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/plates_list_widgets.dart';
import 'package:ready_food/widgets/special_day_widget.dart';
import 'package:ready_food/widgets/worker_pedido.dart';
import 'package:ready_food/widgets/worker_pedidos_complite.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({Key? key}) : super(key: key);

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String restaurantName = '';
  String restaurantId = '';
  late WorkerModel workerData;
  void getWorkerData() async {
    workerData = await currentWorkerData();
    restaurantName = workerData.restaurantName != 'null'
        ? workerData.restaurantName
        : 'ReadyFood';
    restaurantId = workerData.restaurantId;
    setState(() {});
  }

  @override
  void initState() {
    getWorkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return HiddenDrawer(
      drawerHeaderHeight: MediaQuery.of(context).size.height * .3,
      drawerWidth: MediaQuery.of(context).size.width * .4,
      drawer: _hiddenDrawer(),
      child: Scaffold(
        appBar: AppBar(
          leading: HiddenDrawerIcon(
            mainIcon: const Icon(
              Icons.menu,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.black54,
          title: Text(
            restaurantName,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (restaurantId != '')
                              ? SpecialDayWidget(restaurantId: restaurantId)
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: (restaurantId != '')
                    ? PlatesListWidget(restaurantAssocId: restaurantId)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          child: const Icon(Icons.more_horiz_sharp),
          closedForegroundColor: Colors.white,
          openForegroundColor: Colors.black,
          closedBackgroundColor: GLOBAL_COLOR,
          openBackgroundColor: Colors.white,
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              child: const Icon(Icons.shopping_cart),
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigoAccent,
              label: 'Pedido',
              closeSpeedDialOnPressed: true,
              onPressed: () {
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      WorkerMyPedido(assocrestaurantId: restaurantId),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.check),
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              label: 'Pedidos completados',
              closeSpeedDialOnPressed: true,
              onPressed: () {
                showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      WorkerPedidosComplite(restaurantId: restaurantId),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _hiddenDrawer() {
    return HiddenDrawerMenu(
      drawerDecoration: BoxDecoration(
        color: GLOBAL_COLOR,
        gradient: const LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 190, 0.7)
        ]),
      ),
      menuActiveColor: Colors.transparent,
      menu: <DrawerMenu>[
        DrawerMenu(
          child: ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: const Text(
              'Mi perfil',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyProfileWorker(worker: workerData),
                ),
              );
            },
          ),
          onPressed: () {},
        ),
        DrawerMenu(
          child: ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () async {
              showDialog<void>(
                context: context,
                builder: (_) => _buildAlertDialog(),
              );
            },
          ),
          onPressed: () {},
        ),
      ],
      header: const Padding(
        padding: EdgeInsets.only(
          left: 15.0,
        ),
        child: Text(
          "ReadyFood",
          style: TextStyle(
            fontSize: 25.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Proyecto de grado.",
              style: TextStyle(
                fontSize: 15.0,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "James Rudas",
              style: TextStyle(
                fontSize: 10.0,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            Text(
              "Dario Gaviria",
              style: TextStyle(
                fontSize: 10.0,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            Text(
              "Juan Bueno",
              style: TextStyle(
                fontSize: 10.0,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: const Text('¿Está seguro de cerrar sesión?'),
      content: const Text("Pulse aceptar para terminar con su sesión actual."),
      actions: <Widget>[
        TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        TextButton(
            child: const Text("Aceptar"),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'start', (route) => false);
            }),
      ],
    );
  }
}
