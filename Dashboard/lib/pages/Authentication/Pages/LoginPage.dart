import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:therapy_dashboard/Utils/Colors.dart';
import 'package:therapy_dashboard/pages/Authentication/Pages/Register/CreateUserPage.dart';

import '../../../Controller/AuthController.dart';
import '../../../GlobalWidgets/loadingWidget.dart';

class LoginPage extends GetView<AuthController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.isLoadingLogin.value
          ? Center(
              child: loadingWidget(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.2),
                      Hero(
                          tag: "tagLogo",
                          child: Text(
                            "Dasboard",
                            style: GoogleFonts.tajawal(
                                fontSize: 35, color: vermelho),
                          )),
                      SizedBox(height: Get.height * 0.1),

                      Container(
                        width: 0.95 * Get.width,
                        child: Obx(
                          () => TextFormField(
                            style: TextStyle(color: vermelho),
                            enabled: !controller.isLoadingLogin.value,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              fillColor: branco,
                              errorText: controller.errorEmail,
                              labelText: 'Email'.tr,
                              labelStyle: TextStyle(
                                fontFamily: "HelveticaNeue",
                                fontWeight: FontWeight.w400,
                                color: preto,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: cinza,
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
                              suffixIcon: controller.validateEmail
                                  ? Icon(Icons.mark_email_read_outlined,
                                      size: 20, color: vermelho)
                                  : Icon(Icons.email_outlined,
                                      size: 20, color: vermelho),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                            ),
                            onChanged: (value) {
                              controller.email!.value =
                                  value; //clientNumberOrEmail
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
                            enabled: !controller.isLoadingLogin.value,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              fillColor: branco,
                              errorText: controller.errorPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.togglePasswordVisibility();
                                },
                                icon: controller.isPasswordVisible.value
                                    ? Icon(
                                        Icons.visibility_outlined,
                                        size: 20,
                                        color: preto,
                                      )
                                    : Icon(
                                        Icons.visibility_off_outlined,
                                        size: 20,
                                        color: vermelho,
                                      ),
                              ),
                              labelText: 'Password'.tr,
                              labelStyle: TextStyle(
                                fontFamily: "HelveticaNeue",
                                fontWeight: FontWeight.w400,
                                color: preto,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: cinza,
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
                                  color: preto,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                            ),
                            onChanged: (value) {
                              controller.password!.value = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontWeight: FontWeight.bold,
                                  color: vermelho,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Container(
                              child: TextButton(
                                child: Text(
                                  "Remember",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontWeight: FontWeight.bold,
                                    color: vermelho,
                                    fontSize: 10,
                                  ),
                                ),
                                onPressed: () {
                                  Get.bottomSheet(
                                      isDismissible: false,
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Container(
                                          height: Get.height * 0.2,
                                          child: Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                  title: Text(
                                                    'Digite aqui o email que voce utilizou para se cadastrar',
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                  trailing: Icon(
                                                    IconlyLight.close_square,
                                                    color: vermelho,
                                                  ),
                                                  onTap: () => {Get.back()}),
                                              Container(
                                                width: 0.95 * Get.width,
                                                child: Obx(
                                                  () => TextFormField(
                                                    enabled: !controller
                                                        .isLoadingLogin.value,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      errorText:
                                                          controller.errorEmail,
                                                      fillColor: vermelho,
                                                      labelText: 'Email'.tr,
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            "HelveticaNeue",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black54,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide: BorderSide(
                                                          color: cinza,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide: BorderSide(
                                                          color: vermelho,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide: BorderSide(
                                                          color: vermelho,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      suffixIcon: controller
                                                              .validateEmail
                                                          ? Icon(Icons
                                                              .mark_email_read_outlined)
                                                          : Icon(Icons
                                                              .email_outlined),
                                                      filled: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 16.0,
                                                              horizontal: 16.0),
                                                    ),
                                                    onChanged: (value) {
                                                      controller.email!.value =
                                                          value;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {},
                                                leading: Icon(
                                                  IconlyLight.send,
                                                  color: verde,
                                                  size: 30,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      backgroundColor: Colors.white);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      Obx(
                        () => SizedBox(
                          width: 0.95 * Get.width,
                          child: ElevatedButton(
                            onPressed: controller.loginButtonEnabled!
                                ? () async {
                                    await controller.login();
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
                                    colors: controller.loginButtonEnabled!
                                        ? [verde, verde]
                                        : [cinza, cinza]),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: preto,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Botão de Registro

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "You don`t have an account?",
                              style: TextStyle(
                                fontFamily: "HelveticaNeue",
                                fontWeight: FontWeight.bold,
                                color: vermelho,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            child: TextButton(
                                child: Text(
                                  "Create now",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontWeight: FontWeight.bold,
                                    color: vermelho,
                                    fontSize: 10,
                                  ),
                                ),
                                onPressed: () {
                                  controller.cleanInputs();
                                  Get.to(() => CreateUserPage());
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
