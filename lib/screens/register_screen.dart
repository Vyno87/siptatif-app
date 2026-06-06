import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                "assets/img/siptatif-banner-intro-page.jpg",
                width: 338,
              )),
              Container(
                height: 25,
              ),
              const Text(
                "Register Page",
                style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 36,
                    letterSpacing: -2,
                    decoration: TextDecoration.underline),
              ),
              Container(
                height: 25,
              ),
              SizedBox(
                width: 320,
                child: TextFormField(
                  style: const TextStyle(height: 1),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Nama',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 22,
              ),
              SizedBox(
                width: 320,
                child: TextFormField(
                  style: const TextStyle(height: 1),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'NIM',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIM tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 22,
              ),
              SizedBox(
                width: 320,
                child: TextFormField(
                  style: const TextStyle(height: 1),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Email Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Address tidak boleh kosong';
                    }
                    // Simple email format validation
                    if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 22,
              ),
              SizedBox(
                width: 320,
                child: TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(height: 1),
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 22,
              ),
              SizedBox(
                width: 320,
                child: TextFormField(
                  style: const TextStyle(height: 1),
                  obscureText: confirmPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(confirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(
                          () {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, "/login");
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(329, 50)),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
