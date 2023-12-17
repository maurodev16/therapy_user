import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therapy_dashboard/Utils/Colors.dart';

import '../../../../Controller/InvoiceController.dart';

class ActionsDotWidget extends GetView<InvoiceController> {
  ActionsDotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Obx(
                    () => Badge.count(
                      count: controller.openInvoices.length,
                      child: Icon(
                        Icons.pending,
                        size: 25,
                        color: verde,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Obx(
                    () => Badge.count(
                      count: controller.paidInvoices.length,
                      child: Icon(
                        Icons.pending,
                        size: 25,
                        color: amarelo,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Obx(
                    () => Badge.count(
                      count: controller.stornedInvoices.length,
                      child: Icon(
                        Icons.pending,
                        size: 25,
                        color: azul,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Obx(
                    () => Badge.count(
                      count: controller.overdueInvoices.length,
                      child: Icon(
                        Icons.pending,
                        size: 25,
                        color: preto,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
