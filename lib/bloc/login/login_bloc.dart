import "package:ecatalog/data/datasources/auth_datasource.dart";
import "package:ecatalog/data/models/request/login_request_model.dart";
import "package:ecatalog/data/models/response/login_response_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDatasource authDatasource;

  LoginBloc(this.authDatasource) : super(LoginInitial()) {
    on<DoLoginEvent>((event, emit) async {
      emit(LoginLoading());
      final result = await authDatasource.login(event.model);
      result.fold((error) => emit(LoginError(message: error)),
          (data) => emit(LoginLoaded(model: data)));
    });
  }
}
