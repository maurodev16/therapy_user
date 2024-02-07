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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///await Firebase.initializeApp();
  await initializeDateFormatting();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

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
