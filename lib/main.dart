import 'package:flutter/material.dart';
import 'PasswordChangePage.dart';
import 'HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            //background gradient #93a5cf → #e4efe9
            colors: [Color(0xFFe4efe9), Color(0xFF93a5cf)],
           // colors: [Color(0xFFc4e0e5), Color(0xFF4ca1af)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // replace image with an icon
                  Icon(
                    Icons.person,
                    size: 150,
                    color: Colors.white, // Change to white
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
                      validator: (value) {
                        // email validation part
                        if (value == null || value.isEmpty) {
                          return 'Please enter SAP ID';
                        }

                        bool isValidNumber =
                        RegExp(r'^\d{11}$').hasMatch(value);
                        if (!isValidNumber) {
                          return 'Please enter your 11 digit SAP ID';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'SAP ID',
                        hintText: 'Enter your SAP ID',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _gap(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }

                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
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
                  // remember me box
                  Row(
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
                      Text('Remember me'),
                    ],
                  ),
                  _gap(),
                  GestureDetector(
                    onTap: () {
                      // Going to "Forgot Password" page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordChangePage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _gap(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Navigate to the Home Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.5), // 50% transparent
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Change to white
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
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
