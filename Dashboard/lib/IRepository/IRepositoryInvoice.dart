import 'package:image_picker/image_picker.dart';

import '../Models/InvoiceModel.dart';

abstract class IRepositoryInvoice {
  Future<InvoiceModel> create(InvoiceModel invoiceModel, XFile file);
  Future<List<InvoiceModel>> getInvoiceByUserId(String id);
  Future<List<InvoiceModel>> getAllInvoice();
  Future<void> updateInvoice(String id);
  Future<void> deleteInvoice(String id);
}
