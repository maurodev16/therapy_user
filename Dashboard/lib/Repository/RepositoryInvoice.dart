import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:therapy_dashboard/Controller/InvoiceController.dart';
import 'package:therapy_dashboard/Controller/UserController.dart';
import '../IRepository/IRepositoryInvoice.dart';
import '../Models/InvoiceModel.dart';
import '../Models/UserModel.dart';
import '../Utils/const_storage_keys.dart';

class RepositoryInvoice extends GetConnect implements IRepositoryInvoice {
  @override
  void onInit() async {
    httpClient.baseUrl = dotenv.env['API_URL'];
    final accessToken = StorageKeys.storagedToken;
    httpClient.timeout = Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = 'application/json';
      defaultContentType = "application/json; charset=utf-8";

      return request;
    });
    super.onInit();
  }

  @override
  Future<InvoiceModel> create(InvoiceModel invoiceModel, XFile file) async {
    final controller = Get.find<UserController>();

    MultipartFile multipartFile =
        MultipartFile(File(file.path), filename: file.name);

    FormData formData = FormData({
      'file': multipartFile,
      'user_obj': controller.getUserData.value.adminId,
      'appointment_obj': InvoiceController.to.appointmentModel.value.id,
      'over_duo': invoiceModel.overDuo,
      'status': invoiceModel.invoiceStatus,
    });
    final response =
        await httpClient.post('invoice/create-invoice', body: formData);

    if (response.status.isOk) {
      final Map<String, dynamic> responseData = await response.body;

      final newInvoice = InvoiceModel.fromJson(responseData);

      print("responseData::::: $responseData");

      print("Appointment::::: ${newInvoice.id}");

      return newInvoice;
    } else {
      return throw Exception(response.body);
    }
  }

  @override
  Future<List<InvoiceModel>> getAllInvoice() async {
    final response = await httpClient.get('invoice/fetch-invoices');
    try {
      if (response.status.isOk) {
        var jsonResponse = await response.body;
        List<dynamic> postList = jsonResponse;
        return postList
            .map<InvoiceModel>((item) => InvoiceModel.fromJson(item))
            .toList();
      }

      if (response.status.hasError) {
        return [];
      }
      if (response.status.isNotFound) {
        return [];
      }
      if (response.status.connectionError) {
        return [];
      }
      print("Body getAllInvoice Response:::::::::::::${response.bodyString}");

      throw Exception(response.bodyString);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<InvoiceModel>> getInvoiceByUserId(String id) async {
    final response = await httpClient.get('invoice/fetch-invoices/$id');
    if (response.status.isOk) {
      var jsonResponse = await response.body;
      List<dynamic> postList = jsonResponse;
      return postList
          .map<InvoiceModel>((item) => InvoiceModel.fromJson(item))
          .toList();
    }

    if (response.status.hasError) {
      return [];
    }
    if (response.status.isNotFound) {
      return [];
    }
    if (response.status.connectionError) {
      return [];
    }
    print("Body fetch by user id Response:::::::::::::${response.bodyString}");

    throw Exception(response.bodyString);
    // } catch (e) {
    //   throw Exception(e.toString());
    // }
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<void> deleteUser(String id) async {}

  @override
  // ignore: override_on_non_overriding_member
  Future<UserModel> editUser(UserModel userModel) async {
    return UserModel();
  }

  @override
  Future<void> deleteInvoice(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateInvoice(String id) {
    throw UnimplementedError();
  }
}
