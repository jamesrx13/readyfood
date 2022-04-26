import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/orders_model.dart';
import 'package:ready_food/pages/restaurant_my_pedido_page.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';

class RestaurantMyPedidos extends StatefulWidget {
  const RestaurantMyPedidos({Key? key}) : super(key: key);

  @override
  State<RestaurantMyPedidos> createState() => _RestaurantMyPedidosState();
}

class _RestaurantMyPedidosState extends State<RestaurantMyPedidos> {
  List<OrderModel> allOrders = [];
  @override
  void initState() {
    FirebaseDatabase.instance
        .ref('restaurants/$currentUserId/pedidos/')
        .orderByChild('dateSendPedido')
        .onValue
        .listen((event) {
      allOrders.clear();
      for (var element in event.snapshot.children) {
        OrderModel temOrder = OrderModel(
          id: element.key.toString(),
          date: element.child('dateSendPedido').value.toString(),
          description: element.child('description').value.toString(),
          nameOrNumber: element.child('nameONumber').value.toString(),
          workerId: element.child('workerId').value.toString(),
          dateEnd: '',
        );
        allOrders.add(temOrder);
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (allOrders.isNotEmpty)
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0,
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: allOrders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                spreadRadius: 2.0,
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                  '${DateTime.parse(allOrders[index].date).day}/${DateTime.parse(allOrders[index].date).month} a las ${DateTime.parse(allOrders[index].date).hour}:${DateTime.parse(allOrders[index].date).minute}'),
                              subtitle: Text(allOrders[index].nameOrNumber),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => RestaurantMyPedidoPage(
                                            pedido: allOrders[index])));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: Text('No hay pedidos'),
            ),
    );
  }
}
