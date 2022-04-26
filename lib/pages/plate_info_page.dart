import 'dart:async';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/utils/add_pedido.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/outline_button.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:uuid/uuid.dart';

class PlateInfoPage extends StatefulWidget {
  final PlateModel palto;
  final bool isRestaurant;
  final String restaurantAssocId;
  const PlateInfoPage({
    Key? key,
    required this.palto,
    required this.isRestaurant,
    required this.restaurantAssocId,
  }) : super(key: key);

  @override
  State<PlateInfoPage> createState() => _PlateInfoPageState();
}

class _PlateInfoPageState extends State<PlateInfoPage> {
  double height = 0.0;
  double width = 0.0;
  Timer? timer;
  String uuid = const Uuid().v1();

  void ainimatedInitial() {
    setState(() {
      height = MediaQuery.of(context).size.height * 0.5;
    });
    timer!.cancel();
  }

  @override
  void initState() {
    height = 350;
    timer = Timer.periodic(
        const Duration(microseconds: 10), (Timer t) => ainimatedInitial());
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference plateRef =
        FirebaseDatabase.instance.ref('restaurants/$currentUserId/plates/');
    width = MediaQuery.of(context).size.width;
    final imageProvider = Image.network(widget.palto.imageUrl).image;
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          GestureDetector(
            onTap: () {
              showImageViewer(
                context,
                imageProvider,
                onViewerDismissed: () {},
                immersive: true,
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Hero(
                transitionOnUserGestures: true,
                tag: widget.palto.id,
                child: FadeInImage.assetNetwork(
                  image: widget.palto.imageUrl,
                  placeholder: 'lib/img/loading.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50.0,
            left: 20.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                iconSize: 30.0,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black54,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(
                        3.0,
                        3.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                height: height,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.palto.hasStock
                              ? Container(
                                  height: 50.0,
                                  width: 130.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'En venta',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50.0,
                                  width: 130.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Agotado',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                          widget.palto.isSpecial
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 50.0),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 30.0,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              widget.palto.name,
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.amber.shade800,
                                  size: 30.0,
                                ),
                                const SizedBox(
                                  width: 7.0,
                                ),
                                Text(
                                  widget.palto.price.toString(),
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          widget.palto.description,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 11,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      (!widget.isRestaurant)
                          ? (widget.palto.hasStock)
                              ? Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Expanded(
                                    child: CustomOutLineButton(
                                      color: GLOBAL_COLOR,
                                      content: 'Añadir al pedido',
                                      onPressed: () {
                                        Navigator.pop(context);
                                        addPlateTopedido(
                                          widget.palto,
                                          context,
                                          widget.restaurantAssocId,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isRestaurant
          ? SpeedDial(
              child: const Icon(Icons.more_horiz_sharp),
              closedForegroundColor: Colors.white,
              openForegroundColor: Colors.black,
              closedBackgroundColor: GLOBAL_COLOR,
              openBackgroundColor: Colors.white,
              speedDialChildren: <SpeedDialChild>[
                widget.palto.isSpecial
                    ? SpeedDialChild(
                        child: const Icon(Icons.cancel),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.yellow,
                        label: 'Quitar del especial del día',
                        closeSpeedDialOnPressed: false,
                        onPressed: () async {
                          Map newSate = {
                            'countSold': widget.palto.countSold,
                            'isSpecial': false,
                            'hasStock': widget.palto.hasStock,
                            'plateDescription': widget.palto.description,
                            'plateImageUrl': widget.palto.imageUrl,
                            'plateName': widget.palto.name,
                            'platePrice': widget.palto.price,
                          };
                          Map<String, dynamic> update = {};
                          update[widget.palto.id] = newSate;
                          await plateRef.update(update);
                          Navigator.pop(context);
                        },
                      )
                    : SpeedDialChild(
                        child: const Icon(Icons.star),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.yellow,
                        label: 'Añadir al especial del día',
                        closeSpeedDialOnPressed: false,
                        onPressed: () async {
                          Map newSate = {
                            'countSold': widget.palto.countSold,
                            'isSpecial': true,
                            'hasStock': widget.palto.hasStock,
                            'plateDescription': widget.palto.description,
                            'plateImageUrl': widget.palto.imageUrl,
                            'plateName': widget.palto.name,
                            'platePrice': widget.palto.price,
                          };
                          Map<String, dynamic> update = {};
                          update[widget.palto.id] = newSate;
                          await plateRef.update(update);
                          Navigator.pop(context);
                        },
                      ),
                widget.palto.hasStock
                    ? SpeedDialChild(
                        child: const Icon(Icons.no_meals_ouline),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.redAccent,
                        label: 'Marcar como agotado',
                        closeSpeedDialOnPressed: false,
                        onPressed: () async {
                          Map newSate = {
                            'countSold': widget.palto.countSold,
                            'isSpecial': widget.palto.isSpecial,
                            'hasStock': false,
                            'plateDescription': widget.palto.description,
                            'plateImageUrl': widget.palto.imageUrl,
                            'plateName': widget.palto.name,
                            'platePrice': widget.palto.price,
                          };
                          Map<String, dynamic> update = {};
                          update[widget.palto.id] = newSate;
                          await plateRef.update(update);
                          Navigator.pop(context);
                        },
                      )
                    : SpeedDialChild(
                        child: const Icon(Icons.food_bank),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.redAccent,
                        label: 'Marcar como en venta',
                        closeSpeedDialOnPressed: false,
                        onPressed: () async {
                          Map newSate = {
                            'countSold': widget.palto.countSold,
                            'isSpecial': widget.palto.isSpecial,
                            'hasStock': true,
                            'plateDescription': widget.palto.description,
                            'plateImageUrl': widget.palto.imageUrl,
                            'plateName': widget.palto.name,
                            'platePrice': widget.palto.price,
                          };
                          Map<String, dynamic> update = {};
                          update[widget.palto.id] = newSate;
                          await plateRef.update(update);
                          Navigator.pop(context);
                        },
                      ),
                //  Your other SpeeDialChildren go here.
              ],
            )
          : Container(),
    );
  }
}
