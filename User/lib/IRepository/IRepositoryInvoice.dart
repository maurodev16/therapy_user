
import '../Models/InvoiceModel.dart';
abstract class IRepositoryInvoice {
  Future<List<InvoiceModel>> getInvoiceByUserId(String id);
}
