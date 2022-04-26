import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ready_food/models/restaurant_model.dart';
import 'package:ready_food/models/worker_model.dart';

String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
late DatabaseReference userRef;

Future<RestaurantModel> currentRestaurantData() async {
  userRef = FirebaseDatabase.instance.ref('restaurants/$currentUserId');
  RestaurantModel restaurantData = RestaurantModel(
    id: '',
    name: 'null',
    email: '',
    phone: '',
    phoneToken: '',
  );
  try {
    final userSnapshot = await userRef.get();
    restaurantData = RestaurantModel(
      id: userSnapshot.key.toString(),
      email: userSnapshot.child('email').value.toString(),
      phoneToken: userSnapshot.child('phoneToken').value.toString(),
      name: userSnapshot.child('fullName').value.toString(),
      phone: userSnapshot.child('phone').value.toString(),
    );
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
  return restaurantData;
}

Future<WorkerModel> currentWorkerData() async {
  userRef = FirebaseDatabase.instance.ref('worker/$currentUserId');
  WorkerModel workerData = WorkerModel(
    id: '',
    name: '',
    email: '',
    phone: '',
    restaurantId: 'null',
    restaurantName: 'null',
    imageUrl: 'lib/img/user.png',
    phoneToken: '',
  );
  try {
    final userSnapshot = await userRef.get();
    final restaurantAsoccId =
        userSnapshot.child('restaurantAssoc').value.toString();

    String restaurantName = 'ReadyFood';

    DatabaseReference getNameRestaurantRef =
        FirebaseDatabase.instance.ref('restaurants/$restaurantAsoccId');

    try {
      final restaurentData = await getNameRestaurantRef.get();
      restaurantName = restaurentData.child('fullName').value.toString();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    workerData = WorkerModel(
      id: userSnapshot.key.toString(),
      name: userSnapshot.child('fullName').value.toString(),
      email: userSnapshot.child('email').value.toString(),
      phone: userSnapshot.child('phone').value.toString(),
      phoneToken: userSnapshot.child('phoneToken').value.toString(),
      restaurantId: restaurantAsoccId,
      restaurantName: restaurantName,
      imageUrl: userSnapshot.child('imageUrl').exists
          ? userSnapshot.child('imageUrl').value.toString()
          : 'lib/img/user.png',
    );
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
  return workerData;
}
