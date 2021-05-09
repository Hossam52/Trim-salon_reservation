abstract class AuthStates {}

class IntialAuthLoginState extends AuthStates {}

class IntialAuthRegisterState extends AuthStates {}

class ErrorAuthState extends AuthStates {
  final String errorMessage;

  ErrorAuthState(this.errorMessage);
}

class LoadingAuthState extends AuthStates {}

class LoadedAuthState extends AuthStates {}

class InvalidFieldState extends AuthStates {
  final String errorMessage;

  InvalidFieldState(this.errorMessage);
}

class NotActivatedAccountState extends AuthStates {}

class ChangeGenderState extends AuthStates {}