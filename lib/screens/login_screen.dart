import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
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
                  controller: _emailController,
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
              Consumer<AuthProvider>(
                builder: (consumerContext, authProvider, child) {
                  return Column(
                    children: [
                      if (authProvider.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            authProvider.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      TextButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await authProvider.login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  if (!mounted) return;
                                  if (success) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacementNamed(context, "/main");
                                  }
                                }
                              },
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(329, 50)),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontFamily: "Montserrat-Bold",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                      ),
                    ],
                  );
                },
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
      ),
    ),
  ),
  ),
);
  }
}
