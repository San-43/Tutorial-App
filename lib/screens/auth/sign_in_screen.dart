import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/firestore/user_firestore_service.dart';
import 'package:tutorial_app/screens/tutorial/tutorial_home.dart';
import '../../quiz/quiz.dart';
import 'components/my_text_field.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                errorMsg: _emailError,
                validator: (val) {
                  if (_emailError != null) {
                    final msg = _emailError;
                    _emailError = null;
                    return msg;
                  }
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!RegExp(
                    r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$',
                  ).hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    errorMsg: _passwordError,
                    validator: (val) {
                      if (_passwordError != null) {
                        final msg = _passwordError;
                        _passwordError = null;
                        return msg;
                      }
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          if (obscurePassword) {
                            iconPassword = CupertinoIcons.eye_slash_fill;
                          } else {
                            iconPassword = CupertinoIcons.eye_fill;
                          }
                        });
                      },
                      icon: Icon(iconPassword),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            !signInRequired
                ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        signInRequired = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                          );
                          if (!mounted) return;
                          setState(() {
                            signInRequired = false;
                          });
                          bool quizDone = await UserFirestoreService().getQuiz();

                          if (!quizDone) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const Tutorial()),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const Quiz(progress: 0,)),
                            );
                          }

                        } on FirebaseAuthException {
                          setState(() {
                            signInRequired = false;
                            _passwordError = 'Invalid Credentials';
                            _emailError = 'Invalid Credentials';
                          });
                          _formKey.currentState!.validate();
                        }
                      } else {
                        setState(() {
                          signInRequired = false;
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      child: Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                : const CircularProgressIndicator(),
          ],
        ),
      );
  }
}
