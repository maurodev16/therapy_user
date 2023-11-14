import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:therapy_user/GlobalWidgets/loadingWidget.dart';
import 'package:therapy_user/Utils/Colors.dart';

import '../../../../Controller/UserController.dart';

class CreateUserPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<UserController>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios_outlined),
            onTap: () {
              Get.back();
              controller.cleanInputs();
            }),
        elevation: 0,
        iconTheme: IconThemeData(
          color: verde,
          size: 25,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0.05 * Get.height),
                //  Logo
                //Image.asset(
                          Hero(tag: "tagLogo", child:  FlutterLogo(size: 50)) ,

                // height: 100,
                //  ),
                SizedBox(height: 0.03 * Get.height),

                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: verde),
                      enabled: !controller.isLoading.value,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorFirstName,
                        labelText: 'First name'.tr,
                        labelStyle: TextStyle(
                          fontFamily: "HelveticaNeue",
                          fontWeight: FontWeight.w400,
                          color: verde,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: preto,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1,
                          ),
                        ),
                        suffixIcon: controller.validateFirstName
                            ? Icon(Icons.check_circle_outline_rounded,
                                color: verde)
                            : null,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.firstname.value = value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 0.03 * Get.height),

                ///
                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: verde),
                      enabled: !controller.isLoading.value,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorEmail,
                        labelText: 'Email'.tr,
                        labelStyle: TextStyle(
                          fontFamily: "HelveticaNeue",
                          fontWeight: FontWeight.w400,
                          color: verde,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1,
                          ),
                        ),
                        suffixIcon: controller.validateEmail
                            ? Icon(Icons.check_circle_outline_rounded,
                                color: verde)
                            : null,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.email.value = value;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: verde),
                      enabled: !controller.isLoading.value,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorPasswordSignup,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                          icon: controller.isPasswordVisible.value
                              ? Icon(
                                  Icons.visibility_outlined,
                                  color: verde,
                                )
                              : Icon(Icons.visibility_off_outlined,
                                  color: verde),
                        ),
                        labelText: 'Password'.tr,
                        labelStyle: TextStyle(
                          fontFamily: "HelveticaNeue",
                          fontWeight: FontWeight.w400,
                          color: verde,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.password.value = value;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: verde),
                      enabled: !controller.isLoading.value,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorConfPasswordSignup,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                          icon: controller.isPasswordVisible.value
                              ? Icon(
                                  Icons.visibility_outlined,
                                  color: verde,
                                )
                              : Icon(
                                  Icons.visibility_off_outlined,
                                  color: verde,
                                ),
                        ),
                        labelText: 'Confirm Password'.tr,
                        labelStyle: TextStyle(
                          fontFamily: "HelveticaNeue",
                          fontWeight: FontWeight.w400,
                          color: verde,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: verde,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.confirmPassword.value = value;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 30),
                // Botão de Registro
                Obx(
                  () => SizedBox(
                    width: 0.95 * Get.width,
                    child: ElevatedButton(
                      onPressed: controller.enableButton
                          ? () async {
                              await controller.signupUser().then(
                                (value) {
                                  if (value.userId != "" &&
                                      value.userId != null) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Hello ${value.firstname} ${value.lastname}, welcome to our app."
                                                .tr);
                                    Get.toNamed('/login_page');
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "An error is sended.".tr);
                                    Get.toNamed('/create_user_page');
                                  }
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: EdgeInsets.all(0),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: controller.enableButton
                                  ? [verde, verde]
                                  : [cinza, cinza]),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: controller.isLoading.value
                              ? LoadingWidget()
                              : Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
