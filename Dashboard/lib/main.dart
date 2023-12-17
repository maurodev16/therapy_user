import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:upgrader/upgrader.dart';

import 'BottomNavigationBar/BottomNavigationBar.dart';
import 'Controller/AuthController.dart';
import 'MyBindings/Mybindings.dart';
import 'Repository/RespositoryAuth.dart';
import 'Utils/Colors.dart';
import 'pages/Authentication/Pages/LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await initializeDateFormatting();
  await settingOneSignal();

  //GetStorage().erase();
  runApp(MainApp());
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
                  statusBarColor: vermelho,
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: vermelho,
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
              ),
        ),
        home: UpgradeAlert(
          upgrader: Upgrader(
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
      );
    });
  }
}

Future<void> settingOneSignal() async {
  OneSignal.initialize(dotenv.env["ONESIGNAL_APP_ID"]!);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  // await OneSignal.Notifications.requestPermission(true);
}
