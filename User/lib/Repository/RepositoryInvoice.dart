import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:therapy_user/Models/InvoiceModel.dart';
import '../IRepository/IRepositoryInvoice.dart';
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
  Future<List<InvoiceModel>> getInvoiceByUserId(String id) async {
    final response =
        await httpClient.get('invoice/fetch-invoices-by-user-id/$id');
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
}
