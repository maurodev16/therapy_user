import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/Controller/AuthController.dart';
import 'package:therapy_user/IRepository/IRepositoryAuth.dart';
import 'package:upgrader/upgrader.dart';

import 'BottomNavigationBar/BottomNavigationBar.dart';
import 'Controller/UserController.dart';
import 'IRepository/IRepositoryUser.dart';
import 'MyBindings/Mybindings.dart';
import 'Repository/RepositoryUser.dart';
import 'Repository/RespositoryAuth.dart';
import 'Routers/AppRouters.dart';
import 'Utils/Colors.dart';
import 'pages/Authentication/Pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");

  await GetStorage.init();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  MainApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
        Get.put<IRepositoryUser>(RepositoryUser());
    Get.put<IRepositoryAuth>(RepositoryAuth());
  Get.put<AuthController>(AuthController(Get.find()), permanent: true);
    Get.put<UserController>(UserController(Get.find()), permanent: true);

    return Obx(()  =>GetMaterialApp(
        key: GlobalKey(),
        initialBinding: MyBinding(),
        initialRoute: Get.find<AuthController>()
.getUserData.value.userId == '' ||
                 Get.find<AuthController>().getUserData.value.userId == null
            ? AppRoutes.CREATE_USER_PAGE
            : AppRoutes.HOME_PAGE,
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
          child:  Get.find<AuthController>().isLoggedIn.value
              ? BottomNavigationWidget()
              : LoginPage(),
        ),
       getPages: AppRoutes.pages,
      ),
    ); 
  }
}
