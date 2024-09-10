import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';
import 'package:forst_ui/core/utils/snack_bar_message.dart';
import 'package:forst_ui/features/auth/pages/sign_up_screen.dart';
import 'package:forst_ui/features/auth/widgets/auth_btn.dart';
import 'package:forst_ui/features/report/pages/report_screen.dart';

import '../../../core/strings/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/auth/authenticate"),
        body: jsonEncode({"email": email, "password": password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReportScreen()));

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      } else {
        SnackBarMessage().showErrorSnackBar(
          message: "Invalid credentials",
          context: context,
        );
      }
    } catch (e) {
      print("Login error: $e");
      SnackBarMessage().showErrorSnackBar(
        message: "An error occurred. Please try again.",
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child:
              Text(
              "Login",
              style: TextStyle( fontSize: 35),
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 235,),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is mandatory';
                  } else if (!isEmail(value)) {
                    return "Invalid email address";
                  }
                  return null;
                },
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.deepPurpleAccent, width: 3.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Password is mandatory and must be at least 8 characters long';
                  }
                  return null;
                },
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.deepPurpleAccent, width: 3.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthButton(
                onPressed: () => login(
                  emailController.text,
                  passwordController.text,
                ),
                color: Colors.deepPurpleAccent,
                text: "Login",
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
