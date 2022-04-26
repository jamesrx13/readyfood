import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/orders_model.dart';
import 'package:ready_food/pages/worker_complite_pedido.dart';

class WorkerPedidosComplite extends StatefulWidget {
  final String restaurantId;
  const WorkerPedidosComplite({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  State<WorkerPedidosComplite> createState() => _WorkerPedidosCompliteState();
}

class _WorkerPedidosCompliteState extends State<WorkerPedidosComplite> {
  List<OrderModel> allOrders = [];

  @override
  void initState() {
    FirebaseDatabase.instance
        .ref('restaurants/${widget.restaurantId}/pedidosTerminados/')
        .orderByChild('dateEnd')
        .onValue
        .listen((event) {
      allOrders.clear();
      for (var element in event.snapshot.children) {
        OrderModel tempOrder = OrderModel(
          id: element.key.toString(),
          date: element.child('dateSendPedido').value.toString(),
          dateEnd: element.child('dateEnd').value.toString(),
          description: element.child('description').value.toString(),
          nameOrNumber: element.child('nameONumber').value.toString(),
          workerId: '',
        );
        allOrders.add(tempOrder);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Text(
                'Pedidos completados',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black54,
                  decoration: TextDecoration.none,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .8,
              child: (allOrders.isNotEmpty)
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: allOrders.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          confirmDismiss: (direction) async {
                            return showDialog(
                              context: context,
                              builder: (contex) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  title: const Text('¿Finalizar este pedido?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'Aceptar',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop(true);
                                        DatabaseReference orderModifiqued =
                                            FirebaseDatabase.instance.ref(
                                                'restaurants/${widget.restaurantId}/pedidosTerminados/${allOrders[index].id}');
                                        await orderModifiqued.update({
                                          'dateFinalized':
                                              DateTime.now().toString()
                                        });
                                        DataSnapshot terminedOrder =
                                            await orderModifiqued.get();
                                        DatabaseReference orderFinalized =
                                            FirebaseDatabase.instance.ref(
                                                'restaurants/${widget.restaurantId}/pedidosFinalizados/${allOrders[index].id}');
                                        await orderFinalized
                                            .set(terminedOrder.value);
                                        await orderModifiqued.remove();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.green.shade300,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(
                                    'Finalizar',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(Icons.outbound_outlined)
                                ],
                              ),
                            ),
                          ),
                          key: Key(allOrders[index].id),
                          child: ListTile(
                            title: Text(
                              allOrders[index].nameOrNumber,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            subtitle: Text(
                              '${DateTime.parse(allOrders[index].dateEnd).day}/${DateTime.parse(allOrders[index].dateEnd).month} - ${DateTime.parse(allOrders[index].dateEnd).hour}:${DateTime.parse(allOrders[index].dateEnd).minute}',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => WorkerCompliteOrder(
                                            pedido: allOrders[index],
                                            restaurantId: widget.restaurantId,
                                          )));
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Sin pedidos completados'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
