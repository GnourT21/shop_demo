
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/models/http_exeption.dart';
import 'package:shop_ui_udemy/pages/main_page.dart';
import 'package:shop_ui_udemy/provider/auth_provider.dart';
import 'package:shop_ui_udemy/widgets/my_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  static const nameRoute = '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  final _passController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error!'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Countinue'),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit(String email, String password) async {
    var isValid = _formKey.currentState!.validate();
    try {
      if (!_isSignUp) {
        if (isValid) {
          await Provider.of<AuthProvider>(context, listen: false)
              .signIn(email, password);
          Navigator.of(context).pushReplacementNamed(MyMainPage.nameRoute);
        }
      } else {
        if (isValid) {
          await Provider.of<AuthProvider>(context, listen: false)
              .signUp(email, password);
        }
      }
    } on HttpExeption catch (e) {
      var errorMessage = 'Authencicate Failed!';
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is already used!';
      } else if (e.toString().contains('EMAIL_INVALID')) {
        errorMessage = 'Invalid email!';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email does not exist';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      } else if (e.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage =
            'This account has been temporarily disabled due to many failed login attempts';
      }
      _showError(errorMessage);
    } catch (e) {
      var errorMessage = 'Log in failed, check your connection and try again!';
      _showError(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * .16,
                  ),
                  buildAppLogo(context),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: size.height * .06,
                    width: size.width * 0.8,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        label: Text(
                          'Enter email',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      controller: _emailController,
                      obscureText: false,
                      validator: (email) {
                        if (!email!.contains('@')) {
                          return 'Email is not valid!';
                        } else if (email.isEmpty) {
                          return 'Email can not empty!';
                        } else if (!email.contains('.com')) {
                          return 'Email is not valid!';
                        } else {
                          return null;
                        }
                      },
                      // onSaved: (_) => onSubmit,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: size.height * .06,
                    width: size.width * 0.8,
                    child: TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        label: Text(
                          'Enter password',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty) {
                          return 'Password cannot empty';
                        } else if (pass.length < 6) {
                          return 'Password length must larger than 8 character!';
                        } else {
                          return null;
                        }
                      },
                      // onSaved: (_) => onSubmit,
                    ),
                  ),
                  _isSignUp
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            height: size.height * .06,
                            width: size.width * 0.8,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                label: Text(
                                  'Confirm password',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              obscureText: true,
                              validator: (text) {
                                if (text != _passController.text) {
                                  return 'Confirm password not matched!';
                                } else {
                                  return null;
                                }
                              },
                              // onSaved: (_) => onSubmit,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  MyButton(
                    width: size.width * .8,
                    height: size.height * .06,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        _isSignUp ? 'Sign Up' : 'Sign In',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressHandle: () =>
                        onSubmit(_emailController.text, _passController.text),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(!_isSignUp
                          ? 'Don\'t have an account?'
                          : 'Already have account?'),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                          });
                        },
                        child: Text(
                          !_isSignUp ? 'Sign Up' : 'Sign In',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText buildAppLogo(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 32),
        children: [
          TextSpan(
            text: "Mini",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.black26,
                  fontSize: 32,
                ),
          ),
          TextSpan(
            text: "Grocery",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
