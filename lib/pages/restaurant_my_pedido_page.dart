import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/orders_model.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/models/worker_model.dart';
import 'package:ready_food/pages/plate_info_page.dart';
import 'package:ready_food/pages/restaurant_worker_profile.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/utils/progress_dialog.dart';
import 'package:ready_food/widgets/card_container.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../utils/add_pedido.dart';

class RestaurantMyPedidoPage extends StatefulWidget {
  final OrderModel pedido;
  const RestaurantMyPedidoPage({Key? key, required this.pedido})
      : super(key: key);

  @override
  State<RestaurantMyPedidoPage> createState() => _RestaurantMyPedidoPageState();
}

class _RestaurantMyPedidoPageState extends State<RestaurantMyPedidoPage> {
  late WorkerModel worker;
  List<PlateModel> plateOfOrder = [];
  List<int> countPlateOfOrder = [];
  bool hasWorkerData = false;

  void _loadWorkerData() async {
    DataSnapshot workerSnapShot = await FirebaseDatabase.instance
        .ref('worker/${widget.pedido.workerId}')
        .get();
    setState(() {
      worker = WorkerModel(
        id: workerSnapShot.key.toString(),
        name: workerSnapShot.child('fullName').value.toString(),
        email: workerSnapShot.child('email').value.toString(),
        phone: workerSnapShot.child('phone').value.toString(),
        phoneToken: workerSnapShot.child('phoneToken').value.toString(),
        restaurantId: workerSnapShot.child('restaurantAssoc').value.toString(),
        restaurantName: '',
        imageUrl: workerSnapShot.child('imageUrl').exists
            ? workerSnapShot.child('imageUrl').value.toString()
            : 'lib/img/user.png',
      );
      if (workerSnapShot.key!.isNotEmpty) {
        hasWorkerData = true;
      }
    });
  }

