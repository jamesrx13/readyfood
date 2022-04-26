import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:ready_food/pages/analitics_page.dart';
import 'package:ready_food/pages/restaurant_history_page.dart';
import 'package:ready_food/pages/restaurant_home_page.dart';
import 'package:ready_food/pages/login_page.dart';
import 'package:ready_food/pages/my_qr_code_page.dart';
import 'package:ready_food/pages/restaurant_register_page.dart';
import 'package:ready_food/pages/worker_home_page.dart';
import 'package:ready_food/pages/worker_register_page.dart';
import 'package:ready_food/pages/select_register.dart';
import 'package:ready_food/pages/start_page.dart';
import 'package:ready_food/services/push_notification_service.dart';
import 'package:ready_food/utils/all_toast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await PushNotificationServices.initializeApp();
  try {
    await Firebase.initializeApp(
        name: 'ReadyFood',
        options: Platform.isIOS
            ? const FirebaseOptions(
                apiKey: 'AIzaSyC9PCoD4Ldjec-8xSgf0qFV_ejUm_rwNI8',
                appId: '1:410492085763:android:3f51eb2e879b8a28db5036',
                messagingSenderId: '410492085763',
                projectId: 'ready-food-7ca77',
                databaseURL:
                    'https://ready-food-7ca77-default-rtdb.firebaseio.com',
              )
            : const FirebaseOptions(
                apiKey: 'AIzaSyC9PCoD4Ldjec-8xSgf0qFV_ejUm_rwNI8',
                appId: '1:410492085763:android:3f51eb2e879b8a28db5036',
                messagingSenderId: '410492085763',
                projectId: 'ready-food-7ca77',
                databaseURL:
                    'https://ready-food-7ca77-default-rtdb.firebaseio.com',
              ));
  } catch (e) {
    Firebase.app();
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => DrawerMenuState(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> messengerKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    PushNotificationServices.messageStream.listen((message) async {
      BuildContext customContext =
          messengerKey.currentState?.context ?? context;
      AllToast.showInfoToast(customContext, 'Notificación', message);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Colocar la barra de notificaciones transparente
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    // Bloquear la rotación de la aplicación
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ready Food',
      initialRoute: 'start',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      navigatorKey: messengerKey,
      routes: {
        '/': (_) => const HomePage(),
        'start': (_) => const StartPage(),
        'login': (_) => const LoginPage(),
        'trabajador': (_) => const WorkerRegisterPage(),
        'restaurant': (_) => const RestaurantRegisterPage(),
        'selectRegister': (_) => const SelectRegisterPage(),
        '/worker': (_) => const WorkerHomePage(),
        'myqr': (_) => const MyQrCodePage(restaurantName: 'NO HAST'),
        'analitics': (_) => const AnaliticPage(),
        'history': (_) => const HistoriPage(),
      },
    );
  }
}
