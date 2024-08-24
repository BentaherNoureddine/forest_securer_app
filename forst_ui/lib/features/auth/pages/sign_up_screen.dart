import 'dart:convert';
import 'package:validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:forst_ui/core/strings/constants.dart';
import 'package:forst_ui/features/auth/pages/login_screen.dart';
import 'package:http/http.dart';
import '../../../core/utils/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  void SignUp(
      String email, String password, String firstname, String lastname) async {
    try {
      print("$email  $password");
      if( email.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty){
        SnackBarMessage().showErrorSnackBar(
            message: "Fields should not be empty", context: context);
      }

      Response response = await post(Uri.parse('$apiUrl/auth/register'),
          body: jsonEncode({
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password
          }),
          headers: {
            'Content-Type': 'application/json ; charset=UTF-8',
          });
      if (response.statusCode == 201) {
        for(int i=0;i<10;i++){
          print(response.statusCode);
        }
        print("account created successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        print("failed to register ");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign up"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              //firstname
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Firstname is mandatory';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "First Name",
                  labelText: "First Name",
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
                controller: firstnameController,
              ),
              const SizedBox(height: 20),
              //lastname
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is mandatory';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Last Name",
                  labelText: "Last Name",
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
                controller: lastnameController,
              ),
              const SizedBox(height: 20),
              //email
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is mandatory'; //dans le dossier Strings
                  }else if(!isEmail(value) ){
                      return "email Incorrect";
                  }
                  return null;
                },
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
                controller: emailController,
              ),
              const SizedBox(height: 20),
              //password
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length<8) {
                    return 'password is mandatory and more than 8 characters ';
                  }
                  return null;
                },
                obscureText: true,
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
                controller: passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  SignUp(
                      emailController.text.toString().toString(),
                      passwordController.text.toString(),
                      firstnameController.text.toString(),
                      lastnameController.text.toString());
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text("Sign Up",style: TextStyle(fontSize: 20),),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text(
                  "already have an account?  press here to Login",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
