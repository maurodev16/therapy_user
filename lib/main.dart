import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:therapy_user/Controller/AuthController.dart';
import 'package:upgrader/upgrader.dart';

import 'BottomNavigationBar/BottomNavigationBar.dart';
import 'MyBindings/Mybindings.dart';
import 'Repository/RespositoryAuth.dart';
import 'Routers/AppRouters.dart';
import 'Utils/Colors.dart';
import 'pages/Authentication/Pages/LoginPage.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();
  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);
  Future<void> _firebaseBGH(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Lógica para manipular mensagens em segundo plano
    print("Handling a background message: ${message.data}");
    // Reagir à notificação, se houver
    _showNotification(message);
  }

  // Inicializar o pacote de notificações locais
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  try {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
  } catch (e) {
    print("Error getting FCM Token: $e");
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("onMessageOpenedApp: $message");
  });

  FirebaseMessaging.onBackgroundMessage((_firebaseBGH));

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Mensagem recebida: $message");

    // Acessar dados específicos da mensagem
    Map<String, dynamic>? messageData = message.data;
    print("Dados da mensagem: $messageData");

    // Exemplo de acesso a dados específicos, como título e corpo da notificação
    String? title = messageData['title'];
    String? body = messageData['body'];
    String? appointmentId = messageData['appointmentId'];

    if (title != null && body != null && appointmentId != null) {
      print("Título: $title, Corpo: $body, Appointment ID: $appointmentId");

      // Aqui você pode realizar ações com base nos dados recebidos
      // por exemplo, mostrar uma notificação local, navegar para uma tela específica, etc.
      _showNotification(message);
    }

    // Lógica adicional conforme necessário
  });

  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  /// GetStorage().erase();
  runApp(MainApp());
}

Future<void> _showNotification(RemoteMessage message) async {
  // Configurar a notificação local
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Exibir a notificação local
  await FlutterLocalNotificationsPlugin().show(
    0, // ID da notificação, deve ser único
    message.notification!.title, // Título da notificação
    message.notification!.body, // Corpo da notificação
    platformChannelSpecifics,
  );
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController =
        Get.put<AuthController>(AuthController(RepositoryAuth()));
    return GetBuilder<AuthController>(builder: (_) {
      return GetMaterialApp(
        key: GlobalKey(),
        initialBinding: MyBinding(),
        locale: Locale('de', 'DE'),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.zoom,
        // translations: TranslationService(),
        //  locale: TranslationService.locale,
        // fallbackLocale: TranslationService.fallbackLocale,
        theme: Theme.of(context).copyWith(
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: verde,
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: verde,
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
              ),
        ),
        home: UpgradeAlert(
          upgrader: Upgrader(
              // messages: MySpanishMessages(),
              dialogStyle: GetPlatform.isAndroid
                  ? UpgradeDialogStyle.material
                  : UpgradeDialogStyle.cupertino),
          child: Obx(
            () {
              return authController.isLoggedIn.value
                  ? BottomNavigationWidget()
                  : LoginPage();
            },
          ),
        ),
        getPages: AppRoutes.pages,
      );
    });
  }
}
