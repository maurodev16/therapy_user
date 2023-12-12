import 'AppointmentModel.dart';
import 'UserModel.dart';

class InvoiceModel {
  String? id;
  UserModel? userObj;
  String? invoiceUrl;
  DateTime? overDuo;
  AppointmentModel? appointmentObj;
  String? invoiceStatus;
  String? createBy;

  InvoiceModel({
    this.id,
    this.userObj,
    this.invoiceUrl,
    this.overDuo,
    this.invoiceStatus,
    this.appointmentObj,
    this.createBy,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['_id'],
      userObj: json['user_obj'] != null
          ? UserModel.fromJson(json['user_obj'])
          : null,
      invoiceUrl: json['invoice_url'],
      overDuo:
          json['over_duo'] != null ? DateTime.parse(json['over_duo']) : null,
      invoiceStatus: json['status'],
      appointmentObj:
          json['appointment_obj'] != null ? json['appointment_obj'] : null,
      createBy: json['create_by'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_obj': userObj?.toJson(),
      'invoice_url': invoiceUrl,
      'over_duo': overDuo!.toIso8601String(),
      'status': invoiceStatus,
      'appointment_obj': appointmentObj,
      'create_by': createBy,
    };
  }
}
