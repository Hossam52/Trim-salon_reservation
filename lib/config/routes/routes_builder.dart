import 'package:flutter/material.dart';
import 'package:trim/modules/auth/screens/forgot_password_screen.dart';
import 'package:trim/modules/auth/screens/verification_code_screen.dart';
import 'package:trim/modules/home/screens/trimStars_Screen.dart';
import '../../modules/auth/screens/registration_screen.dart';
import '../../modules/auth/screens/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (_) => LoginScreen(),
  RegistrationScreen.routeName: (_) => RegistrationScreen(),
  VerificationCodeScreen.routeName: (_) => VerificationCodeScreen(),
  ForgotPassword.routeName: (_) => ForgotPassword(),
  TrimStarsScreen.routeName: (_) => TrimStarsScreen(),
};
