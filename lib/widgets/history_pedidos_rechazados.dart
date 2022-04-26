import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/orders_model.dart';
import 'package:ready_food/pages/restaurant_my_pedido_page.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';

class HistoryPedidosRechazados extends StatefulWidget {
  const HistoryPedidosRechazados({Key? key}) : super(key: key);

  @override
  State<HistoryPedidosRechazados> createState() =>
      _HistoryPedidosRechazadosState();
}

class _HistoryPedidosRechazadosState extends State<HistoryPedidosRechazados> {
  List<OrderModel> allOrders = [];

  void getData() async {
    DatabaseReference confirmedPedidosRef = FirebaseDatabase.instance
        .ref('restaurants/$currentUserId/pedidosRechazados/');
    DataSnapshot data = await confirmedPedidosRef.get();
    for (var element in data.children) {
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
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allOrders.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: allOrders.length,
              itemBuilder: (context, index) {
                return ListTile(
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
                );
              },
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('Sin registros '), Icon(Icons.history)],
              ),
            ),
    );
  }
}
