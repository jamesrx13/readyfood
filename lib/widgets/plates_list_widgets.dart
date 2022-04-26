import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/pages/plate_info_page.dart';
import 'package:ready_food/utils/add_pedido.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/modal_add_plate_orden.dart';
import 'package:ready_food/widgets/outline_button.dart';

class PlatesListWidget extends StatefulWidget {
  final String restaurantAssocId;
  const PlatesListWidget({Key? key, required this.restaurantAssocId})
      : super(key: key);

  @override
  _PlatesListWidgetState createState() => _PlatesListWidgetState();
}

class _PlatesListWidgetState extends State<PlatesListWidget> {
  String restarurantAssoc = '';
  void setIdRestaurantAssoc() async {
    setState(() {
      restarurantAssoc = widget.restaurantAssocId.trim();
    });
  }

  List<PlateModel> allPlates = [];

  @override
  void initState() {
    setIdRestaurantAssoc();
    DatabaseReference myRef =
        FirebaseDatabase.instance.ref('restaurants/$restarurantAssoc/plates/');
    myRef.orderByChild('isSpecial').equalTo(false).onValue.listen((event) {
      allPlates.clear();
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
        allPlates.add(plateTemp);
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (allPlates.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allPlates.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => Popover(
                            child: _modalAddPlateContent(allPlates[index]),
                          ),
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlateInfoPage(
                              palto: allPlates[index],
                              isRestaurant: false,
                              restaurantAssocId: restarurantAssoc,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                      )
                                    ]),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      child: Hero(
                                        tag: allPlates[index].id,
                                        child: FadeInImage.assetNetwork(
                                          image: allPlates[index].imageUrl,
                                          placeholder: 'lib/img/loading.gif',
                                          width: 110.0,
                                          height: 80.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                allPlates[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Text(
                                                  allPlates[index].description,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                allPlates[index]
                                                    .price
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          (!allPlates[index].hasStock)
                                              ? Container(
                                                  height: 15.0,
                                                  width: 15.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.redAccent,
                                                  ),
                                                )
                                              : Container(),
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
                    ),
                  ],
                );
              },
            ),
          )
        : const Center(
            child: Text('No hay platos por mostrar.'),
          );
  }

  Widget _modalAddPlateContent(PlateModel plate) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              top: 15.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(
                          2.0,
                          2.0,
                        ),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: FadeInImage.assetNetwork(
                      image: plate.imageUrl,
                      placeholder: 'lib/img/loading.gif',
                      width: 110.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        plate.name,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        plate.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Colors.amber.shade800,
                        ),
                        const SizedBox(
                          width: 7.0,
                        ),
                        Text(
                          plate.price.toString(),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomOutLineButton(
                    color: Colors.redAccent,
                    content: 'Ver más',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PlateInfoPage(
                                    palto: plate,
                                    isRestaurant: false,
                                    restaurantAssocId: restarurantAssoc,
                                  )));
                    },
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                plate.hasStock
                    ? Expanded(
                        child: CustomOutLineButton(
                          color: GLOBAL_COLOR,
                          content: 'Añadir al pedido',
                          onPressed: () {
                            addPlateTopedido(
                                plate, context, widget.restaurantAssocId);
                            Navigator.pop(context);
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
