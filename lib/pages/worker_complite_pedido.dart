import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/orders_model.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/widgets/card_container.dart';

class WorkerCompliteOrder extends StatefulWidget {
  final OrderModel pedido;
  final String restaurantId;
  const WorkerCompliteOrder(
      {Key? key, required this.pedido, required this.restaurantId})
      : super(key: key);

  @override
  State<WorkerCompliteOrder> createState() => _WorkerCompliteOrderState();
}

class _WorkerCompliteOrderState extends State<WorkerCompliteOrder> {
  List<PlateModel> plateOfOrder = [];
  List<int> countPlateOfOrder = [];
  void _loadPlateOfOrden() async {
    DataSnapshot allPlateOfOrder = await FirebaseDatabase.instance
        .ref(
            'restaurants/${widget.restaurantId}/pedidosTerminados/${widget.pedido.id}/platesOfPedido')
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
          countSold: element.child('countSold').exists
              ? int.parse(element.child('countSold').value.toString())
              : 0,
          hasStock: element.child('hasStock').value as bool,
          isSpecial: element.child('isSpecial').value as bool,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .35,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Realizado: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${DateTime.parse(widget.pedido.date).day}/${DateTime.parse(widget.pedido.date).month} - ${DateTime.parse(widget.pedido.date).hour}:${DateTime.parse(widget.pedido.date).minute}',
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Finalizado: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${DateTime.parse(widget.pedido.dateEnd).day}/${DateTime.parse(widget.pedido.dateEnd).month} - ${DateTime.parse(widget.pedido.dateEnd).hour}:${DateTime.parse(widget.pedido.dateEnd).minute}',
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const VerticalDivider(color: Colors.black),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .35,
                              child: Column(
                                children: [
                                  const Text(
                                    'Nota',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .35,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        widget.pedido.description,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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
                                  Card(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: ClipRRect(
                                            child: Hero(
                                              transitionOnUserGestures: true,
                                              tag: plateOfOrder[index].id,
                                              child: FadeInImage.assetNetwork(
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
                                              topLeft: Radius.circular(25.0),
                                              topRight: Radius.circular(25.0),
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
        )),
      ),
    );
  }
}
