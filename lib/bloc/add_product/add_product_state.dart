// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_bloc.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductLoaded extends AddProductState {
  final ProductResponseModel data;
  AddProductLoaded({
    required this.data,
  });
}

class AddProductError extends AddProductState {
  final String message;
  AddProductError({
    required this.message,
  });
}
