import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:ready_food/models/restaurant_model.dart';
import 'package:ready_food/pages/my_qr_code_page.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/restaurant_my_pedidos.dart';
import 'package:ready_food/widgets/restaurant_my_worker.dart';
import 'package:ready_food/widgets/restaurants_my_plates.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late RestaurantModel restaurantData;
  String restaurantName = 'ReadyFood';

  void loadrestaurantData() async {
    restaurantData = await currentRestaurantData();
    restaurantName =
        restaurantData.name != 'null' ? restaurantData.name : 'ReadyFood';
    setState(() {});
  }

  @override
  void initState() {
    loadrestaurantData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: HiddenDrawer(
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
            title: Text(restaurantName),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black54,
            bottom: const TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black45,
              indicatorColor: Color.fromRGBO(63, 63, 156, 1),
              tabs: [
                Tab(text: 'Mis pedidos'),
                Tab(text: 'Mis platos'),
                Tab(text: 'Mis trabajadores'),
              ],
            ),
          ),
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              RestaurantMyPedidos(),
              RestaurantMyPlates(),
              RestaurantMyWorker(),
            ],
          ),
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
              Icons.qr_code,
              color: Colors.white,
            ),
            title: const Text(
              'Código QR',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyQrCodePage(restaurantName: restaurantName),
                ),
              );
            },
          ),
          onPressed: () {},
        ),
        DrawerMenu(
          child: ListTile(
            leading: const Icon(
              Icons.bar_chart,
              color: Colors.white,
            ),
            title: const Text(
              'Analíticas',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'analitics');
            },
          ),
          onPressed: () {},
        ),
        DrawerMenu(
          child: ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            title: const Text(
              'Histórial',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'history');
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .2,
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
