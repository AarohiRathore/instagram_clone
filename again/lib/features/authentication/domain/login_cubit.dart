import 'package:bloc/bloc.dart';
import 'package:clone/features/authentication/domain/login_state.dart';
import 'package:clone/features/authentication/data/auth_repository.dart'; // Ensure this path is correct

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository; // Adjust according to your repository

  LoginCubit(this._authRepository) : super(LoginInitial());

  void login(String email, String password) async {
    emit(LoginLoading());
    try {
      final userId = await _authRepository.login(
          email, password); // Implement login method in repository
      emit(LoginSuccess(userId));
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }
}
