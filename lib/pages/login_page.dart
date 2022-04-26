import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/services/push_notification_service.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/progress_dialog.dart';
import 'package:ready_food/widgets/osud_button.dart';
import 'package:ready_food/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void singIn(BuildContext context) async {
    // Waiting
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const PogressDialig(
        status: 'Iniciando sesión',
      ),
    );
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pop(context);
      if (userCredential.user != null) {
        // Autenticacion exitosa
        DatabaseReference restaurantData = FirebaseDatabase.instance
            .ref()
            .child('restaurants/${userCredential.user?.uid}');
        restaurantData.once().then((snapshot) async {
          if (snapshot.snapshot.value != null) {
            String token = await PushNotificationServices.getCellphoneToken();
            restaurantData.update({'phoneToken': token}).whenComplete(() {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              AllToast.showSuccessToast(context, 'Bienvenido!', '');
            });
          }
        });
        DatabaseReference workerData = FirebaseDatabase.instance
            .ref()
            .child('worker/${userCredential.user?.uid}');
        workerData.once().then((snapshot) async {
          if (snapshot.snapshot.value != null) {
            String token = await PushNotificationServices.getCellphoneToken();
            workerData.update({'phoneToken': token}).whenComplete(() {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/worker', (route) => false);
              AllToast.showSuccessToast(context, 'Bienvenido!', '');
            });
          }
        });
      } else {
        AllToast.showDangerousToast(context, 'Error', 'Usuario sin datos.');
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AllToast.showInfoToast(context, 'Oh, Oh...', 'Usuario no encontrado.');
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        AllToast.showInfoToast(context, 'Oh, Oh...', 'Contraseña incorrecta.');
        Navigator.pop(context);
      } else {
        AllToast.showInfoToast(
            context, 'Oh, Oh...', 'Credenciales desconocidas');
        Navigator.pop(context);
      }
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
                      'Inicia sesión',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 30),
                    _campoEmail(),
                    const SizedBox(height: 30),
                    _campoPassword(),
                    const SizedBox(height: 40),
                    _goButtom('Iniciar'),
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
          AllToast.showDangerousToast(context, 'Oh, Oh...', 'No hay conexión');
          return;
        }
        // Validar el campos
        if (!emailController.text.contains('@')) {
          AllToast.showInfoToast(context, 'Oh, Oh..', 'Email no válido');
          return;
        }
        if (passwordController.text.length < 6) {
          AllToast.showInfoToast(context, 'Oh, Oh..', 'Contraceña no válida');
          return;
        }
        singIn(context);
      },
    );
  }

  Widget _goToRegister(BuildContext context) {
    return TextButton(
      child: const Text('¿No tienes una cuenta? Registrate!'),
      onPressed: () {
        Navigator.pushNamed(context, 'selectRegister');
      },
    );
  }
}
