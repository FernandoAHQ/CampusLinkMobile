import 'dart:core';
import 'package:campuslink/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final logo = SvgPicture.asset(
    'assets/images/logo.svg',
    semanticsLabel: 'CampusLink Logo',
    height: 124.0,
  );

  final _loginFormKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool buttonEnabled = true;

  @override
  void dispose() {
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo,
            Text(
              'CampusLink',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'Sign In to Continue',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 64.0,
            ),
            Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'email',
                            hintText: 'Type your email address',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors
                                    .blue, // Border color when not focused
                                width: 1.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        controller: _usernameTextController,
                        style: Theme.of(context).textTheme.titleLarge,
                        validator: (value) => validateEmpty(value),
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'password',
                            hintText: 'Type your password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors
                                    .blue, // Border color when not focused
                                width: 1.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        controller: _passwordTextController,
                        style: Theme.of(context).textTheme.titleLarge,
                        validator: (value) => validateEmpty(value),
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 28.0),
                          ),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5);
                              }
                              return Theme.of(context).colorScheme.primary;
                            },
                          ),
                        ),
                        onPressed: buttonEnabled
                            ? () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  final res = await NetworkService().login(
                                      _usernameTextController.text,
                                      _passwordTextController.text);

                                  String message = res['message'];

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                }
                              }
                            : null,
                        child: Text(
                          'Sign In',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  validateEmpty(value) {
    if (value == null || value.isEmpty) return 'Please enter your credentials';
    return null;
  }
}
