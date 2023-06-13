import 'package:ecatalog/data/datasources/auth_datasource.dart';
import 'package:ecatalog/data/models/request/register_request_model.dart';
import 'package:ecatalog/data/models/response/register_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthDatasource authDatasource;
  RegisterBloc(
    this.authDatasource,
  ) : super(RegisterInitial()) {
    on<DoRegisterEvent>(
      (event, emit) async {
        emit(RegisterLoading());
        // Do register
        final result = await authDatasource.register(event.model);
        result.fold(
          (error) {
            emit(RegisterError(message: error));
          },
          (data) {
            emit(RegisterLoaded(model: data));
          },
        );
      },
    );
  }
}
