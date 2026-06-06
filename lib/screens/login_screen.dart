import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 67),
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
                "Login Page",
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
                    hintText: 'Email/Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email/Username tidak boleh kosong';
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
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Container(
                alignment: Alignment.topRight,
                width: 318,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/lupa-password");
                  },
                  child: const Text("Lupa Password?",
                      style: TextStyle(
                          fontFamily: "Montserrat-SemiBold",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.7)),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const SizedBox(
                height: 24,
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, "/main");
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(329, 50)),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 47,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum ada akun? ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4)),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text("Daftar Disini",
                        style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
