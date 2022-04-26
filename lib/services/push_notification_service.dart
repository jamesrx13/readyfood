import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messageStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStream.add(message.notification!.title.toString());
  }

  static Future _onMessgeHandler(RemoteMessage message) async {
    _messageStream.add(message.notification!.title.toString());
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    _messageStream.add(message.notification!.title.toString());
  }

  static Future initializeApp() async {
    // Push notification
    await Firebase.initializeApp();
    Firebase.app();

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessgeHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future<String> getCellphoneToken() async {
    token = await FirebaseMessaging.instance.getToken();
    // print('😂😂😂 CLASE PRINCIPAL' + token.toString());
    return token.toString();
  }

  static closestream() {
    _messageStream.close();
  }
}



// POST https://fcm.googleapis.com/fcm/send

// key=AAAAX5M8JgM:APA91bFrYN8MChu6azONAa6vmt2Ral5OyBI06Otoc_Q3jIrhnogWZ14IqdW0H3PkCanDHxEv6j_IEQOe1Um8OmAXP97wPOsXZUCkke__5of0gpBDZ_P0HuLiY_qGO-VZxxBPT5N_EQR7

// {
//     "notification" : {
//         "body" : "Notificación desde la API rest",
//         "title" : "Titulo"

//     },
//     "to" : "c2Kdq0CHSA6AconDn1JQUs:APA91bHcZY-cEbLNcBx02_UuGhkvG1FRi044P5rNheMHoicswKrKp_mCfOM3RdvuvsDht4Y_-K947lOYnKg1aIQatOmFRaR7Wre5omWGcRxolKvRYeVeSG1O1lN7N7Sx8ep8vM8Rd0Yp"
// }