import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'HomePage.dart';
import 'AuthController.dart';
import 'Userdata.dart';
import 'validation.dart';


class LoginPage extends StatelessWidget {
  final controller = Get.put(sigin());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.email,
                  validator: (value) => validation.validationEmail(value),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _getErrorColor(controller.email.text),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    errorText: _getErrorText(controller.email.text),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.password,
                  validator: (value) => validation.validatePassword(value),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _getErrorColor(controller.password.text),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    errorText: _getErrorText(controller.password.text),
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.Login();
                    }
                  },
                  child: Obx(() {
                    return controller.islogin.value
                        ? CircularProgressIndicator()
                        : Text('Login');
                  }),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Navigate to registration page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getErrorColor(String value) {
    return value.isNotEmpty ? Colors.red : Colors.grey;
  }

  String? _getErrorText(String value) {
    return value.isEmpty ? null : validation.validationEmail(value);
  }
}

class RegisterPage extends StatelessWidget {
  final Controller = Get.put(signup());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: Controller.email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _getErrorColor(Controller.email.text),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    errorText: _getErrorText(Controller.email.text),
                  ),
                  validator: (value) => validation.validationEmail(value),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: Controller.username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _getErrorColor(Controller.username.text),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    errorText: _getErrorText(Controller.username.text),
                  ),
                  validator: (value) => validation.validationUsername(value),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: Controller.password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _getErrorColor(Controller.password.text),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    errorText: _getErrorText(Controller.password.text),
                  ),
                  validator: (value) => validation.validatePassword(value),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: Controller.retypePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Retype Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _getErrorColor(Controller.retypePassword.text),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    errorText: _getErrorText(Controller.retypePassword.text),
                  ),
                  validator: (value) {
                    if (value != Controller.password.text) {
                      return 'password harus sama';
                    }
                    if (value == null || value.isEmpty) {
                      return 'tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Usermodel user = Usermodel(
                        username: Controller.username.text.trim(),
                        Email: Controller.email.text.trim(),
                        password: Controller.password.text,
                      );
                      signup.instance.register(
                        user,
                      );
                    }
                  },
                  child: Obx(() {
                    return Controller.isregister.value
                        ? CircularProgressIndicator()
                        : Text('Register');
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getErrorColor(String value) {
    return value.isNotEmpty ? Colors.red : Colors.grey;
  }

  String? _getErrorText(String value) {
    return value.isEmpty ? null : validation.validationEmail(value);
  }
}