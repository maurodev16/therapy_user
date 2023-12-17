import 'package:get/get.dart';
import 'package:therapy_user/Controller/AuthController.dart';

import '../IRepository/IRepositoryInvoice.dart';
import '../Models/AppointmentModel.dart';
import '../Models/InvoiceModel.dart';

class InvoiceController extends GetxController
    with StateMixin<List<InvoiceModel>> {
  final IRepositoryInvoice _repositoryInvoice;
  InvoiceController(this._repositoryInvoice);
  static InvoiceController get to => Get.find();
  final AuthController authController = Get.find();
  List<InvoiceModel> allInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> openInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> paidInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> stornedInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> overdueInvoices = <InvoiceModel>[].obs;
  RxBool isAllInvoiceLoading = false.obs;
  RxBool isOpenInvoicesLoading = false.obs;
  RxBool isPaidInvoicesLoading = false.obs;
  RxBool isStornedInvoicesLoading = false.obs;
  RxBool isOverdueInvoicesLoading = false.obs;

  late Rx<InvoiceModel> _invoiceModel = InvoiceModel().obs;
  Rx<InvoiceModel> get getInvoiceData => this._invoiceModel;
  set setInvoiceData(Rx<InvoiceModel> invoiceData) =>
      this._invoiceModel = invoiceData;

  @override
  void onInit() async {
    await getSeparateInvoice(authController.getUserData.value.userId!);
    super.onInit();
  }

  Rx<AppointmentModel> appointmentModel = AppointmentModel().obs;
// Método para receber os dados do agendamento
  void receiveAppointmentData(AppointmentModel appointment) {
    appointmentModel.value = appointment;
    print(
        "Dados do agendamento recebidos: ${appointment.userModel?.firstname}, ${appointment.id},");
    print("${appointmentModel.value.id}");
  }

  // Método para separar os pagamentos vencidos e os pedidos de estorno
  Future<List<InvoiceModel>> getSeparateInvoice(String userId) async {
    isAllInvoiceLoading.value = true;
    isOpenInvoicesLoading.value = true;
    isPaidInvoicesLoading.value = true;
    isStornedInvoicesLoading.value = true;
    isOverdueInvoicesLoading.value = true;

    try {
      var response = await _repositoryInvoice.getInvoiceByUserId(userId);
      if (response.isNotEmpty) {
        allInvoices.clear();
        openInvoices.clear();
        paidInvoices.clear();
        stornedInvoices.clear();
        overdueInvoices.clear();
        for (InvoiceModel invoice in response) {
          allInvoices.add(invoice);
          if (invoice.userObj!.userId == userId) {
            invoice.invoiceStatus!.contains("open")
                ? openInvoices.add(invoice)
                : invoice.invoiceStatus!.contains("paid")
                    ? paidInvoices.add(invoice)
                    : invoice.invoiceStatus!.contains("refunded")
                        ? stornedInvoices.add(invoice)
                        : invoice.invoiceStatus!.contains("overduo")
                            ? overdueInvoices.add(invoice)
                            : allInvoices.add(invoice);
          }
        }
        change(response, status: RxStatus.success());
      } else {
        change([], status: RxStatus.empty());
        allInvoices = [];
        openInvoices = [];
        paidInvoices = [];
        stornedInvoices = [];
        overdueInvoices = [];
        return [];
      }
    } catch (e) {
      change([], status: RxStatus.error());
      print(e.toString());
    } finally {
      isAllInvoiceLoading.value = false;
      isOpenInvoicesLoading.value = false;
      isPaidInvoicesLoading.value = false;
      isStornedInvoicesLoading.value = false;
      isOverdueInvoicesLoading.value = false;
      update();
    }
    return allInvoices;
  }
}
