import 'package:ecatalog/data/datasources/product_datasource.dart';
import 'package:ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource dataSource;

  ProductsBloc(this.dataSource) : super(ProductsInitial()) {
    on<ProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final result = await dataSource.getAllProducts();
      result.fold((error) => emit(ProductsError(message: error)),
          (data) => emit(ProductsLoaded(data: data)));
    });
  }
}
