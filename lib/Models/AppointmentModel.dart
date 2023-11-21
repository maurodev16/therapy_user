import 'ServiceTypeModel.dart';
import 'UserModel.dart';

class AppointmentModel {
  String? id;
  DateTime? date;
  DateTime? time;
  String? notes;
  UserModel? userModel;
  List<ServiceTypeModel>? serviceTypeModel;
  String? status;
  UserModel? canceledBy;
  AppointmentModel({
    this.id,
    this.date,
    this.time,
    this.notes,
    this.userModel,
    this.canceledBy,
    this.serviceTypeModel,
    this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      notes: json['notes'],
      userModel: UserModel.fromJson(json['user_obj']),
      canceledBy: UserModel.fromJson(json['canceled_by']),
      serviceTypeModel: json['service_type_obj'] != null
          ? (json['service_type_obj'] as List<dynamic>)
              .map((serviceTypeJson) =>
                  ServiceTypeModel.fromJson(serviceTypeJson))
              .toList()
          : null,
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
      'canceled_by':userModel!.toJson(),
      'service_type_obj':
          serviceTypeModel?.map((serviceType) => serviceType.toJson()).toList(),
      'status': status,
    };
  }
}
