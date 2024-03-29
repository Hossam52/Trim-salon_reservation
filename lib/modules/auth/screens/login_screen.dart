import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trim/appLocale/translatedWord.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/modules/auth/screens/forgot_password_screen.dart';
import 'package:trim/modules/auth/screens/not_acitvate_account_screen.dart';
import 'package:trim/general_widgets/default_button.dart';
import 'package:trim/modules/auth/widgets/social.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';
import 'package:trim/utils/ui/app_dialog.dart';
import '../widgets/frame_card_auth.dart';
import '../../../general_widgets/trim_text_field.dart';
import '../widgets/not_correct_input.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';

class LoginScreen extends StatefulWidget {
  static final String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = new TextEditingController();

  final TextEditingController _passwordController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    AuthCubit.getInstance(context).emit(IntialAuthLoginState());
  }

  @override
  Widget build(BuildContext context) {
    final Widget formFields = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TrimTextField(
            controller: _userNameController,
            placeHolder: translatedWord('Email or phone', context),
            validator: null,
          ),
          TrimTextField(
              controller: _passwordController,
              placeHolder: translatedWord('Password', context),
              password: true,
              validator: null),
        ],
      ),
    );

    final Widget forgotPassword = RawMaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: const EdgeInsets.only(top: 10),
      constraints: BoxConstraints(),
      onPressed: () {
        Navigator.pushNamed(context, ForgotPassword.routeName);
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: ResponsiveWidget(
        responsiveWidget: (_, deviceInfo) => Text(
            translatedWord('Forgot password', context),
            style: TextStyle(
                color: Colors.grey, fontSize: defaultFontSize(deviceInfo))),
      ),
    );

    final Widget createAccount = RawMaterialButton(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      constraints: BoxConstraints(),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () =>
          AuthCubit.getInstance(context).navigateToRegister(context),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: ResponsiveWidget(
        responsiveWidget: (_, deviceInfo) => Text(
            translatedWord('Create account', context),
            style: TextStyle(
                color: Colors.grey,
                fontSize: defaultFontSize(deviceInfo) * 0.88)),
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        return await exitConfirmationDialog(
            context, translatedWord('Are you sure to exit?', context));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            child: BlocConsumer<AuthCubit, AuthStates>(
              listener: (_, state) async {
                FocusScope.of(context).unfocus();
                if (state is InvalidFieldState)
                  Fluttertoast.showToast(
                      msg: state.errorMessage, backgroundColor: Colors.red);
                if (state is NotActivatedAccountState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          translatedWord('Account not activated', context))));
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ActivateAccountScreen(
                                emailOrPhone: _userNameController.text,
                              )));
                }
                if (state is ErrorAuthState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)));
                }
              },
              builder: (_, state) {
                return CardLayout(
                  children: [
                    if (state is InvalidFieldState)
                      ErrorWarning(text: state.errorMessage),
                    if (state is ErrorAuthState)
                      ErrorWarning(
                        text: state.errorMessage,
                      ),
                    formFields,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultButton(
                        widget: state is LoadingAuthState
                            ? Center(child: CircularProgressIndicator())
                            : null,
                        text: translatedWord("Login", context),
                        onPressed: state is LoadingAuthState
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                AuthCubit.getInstance(context).login(
                                    context,
                                    _userNameController.text,
                                    _passwordController.text);
                              },
                      ),
                    ),
                    forgotPassword,
                    createAccount,
                    Divider(),
                    Text(translatedWord('Or Register using', context)),
                    SocialAuth(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
