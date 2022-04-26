import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/services/push_notification_service.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/progress_dialog.dart';
import 'package:ready_food/widgets/auth_background.dart';
import 'package:ready_food/widgets/card_container.dart';
import 'package:ready_food/widgets/osud_button.dart';
// import 'package:permission_handler/permission_handler.dart';

class RestaurantRegisterPage extends StatefulWidget {
  const RestaurantRegisterPage({Key? key}) : super(key: key);

  @override
  _RestaurantRegisterPageState createState() => _RestaurantRegisterPageState();
}

class _RestaurantRegisterPageState extends State<RestaurantRegisterPage> {
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void registerNewRestaurant(BuildContext context) async {
    // Espera
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const PogressDialig(
              status: 'Te estamos registrando :)',
            ));
    var conectivity = await Connectivity().checkConnectivity();
    if (conectivity != ConnectivityResult.wifi &&
        conectivity != ConnectivityResult.mobile) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', 'No hay conexión');
      return;
    }
    try {
      UserCredential userData =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pop(context);
      if (userData.user != null) {
        DatabaseReference newUser = FirebaseDatabase.instance
            .ref()
            .child('restaurants/${userData.user?.uid}');
        String token = await PushNotificationServices.getCellphoneToken();
        Map userDataMap = {
          'fullName': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'phoneToken': token,
        };
        await newUser.set(userDataMap);
        AllToast.showSuccessToast(context, 'Ok', 'Registro exitoso');
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      } else {
        Navigator.pop(context);
        AllToast.showDangerousToast(
            context, 'Oh, Oh...', 'Error al crear el usuario');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        AllToast.showInfoToast(context, 'Oh, Oh...', 'Contraseña débil');
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        AllToast.showInfoToast(context, 'Oh, Oh...', 'Correo en uso.');
      }
    } catch (e) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 270),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Registrate',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 30),
                    _campoName(),
                    const SizedBox(height: 30),
                    _campoEmail(),
                    const SizedBox(height: 30),
                    _campoPhone(),
                    const SizedBox(height: 30),
                    _campoPassword(),
                    const SizedBox(height: 40),
                    _goButtom('Registrar'),
                    const SizedBox(height: 10),
                    _goToRegister(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoEmail() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Correo electrónico',
      icon: const Icon(Icons.email),
      labelStyle: const TextStyle(
        fontSize: 16.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      controller: emailController,
      onChanged: (text) {},
      keyboardType: TextInputType.emailAddress,
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoPassword() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      icon: const Icon(Icons.lock),
      labelText: 'Contraseña',
      labelStyle: const TextStyle(
        fontSize: 16.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      controller: passwordController,
      onChanged: (text) {},
      obscureText: true,
      decoration: decoration,
      style: style,
    );
  }

  Widget _goButtom(content) {
    return OsudButton(
      content: content,
      color: const Color.fromRGBO(90, 70, 178, 1),
      onPressed: () async {
        // Validar la conectividad
        var conectivity = await Connectivity().checkConnectivity();
        if (conectivity != ConnectivityResult.wifi &&
            conectivity != ConnectivityResult.mobile) {
          AllToast.showDangerousToast(context, 'Oh, Oh...', 'Sin conexión');
          return;
        }
        // Validar el campos
        if (fullNameController.text.length < 3) {
          AllToast.showInfoToast(context, 'Oh, Oh...', 'Nombre no válido');
          return;
        }
        if (!emailController.text.contains('@')) {
          AllToast.showInfoToast(context, 'Oh, Oh...', 'Correo no válido');
          return;
        }
        if (phoneController.text.length != 10) {
          AllToast.showInfoToast(context, 'Oh, Oh...', 'Teléfono no válido');
          return;
        }
        if (passwordController.text.length < 6) {
          AllToast.showInfoToast(context, 'Oh, Oh...', 'Contraseña muy corta');
          return;
        }
        registerNewRestaurant(context);
      },
    );
  }

  Widget _campoPhone() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Numero de teléfono',
      icon: const Icon(Icons.phone),
      labelStyle: const TextStyle(
        fontSize: 14.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      controller: phoneController,
      onChanged: (text) {},
      keyboardType: TextInputType.phone,
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoName() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Nombre de tu restaurante',
      icon: const Icon(Icons.person),
      labelStyle: const TextStyle(
        fontSize: 14.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      controller: fullNameController,
      onChanged: (text) {},
      keyboardType: TextInputType.text,
      decoration: decoration,
      style: style,
    );
  }

  Widget _goToRegister(BuildContext context) {
    return TextButton(
      child: const Text('¿Ya tienes una cuenta? Inicia!'),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      },
    );
  }
}
