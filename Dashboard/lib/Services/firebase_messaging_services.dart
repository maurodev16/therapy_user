import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
  // Obtém o token FCM do dispositivo
  Future<void> _getDeviceFirebaseToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }

  // Configura o handler para mensagens abertas enquanto o aplicativo está aberto
  Future<void> _configureMessageOpenHandler() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Lógica para manipular mensagens abertas enquanto o aplicativo está aberto
    });
  }

  // Inicialização do serviço de mensagens Firebase
  Future<void> initialize() async {
    await _configureForegroundOptions();
    await _getDeviceFirebaseToken();
    await _setupMessageHandlers();
  }

  // Configuração das opções de notificação em primeiro plano
  Future<void> _configureForegroundOptions() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Configura os handlers de mensagens
  Future<void> _setupMessageHandlers() async {
    await _configureMessageOpenHandler();
    await _configureMessageBackgroundHandler();
  }

  // Configura o handler para mensagens em segundo plano
  Future<void> _configureMessageBackgroundHandler() async {
    Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage((message) async {
      // Lógica para manipular mensagens em segundo plano
      print("Handling a background message: ${message.messageId}");
      // Reagir à notificação, se houver
    });
  }

  // Configura o handler para mensagens recebidas enquanto o aplicativo está em primeiro plano
  void configureMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Lógica para manipular mensagens recebidas enquanto o aplicativo está em primeiro plano
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Lógica para manipular notificações específicas do Android
      }

      print("Mensagem recebida: ${message.notification!.body}");
    });
  }

  // Exibir notificação local usando flutter_local_notifications
  Future<void> showLocalNotification(RemoteNotification notification) async {
    var android = AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      subtitle: 'NEW Termin', // Subtítulo da notificação
      sound: null, // Arquivo de som a ser reproduzido com a notificação
      badgeNumber: 1, // Número para aparecer no ícone do aplicativo (badge)
// Tocar som
      categoryIdentifier:
          'your_category_id', // Categoria da notificação (pode ser usada para ações específicas)
      threadIdentifier:
          'your_thread_id', // Identificador de thread (usado para agrupar notificações)
    );

    var platform = NotificationDetails(android: android, iOS: iOS);
    await fln.show(
      0,
      notification.title,
      notification.body,
      platform,
      payload: 'custom_payload',
    );
  }
}
