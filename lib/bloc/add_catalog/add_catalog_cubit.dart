import 'package:ecatalog/data/datasources/product_datasource.dart';
import 'package:ecatalog/data/models/request/product_request_model.dart';
import 'package:ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'add_catalog_state.dart';
part 'add_catalog_cubit.freezed.dart';

class AddCatalogCubit extends Cubit<AddCatalogState> {
  final ProductDataSource dataSource;
  AddCatalogCubit(this.dataSource) : super(const AddCatalogState.initial());

  void addCatalog(ProductRequestModel model, XFile image) async {
    emit(const _Loading());
    final uploadResult = await dataSource.uploadFile(image);
    uploadResult.fold(
        (error) => emit(
              _Error(error),
            ), (dataUpload) async {
      final result = await dataSource.createProduct(
        model.copyWith(
          images: [
            dataUpload.location,
          ],
        ),
      );
      result.fold(
        (error) => emit(_Error(error)),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
