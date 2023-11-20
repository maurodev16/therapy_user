import 'package:therapy_user/Models/UserModel.dart';

import 'RelatedDocumentsModel.dart';
import 'ServiceTypeModel.dart';

class AppointmentModel {
  String? id;
  DateTime? date;
  DateTime? time;
  String? notes;
  UserModel? userModel;
  List<ServiceTypeModel>? serviceTypeModel;
  List<RelatedDocumentsModel>? relatedDocumentsModel;
  bool? isCanceled;
  String? status;

  AppointmentModel({
    this.id,
    this.date,
    this.time,
    this.notes,
    this.userModel,
    this.serviceTypeModel,
    this.relatedDocumentsModel,
    this.isCanceled,
    this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      date:json['date'] != null
          ? DateTime.parse(json['date'])
          : null,
          time:json['time'] != null
          ? DateTime.parse(json['time'])
          : null,
      notes: json['notes'],
      userModel: UserModel.fromJson(json['user_obj']),
      serviceTypeModel: 
          json['service_type_obj'],
      relatedDocumentsModel:
          json['related_documents_obj'],
      isCanceled: json['is_canceled'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date!.toIso8601String(),
      'time': time!.toIso8601String(),
      'notes': notes,
      'user_obj': userModel!.toJson(),
      'service_type_obj': serviceTypeModel,
      'related_documents_obj': relatedDocumentsModel,
      'is_canceled': isCanceled,
      'status': status,
    };
  }
}
