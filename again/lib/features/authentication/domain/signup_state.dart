abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String uid;

  SignupSuccess(this.uid);
}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure(this.error);
}

class SignupImagePickedSuccess extends SignupState {}

class SignupImagePickedFailure extends SignupState {
  final String error;

  SignupImagePickedFailure(this.error);
}