  void _loadPlateOfOrden() async {
    DataSnapshot allPlateOfOrder = await FirebaseDatabase.instance
        .ref(
            'restaurants/$currentUserId/pedidos/${widget.pedido.id}/platesOfPedido')
        .get();
    countPlateOfOrder.clear();
    plateOfOrder.clear();
    if (allPlateOfOrder.exists) {
      for (var element in allPlateOfOrder.children) {
        PlateModel tempPlate = PlateModel(
          id: element.key.toString(),
          description: element.child('plateDescription').value.toString(),
          imageUrl: element.child('plateImageUrl').value.toString(),
          name: element.child('plateName').value.toString(),
          price: int.parse(element.child('platePrice').value.toString()),
          hasStock: element.child('hasStock').value as bool,
          isSpecial: element.child('isSpecial').value as bool,
          countSold: element.child('countSold').exists
              ? int.parse(element.child('countSold').value.toString())
              : 0,
        );
        int tempCount = int.parse(element.child('plateCount').value.toString());
        countPlateOfOrder.add(tempCount);
        plateOfOrder.add(tempPlate);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _loadWorkerData();
    _loadPlateOfOrden();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(63, 63, 156, 1),
            Color.fromRGBO(90, 70, 178, 1)
          ]),
        ),
        width: double.infinity,
        height: double.infinity,
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    CardContainer(
                      child: IntrinsicHeight(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        _showMoreInfoDialog(widget.pedido));
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.height * .18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Información',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Para: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            widget.pedido.nameOrNumber,
                                            style:
                                                const TextStyle(fontSize: 15.0),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Fecha: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        Text(
                                          '${DateTime.parse(widget.pedido.date).month}/${DateTime.parse(widget.pedido.date).day} a las ${DateTime.parse(widget.pedido.date).hour}:${DateTime.parse(widget.pedido.date).minute}',
                                          style:
                                              const TextStyle(fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Nota: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            widget.pedido.description,
                                            style:
                                                const TextStyle(fontSize: 15.0),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * .17,
                              child: (!hasWorkerData)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MyProfilePage(
                                                worker: worker,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black45,
                                                      spreadRadius: 2.0,
                                                      blurRadius: 5.0,
                                                    )
                                                  ]),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                child: Hero(
                                                  tag: worker.id,
                                                  child: worker.imageUrl ==
                                                          'lib/img/user.png'
                                                      ? Image.asset(
                                                          'lib/img/user.png',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : FadeInImage
                                                          .assetNetwork(
                                                          placeholder:
                                                              'lib/img/loading.gif',
                                                          image:
                                                              worker.imageUrl,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              worker.name,
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    CardContainer(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Platos',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            height: MediaQuery.of(context).size.height * .49,
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: plateOfOrder.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PlateInfoPage(
                                                palto: plateOfOrder[index],
                                                isRestaurant: true,
                                                restaurantAssocId: '',
                                              ),
                                            ));
                                      },
                                      child: Card(
                                        elevation: 10.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Column(
                                          children: [
                                            Flexible(
                                              child: ClipRRect(
                                                child: Hero(
                                                  transitionOnUserGestures:
                                                      true,
                                                  tag: plateOfOrder[index].id,
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'lib/img/loading.gif',
                                                    image: plateOfOrder[index]
                                                        .imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 200,
                                                  ),
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(25.0),
                                                  topRight:
                                                      Radius.circular(25.0),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              plateOfOrder[index].name,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    (countPlateOfOrder[index] != 1)
                                        ? Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              CircleAvatar(
                                                child: Text(
                                                  countPlateOfOrder[index]
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
          child: const Icon(Icons.more_horiz_sharp),
          closedForegroundColor: Colors.black54,
          openForegroundColor: Colors.white,
          closedBackgroundColor: Colors.white,
          openBackgroundColor: GLOBAL_COLOR,
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              child: const Icon(Icons.check_circle),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              label: 'Terminado',
              closeSpeedDialOnPressed: false,
              onPressed: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => const PogressDialig(
                    status: 'Terminando',
                  ),
                );
                DatabaseReference orderModifiqued = FirebaseDatabase.instance.ref(
                    'restaurants/$currentUserId/pedidos/${widget.pedido.id}');
                await orderModifiqued
                    .update({'dateEnd': DateTime.now().toString()});
                DataSnapshot terminedOrder = await orderModifiqued.get();

                DatabaseReference orderTermined = FirebaseDatabase.instance.ref(
                    'restaurants/$currentUserId/pedidosTerminados/${widget.pedido.id}');
                await orderTermined.set(terminedOrder.value);
                await orderModifiqued.remove();
                await updateSoldPlateOfPedido(plateOfOrder, countPlateOfOrder);
                Navigator.pop(context);
                // AllToast.showSuccessToast(context, 'Completado!', '');
                Navigator.pop(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.cancel),
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              label: 'Rechazar',
              closeSpeedDialOnPressed: false,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (contex) {
                      return AlertDialog(
                        title: const Text('Confirmar esta acción'),
                        content:
                            const Text("¿Está seguro de rechazar este pedido?"),
                        actions: <Widget>[
                          TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                return;
                              }),
                          TextButton(
                              child: const Text(
                                "Aceptar",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const PogressDialig(
                                    status: 'Rechazando',
                                  ),
                                );
                                DatabaseReference orderModifiqued =
                                    FirebaseDatabase.instance.ref(
                                        'restaurants/$currentUserId/pedidos/${widget.pedido.id}');
                                await orderModifiqued.update(
                                    {'dateEnd': DateTime.now().toString()});
                                DataSnapshot terminedOrder =
                                    await orderModifiqued.get();

                                DatabaseReference orderTermined =
                                    FirebaseDatabase.instance.ref(
                                        'restaurants/$currentUserId/pedidosRechazados/${widget.pedido.id}');
                                await orderTermined.set(terminedOrder.value);
                                await orderModifiqued.remove();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }),
                        ],
                      );
                    });
              },
            ),
          ]),
    );
  }

  Widget _showMoreInfoDialog(OrderModel order) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      title: Text(order.nameOrNumber),
      content: SizedBox(
        height: 150,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.description),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("Aceptar"),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
