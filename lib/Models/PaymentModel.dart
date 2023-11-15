
import 'package:therapy_user/Models/UserModel.dart';

class PaymentModel {
  UserModel? userModel;
  DateTime? dueDate;
  bool? isStorned;
  String? paymentStatus;
  int? amount;
  String? paymentMethod;
  String? transactionNumber;
  PaymentModel({
    this.userModel,
    this.dueDate,
    this.isStorned,
    this.paymentStatus,
    this.amount,
    this.paymentMethod,
    this.transactionNumber,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      userModel: json['user_obj'],
      dueDate: json['due_date'],
      isStorned: json['is_storned'],
      paymentStatus: json['payment_status'],
      amount: json['amount'],
      paymentMethod: json['payment_method'],
      transactionNumber: json['transaction_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_obj': userModel,
      'due_date': dueDate,
      'is_storned': isStorned,
      'payment_status': paymentStatus,
      'amount': amount,
      'payment_method': paymentMethod,
      'transaction_number': transactionNumber,
    };
  }
}
