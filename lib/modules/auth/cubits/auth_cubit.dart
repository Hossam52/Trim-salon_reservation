import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trim/modules/auth/cubits/auth_states.dart';
import 'package:trim/modules/auth/models/register_model.dart';
import 'package:trim/modules/auth/repositries/login_repositries.dart';
import 'package:trim/modules/auth/repositries/register_repositry.dart';
import 'package:trim/modules/auth/screens/login_screen.dart';
import 'package:trim/modules/auth/screens/registration_screen.dart';

enum Gender {
  Male,
  Female,
}

class _LoginErrors {
  static const String notActivated = "User Account Not Activated";
  static const String unauthorised = "UnAuthorised";
}

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(IntialAuthLoginState());
  static AuthCubit getInstance(context) => BlocProvider.of(context);
  RegisterModel registerModel;
  Gender selectedGender = Gender.Male;
//----------------------API Calls Start-------------------
  void login(String userName, String password) async {
    emit(LoadingAuthState());
    String fieldsValidateError = _validateLogin(userName, password);
    if (fieldsValidateError == null) {
      //Call API
      final response = await loginUser(userName, password);
      if (response.error) 
      {
        if (response.errorMessage == _LoginErrors.notActivated)
          emit(NotActivatedAccountState());
        else
          emit(ErrorAuthState('Email or password not correct'));
      } else {
        //Use shared prefrences
        print(response.data.token);
        emit(LoadedAuthState());
      }
    } else {
      emit(InvalidFieldState(fieldsValidateError));
    }
  }

  void register({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) async {
    String _validateRegisterStatus = _validateRegister(
        name: name, email: email, password: password, phone: phone);
    if (_validateRegisterStatus != null) {
      emit(InvalidFieldState(_validateRegisterStatus));
    } else {
      emit(LoadingAuthState());
      final response = await registerUser(body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone': phone,
        'gender': selectedGender == Gender.Male ? 'male' : 'female',
      });
      if (response.error) {
        emit(ErrorAuthState(response.errorMessage));
      } else {
        registerModel = response.data;
        print(response.data.accessToken);
        emit(NotActivatedAccountState());
      }
    }
  }

//---------------------API Calls End ----------------------
  void navigateToLogin(BuildContext context) {
    emit(IntialAuthLoginState());
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  void navigateToRegister(BuildContext context) {
    emit(IntialAuthRegisterState());
    Navigator.pushReplacementNamed(context, RegistrationScreen.routeName);
  }

  void changeGender(Gender gender) {
    selectedGender = gender;
    emit(ChangeGenderState());
  }

  String _validateRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    String validateEamilStatus = _validateEmail(email);
    String validatePhoneStatus = validatePhone(phone);
    String validatePasswordStatus = validatePassword(password);
    String validateNameStatus = validateName(name);
    if (validateNameStatus != null) return validateNameStatus;
    if (validateEamilStatus != null && validateEamilStatus.isNotEmpty)
      return validateEamilStatus;
    if (validateEamilStatus != null && validateEamilStatus.isEmpty) {
      print('hello');
      return 'Email entered is not correct';
    }
    if (validatePhoneStatus != null) return validatePhoneStatus;
    if (validatePasswordStatus != null) return validatePasswordStatus;
    return null;
  }

  String _validateLogin(String userName, String password) {
    String validateUserNameStatus = validateLogin(userName);
    if (validateUserNameStatus != null)
      return validateUserNameStatus;
    else {
      String validatePasswordStatus = validatePassword(password);
      if (validatePasswordStatus != null)
        return validatePasswordStatus;
      else
        return null;
    }
  }

  String _validateEmail(String email) {
    if (email == null || email.isEmpty) return 'Email field can\'t be empty';
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(email)) {
      // So, the email is valid
      return null;
    } else
      return '';
  }

  String validateLogin(String login) {
    String emailValidation = _validateEmail(login);
    if (emailValidation == null || emailValidation != '')
      return emailValidation;
    if (validatePhone(login) != null)
      return 'Email or phone is not on correct format';
    return null;
  }

  String validatePhone(String phone) {
    if (phone == null || phone.isEmpty) return 'Phone shouldn\'t be  empty';
    if (phone.length != 11) return 'Please enter valid phone';

    return null;
  }

  String validatePassword(String password) {
    if (password == null || password.isEmpty)
      return 'Password field can\'t be empty';
    return null;
  }

  String validateName(String name) {
    if (name == null || name.isEmpty) return 'Name field can\'t be empty';
    return null;
  }
}
