import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/utils/add_pedido.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/osud_button.dart';

class WorkerMyPedido extends StatefulWidget {
  final String assocrestaurantId;
  const WorkerMyPedido({Key? key, required this.assocrestaurantId})
      : super(key: key);

  @override
  State<WorkerMyPedido> createState() => _WorkerMyPedidoState();
}

class _WorkerMyPedidoState extends State<WorkerMyPedido> {
  var nameOfPedido = TextEditingController();
  var noteOfPedido = TextEditingController();
  InputDecoration inputDecoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 1.0),
      borderRadius: BorderRadius.circular(25.0),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black38, width: 2.0),
      borderRadius: BorderRadius.circular(25.0),
    ),
    labelText: '* Nombre o # de mesa del pedido',
    icon: const Icon(Icons.table_bar),
    labelStyle: const TextStyle(
      fontSize: 16.0,
    ),
    hintStyle: const TextStyle(
      fontSize: 12.0,
      color: Colors.grey,
    ),
  );

  InputDecoration inputDecorationArea = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 1.0),
      borderRadius: BorderRadius.circular(25.0),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black38, width: 2.0),
      borderRadius: BorderRadius.circular(25.0),
    ),
    labelText: 'Nota adicional (Opcional)',
    icon: const Icon(Icons.note),
    labelStyle: const TextStyle(
      fontSize: 16.0,
    ),
    hintStyle: const TextStyle(
      fontSize: 12.0,
      color: Colors.grey,
    ),
  );

  var inputStyle = const TextStyle(
    fontSize: 14.0,
  );
  List<PlateModel> allPlates = [];
  List<int> plateCant = [];
  double totalPedido = 0.0;
  @override
  void initState() {
    DatabaseReference unConfirmedPlatesRef = FirebaseDatabase.instance
        .ref('worker/$currentUserId/unConfirmedPedido/');
    unConfirmedPlatesRef.onValue.listen(
      (event) {
        allPlates.clear();
        plateCant.clear();
        totalPedido = 0.0;
        for (var element in event.snapshot.children) {
          PlateModel plateTemp = PlateModel(
            id: element.key.toString(),
            countSold: element.child('countSold').exists
                ? int.parse(element.child('countSold').value.toString())
                : 0,
            description: element.child('plateDescription').value.toString(),
            imageUrl: element.child('plateImageUrl').value.toString(),
            name: element.child('plateName').value.toString(),
            price: int.parse(element.child('platePrice').value.toString()),
            hasStock: element.child('hasStock').value as bool,
            isSpecial: element.child('isSpecial').value as bool,
          );
          int plateCantTemp =
              int.parse(element.child('plateCount').value.toString());
          plateCant.add(plateCantTemp);
          totalPedido = totalPedido +
              (plateTemp.price *
                  int.parse(element.child('plateCount').value.toString()));
          allPlates.add(plateTemp);
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Pedido',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black54,
                  decoration: TextDecoration.none,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width,
                child: (allPlates.isNotEmpty)
                    ? GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: allPlates.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Card(
                                color: Colors.white70,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                shadowColor: Colors.black,
                                child: Column(
                                  children: [
                                    Flexible(
                                      child: ClipRRect(
                                        child: Hero(
                                          transitionOnUserGestures: true,
                                          tag: allPlates[index].id,
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'lib/img/loading.gif',
                                            image: allPlates[index].imageUrl,
                                            fit: BoxFit.cover,
                                            width: 250,
                                            height: 150,
                                          ),
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        allPlates[index].name,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 5.0,
                                      ),
                                      child: Text(
                                        "Precio: ${allPlates[index].price}",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          color: Colors.blue,
                                          onPressed: () {
                                            plateCountUpdate(
                                                allPlates[index].id,
                                                (plateCant[index] + 1));
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                        Text(plateCant[index].toString()),
                                        IconButton(
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            if (plateCant[index] > 1) {
                                              plateCountUpdate(
                                                  allPlates[index].id,
                                                  (plateCant[index] - 1));
                                            }
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.indigoAccent,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(allPlates[index].name),
                                            content: const Text(
                                                "Pulse \"aceptar\" para remover"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Cancelar"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  "Aceptar",
                                                  style: TextStyle(
                                                      color: Colors.redAccent),
                                                ),
                                                onPressed: () {
                                                  removePlateOfPedido(
                                                      allPlates[index].id);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      )
                    : const Center(
                        child: Text('Añade platos al pedido :)'),
                      ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalPedido',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameOfPedido,
                        decoration: inputDecoration,
                        style: inputStyle,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: noteOfPedido,
                        decoration: inputDecorationArea,
                        style: inputStyle,
                        maxLength: 300,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              OsudButton(
                color: GLOBAL_COLOR,
                content: 'Confirmar pedido',
                onPressed: () {
                  if (allPlates.isNotEmpty) {
                    if (nameOfPedido.text.isEmpty) {
                      AllToast.showInfoToast(
                          context, 'oh, Oh..', '¿Para quíen es?');
                      return;
                    }
                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title:
                            const Text('Está a punto de confirmar el pedido'),
                        content: const Text(
                            "Pulse \"aceptar\" para que su restaurante sea notificado con este pedido."),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Aceptar",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            onPressed: () async {
                              if (nameOfPedido.text.trim().isEmpty) {
                                AllToast.showInfoToast(context, 'Oh, Oh...',
                                    'Falta el nombre o mesa');
                                Navigator.pop(context);
                              } else {
                                bool res = await confirmedPedido(
                                  allPlates,
                                  nameOfPedido.text,
                                  noteOfPedido.text,
                                  widget.assocrestaurantId,
                                  plateCant,
                                );
                                if (res) {
                                  await FirebaseDatabase.instance
                                      .ref(
                                          'worker/$currentUserId/unConfirmedPedido/')
                                      .remove();
                                  nameOfPedido.text = '';
                                  noteOfPedido.text = '';
                                  Navigator.pop(context);
                                  AllToast.showSuccessToast(
                                      context, 'Ok', 'Pedido realizado');
                                } else {
                                  Navigator.pop(context);
                                  AllToast.showDangerousToast(context,
                                      'Error...', 'Pedido no realizado.');
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    AllToast.showInfoToast(
                        context, 'Oh, Oh...', 'No hay platos');
                  }
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
