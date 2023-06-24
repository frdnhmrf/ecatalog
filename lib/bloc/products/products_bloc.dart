import 'package:ecatalog/data/datasources/product_datasource.dart';
import 'package:ecatalog/data/models/response/product_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource dataSource;

  ProductsBloc(this.dataSource) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final result =
          await dataSource.getPaginationProducts(offset: 0, limit: 10);
      result.fold((error) => emit(ProductsError(message: error)), (data) {
        bool isNext = data.length == 10;
        emit(ProductsLoaded(
          data: data,
          isNext: isNext,
        ));
      });
    });

    on<NextProductsEvent>((event, emit) async {
      final currentState = state as ProductsLoaded;
      final result = await dataSource.getPaginationProducts(
        offset: currentState.offset + 10,
        limit: 10,
      );
      result.fold((error) => emit(ProductsError(message: error)), (data) {
        bool isNext = data.length == 10;
        // emit(
        //   ProductsLoaded(
        //       data: [...currentState.data, ...data],
        //       offset: currentState.offset + 10,
        //       isNext: isNext),
        // );
        emit(
          currentState.copyWith(
              data: [...currentState.data, ...data],
              offset: currentState.offset + 10,
              isNext: isNext),
        );
      });
    });

    on<AddSingleProductEvent>((event, emit) async {
      final currentState = state as ProductsLoaded;
      emit(
        currentState.copyWith(
          data: [...currentState.data, event.model],
        ),
      );
    });

      on<ClearProductsEvent>((event, emit) async {
      emit(ProductsInitial());
    });
  }
}
