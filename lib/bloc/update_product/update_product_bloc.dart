import 'package:ecatalog/data/datasources/product_datasource.dart';
import 'package:ecatalog/data/models/request/product_request_model.dart';
import 'package:ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';
part 'update_product_bloc.freezed.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductDataSource dataSource;
  UpdateProductBloc(this.dataSource) : super(const _Initial()) {
    on<_DoUpdate>((event, emit) async {
      emit(const _Loading());
      final result = await dataSource.createProduct(event.requestData);
      result.fold(
        (error) => emit(_Error(error)),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
