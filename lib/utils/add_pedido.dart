import 'package:firebase_database/firebase_database.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/widgets/worker_pedido.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void addPlateTopedido(
    PlateModel plate, BuildContext context, String restaurantId) async {
  DatabaseReference pedidoRef = FirebaseDatabase.instance
      .ref('worker/$currentUserId/unConfirmedPedido/${plate.id}/');
  //
  DataSnapshot exist = await pedidoRef.get();
  if (exist.exists) {
    int newCount = int.parse(exist.child('plateCount').value.toString()) + 1;
    plateCountUpdate(plate.id, newCount);
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkerMyPedido(assocrestaurantId: restaurantId),
    );
  } else {
    Map plateToAdd = {
      'plateName': plate.name,
      'plateDescription': plate.description,
      'plateImageUrl': plate.imageUrl,
      'platePrice': plate.price,
      'hasStock': plate.hasStock,
      'isSpecial': plate.isSpecial,
      'plateCount': 1,
    };
    await pedidoRef.set(plateToAdd);
    AllToast.showSuccessToast(context, 'Ok', 'Plato añadido');
  }
  //
}

void plateCountUpdate(String plateId, int newValue) {
  DatabaseReference plateCountRef = FirebaseDatabase.instance
      .ref('worker/$currentUserId/unConfirmedPedido/$plateId');
  plateCountRef.update({'plateCount': newValue});
}

void removePlateOfPedido(String plateId) {
  DatabaseReference plateCountRef = FirebaseDatabase.instance
      .ref('worker/$currentUserId/unConfirmedPedido/$plateId');
  plateCountRef.remove();
}

Future<bool> confirmedPedido(
  List<PlateModel> allPlates,
  String nameOrnumber,
  String description,
  String restaurantAssocId,
  List<int> allCountPlates,
) async {
  if (restaurantAssocId.isEmpty ||
      restaurantAssocId == '' ||
      restaurantAssocId == 'null') {
    return false;
  }
  String uuid = const Uuid().v1();
  DatabaseReference newPedido = FirebaseDatabase.instance
      .ref('restaurants/$restaurantAssocId/pedidos/$uuid');

  Map infoDataPedido = {
    'nameONumber': nameOrnumber,
    'description': description.isNotEmpty ? description : 'Sin descripción',
    'workerId': currentUserId,
    'dateSendPedido': DateTime.now().toString(),
  };
  try {
    await newPedido.set(infoDataPedido).whenComplete(() async {
      int counter = 0;
      DatabaseReference addPlateOfpedido = FirebaseDatabase.instance
          .ref('restaurants/$restaurantAssocId/pedidos/$uuid/platesOfPedido');
      for (var element in allPlates) {
        Map mapTempToAdd = {
          'hasStock': element.hasStock,
          'isSpecial': element.isSpecial,
          'plateDescription': element.description,
          'plateImageUrl': element.imageUrl,
          'plateName': element.name,
          'platePrice': element.price,
          'plateCount': allCountPlates[counter],
        };

        addPlateOfpedido.child(element.id).set(mapTempToAdd);
        counter++;
      }
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> updateSoldPlateOfPedido(
    List<PlateModel> allPlates, List<int> plateCount) async {
  try {
    int counter = 0;
    for (var element in allPlates) {
      DatabaseReference plateSoldUpdateRef = FirebaseDatabase.instance
          .ref('restaurants/$currentUserId/plates/${element.id}');
      int newValueSold = plateCount[counter];

      DataSnapshot oldSoldSnap =
          await plateSoldUpdateRef.child('countSold').get();
      if (oldSoldSnap.exists) {
        newValueSold =
            int.parse(oldSoldSnap.value.toString()) + plateCount[counter];
      }

      plateSoldUpdateRef.update({'countSold': newValueSold});
      counter++;
    }

    return true;
  } catch (e) {
    return false;
  }
}
