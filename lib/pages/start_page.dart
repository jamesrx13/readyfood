import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

void validateSesion(BuildContext context) async {
  var conectivity = await Connectivity().checkConnectivity();
  if (conectivity != ConnectivityResult.wifi &&
      conectivity != ConnectivityResult.mobile) {
    AllToast.showInfoToast(context, 'Oh, Oh...', 'Sin conexión');
    return;
  }
  if (FirebaseAuth.instance.currentUser != null) {
    DatabaseReference restaurantData =
        FirebaseDatabase.instance.ref().child('restaurants/$currentUserId');
    restaurantData.once().then((snapshot) async {
      if (snapshot.snapshot.value != null) {
        await FirebaseAuth.instance.currentUser!.reload();
        Timer(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          AllToast.showSuccessToast(context, 'Bienvenido!', '');
        });
      }
    });
    DatabaseReference workerData =
        FirebaseDatabase.instance.ref().child('worker/$currentUserId');
    workerData.once().then((snapshot) async {
      if (snapshot.snapshot.value != null) {
        await FirebaseAuth.instance.currentUser!.reload();
        Timer(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/worker', (route) => false);
          AllToast.showSuccessToast(context, 'Bienvenido!', '');
        });
      }
    });
  } else {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    });
  }
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => validateSesion(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logo(Alignment.center, 200.0, 200.0, 'lib/img/logo.png'),
            _space(0.0, 0.0),
            _texto('Bienvenido a ReadyFood'),
            _space(10.0, 0.0),
            _carga(),
          ],
        ),
      ),
    );
  }

  Widget _space(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  Widget _logo(aliniamiento, height, width, imageURL) {
    imageURL = AssetImage(imageURL);
    return Image(
      alignment: aliniamiento,
      height: height,
      width: width,
      image: imageURL,
    );
  }

  Widget _texto(content) {
    const style = TextStyle(
      fontSize: 25,
      fontFamily: 'Brand-Bold',
    );
    return Text(
      content,
      textAlign: TextAlign.center,
      style: style,
    );
  }

  Widget _carga() {
    const progressIndicator = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    );
    return progressIndicator;
  }
}
