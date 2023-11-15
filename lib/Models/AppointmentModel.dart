import 'package:therapy_user/Models/UserModel.dart';

import 'PaymentModel.dart';
import 'RelatedDocumentsModel.dart';
import 'ServiceTypeModel.dart';

class AppointmentModel {
  String? id;
  DateTime? date;
  DateTime? time;
  String? notes;
  UserModel? userModel;
  List<ServiceTypeModel>? serviceTypeModel;
  List<PaymentModel>? paymentModel;
  List<RelatedDocumentsModel>? relatedDocumentsModel;
  bool? isCanceled;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  AppointmentModel({
    this.id,
    this.date,
    this.time,
    this.notes,
    this.userModel,
    this.serviceTypeModel,
    this.paymentModel,
    this.relatedDocumentsModel,
    this.isCanceled,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      notes: json['notes'],
      userModel: UserModel.fromJson(json['user_obj']),
      serviceTypeModel: List<ServiceTypeModel>.from(
          json['service_type_obj'].map((x) => ServiceTypeModel.fromJson(x))),
      paymentModel: List<PaymentModel>.from(
          json['Payment_obj'].map((x) => PaymentModel.fromJson(x))),
      relatedDocumentsModel: List<RelatedDocumentsModel>.from(
          json['related_documents_obj']
              .map((x) => RelatedDocumentsModel.fromJson(x))),
      isCanceled: json['is_canceled'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date!.toIso8601String(),
      'time': time!.toIso8601String(),
      'notes': notes,
      'user_obj': userModel!.toJson(),
      'service_type_obj':
          List<dynamic>.from(serviceTypeModel!.map((x) => x.toJson())),
      'Payment_obj': List<dynamic>.from(paymentModel!.map((x) => x.toJson())),
      'related_documents_obj':
          List<dynamic>.from(relatedDocumentsModel!.map((x) => x.toJson())),
      'is_canceled': isCanceled,
      'status': status,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

