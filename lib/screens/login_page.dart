import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/models/login/login_request_model.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/shared_service.dart';
import '../models/user/user_response_model.dart';
import 'PasswordChangePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  //final bool _rememberMe = false;
  late String _enteredSapId; // Declare variable to store entered SAP ID
  late String _enteredPassword; // Declare variable to store entered SAP ID
  bool isAPICallProcess = false;
  late TextEditingController sapController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    sapController = TextEditingController();
    passwordController = TextEditingController();
  }

  void _login() {
    if (_enteredSapId.isNotEmpty && _enteredPassword.isNotEmpty) {
      LoginRequestModel login =
          LoginRequestModel(sapController.text, passwordController.text);
      UserResponseModel user;
      APIService.login(context, login).then((value) => {
            if (value == 0)
              {context.goNamed('admin')}
            else if (value == 1)
              APIService.doGet(
                      path: "/user/single-user", param: SharedService.sapId)
                  .then((value) => {
                        user = UserResponseModel.fromJson(jsonDecode(value)),
                        SharedService.setUserDetails(user),
                      }),
            {context.goNamed("home")}
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            //colors: [Color(0xFFe4efe9), Color(0xFF93a5cf)],
            colors: [Color(0xFFcd9cf2), Color(0xFFf6f3ff)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 150,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Welcome",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                _gap(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: sapController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter SAP ID';
                      }
                      if (value.length != 8 && value.length != 11) {
                        return 'Please enter your 8 or 11-digit SAP ID';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _enteredSapId = value; // Update entered SAP ID
                    },
                    decoration: const InputDecoration(
                      labelText: 'SAP ID',
                      hintText: 'Enter your SAP ID',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                _gap(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _enteredPassword = value; // Update entered SAP ID
                    },
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                _gap(),
                /* Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _rememberMe = value;
                        });
                      },
                    ),

                    const Text('Remember me'),
                  ],
                ),
                */
                _gap(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordChangePage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(),
                  ),
                ),
                _gap(),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _login();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
