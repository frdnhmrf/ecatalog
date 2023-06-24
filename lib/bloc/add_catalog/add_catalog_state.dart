part of 'add_catalog_cubit.dart';

@freezed
class AddCatalogState with _$AddCatalogState {
  const factory AddCatalogState.initial() = _Initial;
  const factory AddCatalogState.loaded(ProductResponseModel model) = _Loaded;
  const factory AddCatalogState.loading() = _Loading;
  const factory AddCatalogState.error(String message) = _Error;
}
