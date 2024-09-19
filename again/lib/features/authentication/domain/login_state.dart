abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

// State when the email is verified successfully
class EmailVerifiedSuccess extends LoginState {}

// State when login is successful
class LoginSuccess extends LoginState {
  final String userId;
  LoginSuccess(this.userId);
}

// State when login fails
class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
