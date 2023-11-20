import 'UserModel.dart';

class InvoiceModel {
  UserModel? userObj;
  String? invoiceUrl;
  DateTime? overDuo;
  String? invoiceStatus;

  InvoiceModel(
      {this.userObj, this.invoiceUrl, this.overDuo, this.invoiceStatus});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      userObj: UserModel.fromJson(json['user_obj']),
      invoiceUrl: json['invoice_url'],
      overDuo:
          json['over_duo'] != null ? DateTime.parse(json['over_duo']) : null,
      invoiceStatus: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user_obj': userObj!.toJson(),
      'invoice_url': invoiceUrl,
      'over_duo': overDuo!.toIso8601String(),
      'status': invoiceStatus,
    };
  }
}
