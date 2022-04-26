import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/pages/plate_info_page.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/restaurant_new_plate.dart';

class RestaurantMyPlates extends StatefulWidget {
  const RestaurantMyPlates({Key? key}) : super(key: key);

  @override
  _RestaurantMyPlatesState createState() => _RestaurantMyPlatesState();
}

class _RestaurantMyPlatesState extends State<RestaurantMyPlates> {
  List<PlateModel> placeAllDataMap = [];

  @override
  void initState() {
    super.initState();
    final myPlatesDbRef =
        FirebaseDatabase.instance.ref('restaurants/$currentUserId/plates/');
    myPlatesDbRef.onValue.listen((event) {
      placeAllDataMap.clear();
      for (var element in event.snapshot.children) {
        PlateModel plateTemp = PlateModel(
          id: element.key.toString(),
          description: element.child('plateDescription').value.toString(),
          imageUrl: element.child('plateImageUrl').value.toString(),
          name: element.child('plateName').value.toString(),
          hasStock: element.child('hasStock').value as bool,
          isSpecial: element.child('isSpecial').value as bool,
          countSold: element.child('countSold').exists
              ? int.parse(element.child('countSold').value.toString())
              : 0,
          price: int.parse(
            element.child('platePrice').value.toString(),
          ),
        );
        placeAllDataMap.add(plateTemp);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: (placeAllDataMap.isNotEmpty)
            ? GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: placeAllDataMap.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlateInfoPage(
                            palto: placeAllDataMap[index],
                            isRestaurant: true,
                            restaurantAssocId: '',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.black,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Flexible(
                                child: ClipRRect(
                                  child: Hero(
                                    transitionOnUserGestures: true,
                                    tag: placeAllDataMap[index].id,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'lib/img/loading.gif',
                                      image: placeAllDataMap[index].imageUrl,
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
                                  placeAllDataMap[index].name,
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
                                  "Precio: ${placeAllDataMap[index].price}",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white54,
                                  maxRadius: 20.0,
                                  child: DropdownButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                    ),
                                    isExpanded: true,
                                    underline: Container(),
                                    elevation: 24,
                                    alignment: AlignmentDirectional.center,
                                    borderRadius: BorderRadius.circular(15),
                                    items: const [
                                      DropdownMenuItem(
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blueAccent,
                                        ),
                                        value: 'Editar',
                                      ),
                                      DropdownMenuItem(
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        value: 'Eliminar',
                                      ),
                                    ].toList(),
                                    onChanged: (opt) {
                                      setState(() {
                                        _deleteOrEdit(opt.toString(),
                                            placeAllDataMap[index]);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      elevation: 10.0,
                    ),
                  );
                },
              )
            : const Center(
                child: Text('No ha registrado platos aún :)'),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: GLOBAL_COLOR,
        onPressed: () {
          showBarModalBottomSheet(
            expand: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => RestaurantNewPlate(),
          );
        },
      ),
    );
  }

  void _deleteOrEdit(String opt, PlateModel plate) {
    switch (opt) {
      case 'Editar':
        showBarModalBottomSheet(
          expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => RestaurantNewPlate(plato: plate),
        );
        break;
      case 'Eliminar':
        showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(plate.name),
            content: const Text(
                "¿Está seguro de querer eliminar este plato?\n\nEsta acción no se puede revertir..."),
            actions: <Widget>[
              TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              TextButton(
                child: const Text(
                  "Eliminar",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () async {
                  DatabaseReference plateDelete = FirebaseDatabase.instance
                      .ref()
                      .child('restaurants/$currentUserId/plates/${plate.id}');
                  await plateDelete.remove();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
        break;
    }
  }
}
