import 'package:get/get.dart';

import '../Models/InvoiceModel.dart';

class InvoiceController extends GetxController with StateMixin<List<InvoiceModel>> {
  static InvoiceController get to => Get.find();
  late final List<InvoiceModel> pendingInvoice;
  @override
  void onInit() async {
   
    await separateInvoice();
    super.onInit();
  }

  List<InvoiceModel> overdueInvoice = <InvoiceModel>[].obs;
  List<InvoiceModel> refundRequests = <InvoiceModel>[].obs;


  bool isPaymentDue(InvoiceModel invoice) {
    // Verifica se a data de vencimento é anterior à data atual
    return invoice.overDuo!.isBefore(DateTime.now());
  }

  // Método para separar os pagamentos vencidos e os pedidos de estorno
  Future<void> separateInvoice() async {
    for (InvoiceModel invoice in pendingInvoice) {
      bool isDue = isPaymentDue(invoice);
      if (isDue) {
        // Adicionar à lista de pagamentos vencidos
        overdueInvoice.add(invoice);
      } else {
        // Adicionar à lista de pedidos de estorno (se necessário)
        if (invoice.invoiceStatus == 'refund') {
          refundRequests.add(invoice);
        }
      }
      update();
    }
  }
}
