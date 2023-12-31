import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ecatalog/data/models/request/product_request_model.dart';
import 'package:ecatalog/data/models/response/product_response_model.dart';
import 'package:ecatalog/data/models/response/upload_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductDataSource {
  Future<Either<String, List<ProductResponseModel>>> getAllProducts() async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products'),
    );

    if (response.statusCode == 200) {
      return Right(List<ProductResponseModel>.from(jsonDecode(response.body)
          .map((product) => ProductResponseModel.fromMap(product))));
    } else {
      return const Left('Gagal mendapatkan data');
    }
  }

  Future<Either<String, List<ProductResponseModel>>> getPaginationProducts({
    required int offset,
    required int limit,
  }) async {
    final response = await http.get(
      Uri.parse(
          'https://api.escuelajs.co/api/v1/products/?offset=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      return Right(List<ProductResponseModel>.from(jsonDecode(response.body)
          .map((product) => ProductResponseModel.fromMap(product))));
    } else {
      return const Left('Gagal mendapatkan data');
    }
  }

  Future<Either<String, ProductResponseModel>> createProduct(
      ProductRequestModel model) async {
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/products'),
      body: model.toJson(),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('Gagal membuat produk');
    }
  }

  Future<Either<String, UploadResponseModel>> uploadFile(XFile image) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('https://api.escuelajs.co/api/v1/files/upload'));

    final bytes = await image.readAsBytes();

    final multiPartFile =
        http.MultipartFile.fromBytes('file', bytes, filename: image.name);
    request.files.add(multiPartFile);

    http.StreamedResponse response = await request.send();

    final Uint8List responseList = await response.stream.toBytes();
    final String responseString = String.fromCharCodes(responseList);

    if (response.statusCode == 201) {
      return Right(UploadResponseModel.fromJson(jsonDecode(responseString)));
    } else {
      return const Left('Gagal upload image');
    }
  }
}
