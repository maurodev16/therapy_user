

import 'InvoiceModel.dart';

class UserModel {
  String? userId;
  int? clientNumber;
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? phone;
  String? token;
  String? userType;
  List<InvoiceModel>? invoiceObj;
  int? invoiceQnt;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.userId,
    this.clientNumber,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.token,
    this.userType,
    this.invoiceObj,
    this.invoiceQnt,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      clientNumber: json['client_number'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      token: json['token'],
      invoiceObj:json['invoice_obj'] != null
        ? (json['invoice_obj'] as List<dynamic>)
            .map((serviceTypeJson) => InvoiceModel.fromJson(serviceTypeJson))
            .toList()
        : null, 
        invoiceQnt: json['invoice_qnt'],
      userType: json['user_type'] = 'client',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'client_number': clientNumber,
      'first_name': firstname,
      'last_name': lastname,
      'email': email,
      'phone': phone,
      'password': password,
      'token': token,
      'invoice_obj': invoiceObj,
      'invoice_qnt':invoiceQnt,
      'user_type': userType,
    };
  }
}
