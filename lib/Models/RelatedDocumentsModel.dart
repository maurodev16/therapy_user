
import 'UserModel.dart';

class RelatedDocumentsModel {
  UserModel? userModel;
  String? documenName;
  DateTime? sendDate;
  String? documentType;
  String? filePath;
  RelatedDocumentsModel({
    this.userModel,
    this.documenName,
    this.sendDate,
    this.documentType,
    this.filePath,
  });

  factory RelatedDocumentsModel.fromJson(Map<String, dynamic> json) {
    return RelatedDocumentsModel(
      userModel: json['user_obj'],
      documenName: json['documen_name'],
      sendDate: json['send_date'],
      documentType: json['document_type'],
      filePath: json['file_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_obj': userModel,
      'documen_name': documenName,
      'send_date': sendDate,
      'document_type': documentType,
      'file_path': filePath,
    };
  }
}
