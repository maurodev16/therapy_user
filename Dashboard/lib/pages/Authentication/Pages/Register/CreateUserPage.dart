import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Controller/UserController.dart';
import '../../../../GlobalWidgets/loadingWidget.dart';
import '../../../../Utils/Colors.dart';

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
          color: vermelho,
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
                Hero(tag: "tagLogo", child: Text("[LOGO]")),

                // height: 100,
                //  ),
                SizedBox(height: 0.03 * Get.height),

                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: vermelho),
                      enabled: !controller.isLoading.value,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorFirstName,
                        labelText: 'Vorname'.tr,
                        labelStyle:
                            GoogleFonts.lato(color: vermelho, fontSize: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
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
                            color: vermelho,
                            width: 1,
                          ),
                        ),
                        suffixIcon: controller.validateFirstName
                            ? Icon(Icons.check_circle_outline_rounded,
                                color: vermelho)
                            : null,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.firstname.value = value;
                        print(controller.firstname.value);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 0.03 * Get.height),

                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: vermelho),
                      enabled: !controller.isLoading.value,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorLastName,
                        labelText: 'Nachname'.tr,
                        labelStyle:
                            GoogleFonts.lato(color: vermelho, fontSize: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
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
                            color: vermelho,
                            width: 1,
                          ),
                        ),
                        suffixIcon: controller.validateLastname
                            ? Icon(Icons.check_circle_outline_rounded,
                                color: vermelho)
                            : null,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.lastname.value = value;
                        print(controller.lastname.value);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 0.03 * Get.height),

                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: vermelho),
                      enabled: !controller.isLoading.value,
                      keyboardType: TextInputType.phone,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorPhone,
                        labelText: 'Phone'.tr,
                        labelStyle:
                            GoogleFonts.lato(color: vermelho, fontSize: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
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
                            color: vermelho,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.phone.value = value;
                        print(controller.phone.value);
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
                      style: TextStyle(color: vermelho),
                      enabled: !controller.isLoading.value,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        fillColor: branco,
                        errorText: controller.errorEmail,
                        labelText: 'Email'.tr,
                        labelStyle:
                            GoogleFonts.lato(color: vermelho, fontSize: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1,
                          ),
                        ),
                        suffixIcon: controller.validateEmail
                            ? Icon(Icons.check_circle_outline_rounded,
                                color: vermelho)
                            : null,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.email.value = value;
                        print(controller.email.value);
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: vermelho),
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
                                  color: vermelho,
                                )
                              : Icon(Icons.visibility_off_outlined,
                                  color: vermelho),
                        ),
                        labelText: 'Passwort'.tr,
                        labelStyle:
                            GoogleFonts.lato(color: vermelho, fontSize: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.password.value = value;
                        print(controller.password.value);
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  width: 0.95 * Get.width,
                  child: Obx(
                    () => TextFormField(
                      style: TextStyle(color: vermelho),
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
                                  color: vermelho,
                                )
                              : Icon(
                                  Icons.visibility_off_outlined,
                                  color: vermelho,
                                ),
                        ),
                        labelText: 'Bestätige das Passwort'.tr,
                        labelStyle:
                            GoogleFonts.lato(color: vermelho, fontSize: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: vermelho,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      onChanged: (value) {
                        controller.confirmPassword.value = value;
                        print(controller.confirmPassword.value);
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
                              await controller.signupUser();
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
                                  ? [vermelho, vermelho]
                                  : [cinza, cinza]),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: controller.isLoading.value
                              ? loadingWidget()
                              : Text(
                                  'Registrieren',
                                  style: GoogleFonts.lato(
                                      color: branco, fontSize: 16.0),
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
