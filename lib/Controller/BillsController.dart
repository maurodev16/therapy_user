import 'package:get/get.dart';

import '../Models/BillsModel.dart';

class BillsController extends GetxController {
  late final List<BillModel> pendingBills;  
  List<BillModel> overdueBills = <BillModel>[].obs;
  List<BillModel> refundRequests = <BillModel>[].obs;
  @override
  void onInit() async {
    pendingBills = getBillsByStatus('pending');
    await separateBills();
    super.onInit();
  }

  List<BillModel> getBillsByStatus(String status) {
    return [
      BillModel(
          name: 'Rechnungs 1',
          amount: 100.0,
          dueDate: DateTime(2023, 11, 01),
          status: status),
      BillModel(
          name: 'Rechnungs 2',
          amount: 200.0,
          dueDate: DateTime(2023, 11, 02),
          status: status),
      BillModel(
          name: 'Rechnungs 3',
          amount: 300.0,
          dueDate: DateTime(2023, 11, 03),
          status: status),
      BillModel(
          name: 'Rechnungs 4',
          amount: 400.0,
          dueDate: DateTime(2023, 11, 09),
          status: status),
      BillModel(
          name: 'Rechnungs 5',
          amount: 500.0,
          dueDate: DateTime(2023, 11, 11),
          status: status),
      BillModel(
          name: 'Rechnungs 6',
          amount: 600.0,
          dueDate: DateTime(2023, 11, 12),
          status: status),
      BillModel(
          name: 'Rechnungs 7',
          amount: 700.0,
          dueDate: DateTime(2023, 11, 13),
          status: status),
      BillModel(
          name: 'Rechnungs 8',
          amount: 800.0,
          dueDate: DateTime(2023, 11, 14),
          status: status),
      BillModel(
          name: 'Rechnungs 9',
          amount: 900.0,
          dueDate: DateTime(2023, 11, 15),
          status: status),
    ].obs;
  }

  bool isPaymentDue(BillModel bill) {
    // Verifica se a data de vencimento é anterior à data atual
    return bill.dueDate.isBefore(DateTime.now());
  }

  // Método para separar os pagamentos vencidos e os pedidos de estorno
  Future<void> separateBills() async {
    for (BillModel bill in pendingBills) {
      bool isDue = isPaymentDue(bill);
      if (isDue) {
        // Adicionar à lista de pagamentos vencidos
        overdueBills.add(bill);
      } else {
        // Adicionar à lista de pedidos de estorno (se necessário)
        if (bill.status == 'refund') {
          refundRequests.add(bill);
        }
      }
      update();
    }
  }
}
