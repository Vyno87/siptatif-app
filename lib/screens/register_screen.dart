import 'package:flutter/material.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/datas/models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: GlassCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "assets/img/siptatif-banner-intro-page.jpg",
                            width: 300,
                          ),
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
                  controller: _namaController,
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
                  controller: _nimController,
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
                  controller: _emailController,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newUser = User(
                      fullName: _namaController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      roles: 'mahasiswa', // default role
                      nimNidn: _nimController.text,
                      profilePict: 'assets/img/default-profile.png',
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                    );
                    final currentContext = context;
                    final success = await currentContext.read<AuthProvider>().register(newUser);
                    if (!currentContext.mounted) return;
                    if (success) {
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        const SnackBar(content: Text('Pendaftaran berhasil! Silakan login.')),
                      );
                      Navigator.pushReplacementNamed(currentContext, "/login");
                    } else {
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        SnackBar(content: Text(currentContext.read<AuthProvider>().errorMessage)),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(329, 50)),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),
);
}
}
