import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/auth_status.dart';
import '../models/http_exception.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AuthStatus _authStatus = AuthStatus.login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _password = TextEditingController();
  bool _hasInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryAuth();
    super.initState();
  }

  final Map<String, String> _credentials = {
    "email": '',
    "password": '',
  };

  void showAlert(String errorMsg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("An error occured"),
        content: Text(errorMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Okay"),
          ),
        ],
      ),
    );
  }

  void handleFormSave() async {
    if (_formKey.currentState?.validate() == false) {
      // return;
    }
    _formKey.currentState?.save();
    try {
      await Provider.of<Auth>(context, listen: false).signUp(
        _credentials["email"] as String,
        _credentials["password"] as String,
        _authStatus,
      );
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      String exception = error.toString();
      String errorMsg = "Something went wrong.";
      if (exception.contains("EMAIL_EXISTS")) {
        errorMsg = "Email already exists.";
      } else if (exception.contains("OPERATION_NOT_ALLOWED")) {
        errorMsg = "Access Denied.";
      } else if (exception.contains("TOO_MANY ATTEMPTS")) {
        errorMsg = "Too many attempts, try again later.";
      } else if (exception.contains("EMAIL_NOT_FOUND")) {
        errorMsg = "Email not found.";
      } else if (exception.contains("INVALID_PASSWORD")) {
        errorMsg = "Invalid password.";
      }
      showAlert(errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _authStatus == AuthStatus.login ? "Login" : "Register",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(_authStatus == AuthStatus.login
                        ? "Don't have an account?"
                        : "Have an account?"),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_authStatus == AuthStatus.login) {
                            _authStatus = AuthStatus.signUp;
                          } else {
                            _authStatus = AuthStatus.login;
                          }
                          _formKey.currentState?.reset();
                        });
                      },
                      child: Text(
                        _authStatus == AuthStatus.login ? "Register" : "Login",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (newValue) {
                          _credentials["email"] = newValue as String;
                        },
                        enableSuggestions: true,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        controller: _password,
                        obscureText: true,
                        onSaved: (newValue) {
                          _credentials["password"] = newValue as String;
                        },
                        enableSuggestions: true,
                      ),
                      if (_authStatus == AuthStatus.signUp)
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Confirm Password",
                          ),
                          obscureText: true,
                          enableSuggestions: true,
                          validator: (value) {
                            if (value != _password.text) {
                              return "Password Mismatch.";
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isLoading) return;
                    setState(() {
                      _isLoading = true;
                    });
                    handleFormSave();
                  },
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : _authStatus == AuthStatus.login
                          ? const Text("Log In")
                          : const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
