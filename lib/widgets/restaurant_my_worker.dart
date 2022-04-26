import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/worker_model.dart';
import 'package:ready_food/pages/restaurant_worker_profile.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';

class RestaurantMyWorker extends StatefulWidget {
  const RestaurantMyWorker({Key? key}) : super(key: key);

  @override
  State<RestaurantMyWorker> createState() => _RestaurantMyWorkerState();
}

class _RestaurantMyWorkerState extends State<RestaurantMyWorker> {
  List<WorkerModel> allDataWorker = [];

  @override
  void initState() {
    FirebaseDatabase.instance
        .ref('worker')
        .orderByChild('restaurantAssoc')
        .equalTo(currentUserId)
        .onValue
        .listen((event) {
      allDataWorker.clear();
      for (var element in event.snapshot.children) {
        WorkerModel plateTemp = WorkerModel(
          id: element.key.toString(),
          email: element.child('email').value.toString(),
          name: element.child('fullName').value.toString(),
          phone: element.child('phone').value.toString(),
          phoneToken: element.child('phoneToken').value.toString(),
          restaurantId: element.child('restaurantAssoc').value.toString(),
          restaurantName: '',
          imageUrl: element.child('imageUrl').exists
              ? element.child('imageUrl').value.toString()
              : 'lib/img/user.png',
        );
        allDataWorker.add(plateTemp);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: (allDataWorker.isNotEmpty)
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: allDataWorker.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: const Icon(Icons.arrow_forward_ios),
                    leading: Container(
                      height: 80,
                      width: 60,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              spreadRadius: 2.0,
                              blurRadius: 5.0,
                            )
                          ]),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: Hero(
                          tag: allDataWorker[index].id,
                          child: allDataWorker[index].imageUrl ==
                                  'lib/img/user.png'
                              ? Image.asset(
                                  'lib/img/user.png',
                                  fit: BoxFit.cover,
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder: 'lib/img/loading.gif',
                                  image: allDataWorker[index].imageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    title: Text(
                      allDataWorker[index].name,
                      style: const TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    subtitle: Text(
                      allDataWorker[index].phone,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MyProfilePage(worker: allDataWorker[index]),
                        ),
                      );
                    },
                  );
                },
              )
            : const Center(
                child: Text('Aún no tiene trabajadores asociados.'),
              ),
      ),
    );
  }
}
