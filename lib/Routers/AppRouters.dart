
import 'package:get/get.dart';
import 'package:therapy_user/pages/AppointmentPage.dart';

import '../Pages/Authentication/Pages/LoginPage.dart';
import '../pages/Authentication/Pages/Register/CreateUserPage.dart';
import '../pages/HomePage.dart';
import '../pages/ProfilePage.dart';

class AppRoutes {
  static const LOGIN_PAGE = '/login_page';
  static const CREATE_USER_PAGE = '/create_user_page';
  static const HOME_PAGE = '/home_page';
static const APPOINMENT_PAGE = '/appointment_age';
  static const AUTH_ONBOARD_PAGE = '/auth_onboard_page';
  static const GENERAL_POSTS_PAGE = '/general_events_page';
  static const PROFILE_PAGE = '/profile_page';
  static const LANGUAGE_PAGE = '/language_page';
  static const THEME_PAGE = '/theme_page';

  static final pages = [
    GetPage(name: LOGIN_PAGE, page: () => LoginPage()),

    ///
    GetPage(name: CREATE_USER_PAGE, page: () => CreateUserPage()),

    // 
    GetPage(name: APPOINMENT_PAGE, page: ()=> AppointmentPage()),
    ///
    // GetPage(name: AUTH_ONBOARD_PAGE, page: () => AuthOnboardPage()),

    ///
    GetPage(name:HOME_PAGE, page: () => HomePage()),

    ///
    GetPage(name: PROFILE_PAGE, page: () => ProfilePage()),

    ///
   // GetPage(name: LANGUAGE_PAGE, page: () => LanguagePage()),

  ];
}
