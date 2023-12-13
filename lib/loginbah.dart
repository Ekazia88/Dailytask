
import 'package:flutter/material.dart' show AlertDialog, BorderRadius, BorderSide, BoxDecoration, BuildContext, Color, Colors, Column, Container, EdgeInsets, Form, FormState, GlobalKey, Image, InputDecoration, Key, ListView, MainAxisAlignment, MaterialPageRoute, Navigator, OutlineInputBorder, Padding, Scaffold, ScaffoldMessenger, SizedBox, SnackBar, State, StatefulWidget, Text, TextButton, TextEditingController, TextFormField, TextStyle, Widget, showDialog;
import 'package:get/get.dart';
import 'HomePage.dart';
import 'AuthController.dart';
import 'Userdata.dart';
import 'validation.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ctrlEmail = TextEditingController();

  final TextEditingController _ctrlPassword = TextEditingController();

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _ctrlEmail.value.text;
    final password = _ctrlPassword.value.text;

    setState(() => _loading = true);
    // Assuming your Auth class returns a boolean indicating success
    bool loginSuccess = await Auth().login(email, password);
    setState(() => _loading = false);

    if (loginSuccess) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Meow Petshop',
              style: GoogleFonts.secularOne(),
            ),
            content: Text(
              'Selamat Datang Di Aplikasi Pendataan!',
              style: GoogleFonts.inter(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle login failure, show an error message, etc.
      // You can add a SnackBar or AlertDialog here.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login failed. Please check your credentials.',
            style: GoogleFonts.inter(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 234, 255),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/login.png',
                    width: 350,
                    height: 350,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.secularOne(
                          textStyle: TextStyle(
                        fontSize: 45,
                        color: Color.fromARGB(255, 170, 173, 246),
                      )),
                    ),
                  ),
                  TextFormField(
                    controller: _ctrlEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan Masukkan Email Anda';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                      filled: true,
                      hintStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 170, 173, 246))),
                      labelStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 170, 173, 246))),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 170, 173, 246)),
                      ),
                    ),
                    cursorColor: Color.fromARGB(255, 170, 173, 246),
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 170, 173, 246))),
                  ),
                  SizedBox(height: 20), // Add spacing
                  TextFormField(
                    controller: _ctrlPassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan Masukkan Password Anda';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                      filled: true,
                      hintStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 170, 173, 246))),
                      labelStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 170, 173, 246))),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 170, 173, 246)),
                      ),
                    ),
                    cursorColor: Color.fromARGB(255, 170, 173, 246),
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 170, 173, 246))),
                  ),
                  SizedBox(height: 25),
                  TextButton(
                    onPressed: () => handleSubmit(),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(170, 10, 170, 10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 90, 83, 170),
                          borderRadius: BorderRadius.circular(15)),
                      child: _loading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                            )
                          : Text(
                              "Sign In",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(color: Colors.white)),
                            ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Regis()));
                    },
                    style: TextButton.styleFrom(
                      primary: Color.fromARGB(255, 170, 173, 246),
                    ),
                    child: Text(
                      "Dont have an account?  Sign Up",
                      style: GoogleFonts.inter(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}