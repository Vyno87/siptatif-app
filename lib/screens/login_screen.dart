import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGlassGradient : AppTheme.neonGradient,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/img/siptatif-banner-intro-page.jpg",
                            width: 250,
                          ),
                        ),
                      ).animate().fade(duration: 500.ms).scale(delay: 200.ms),
                      const SizedBox(height: 25),
                      Text(
                        "SIPTATIF",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ).animate().fade(delay: 300.ms).slideY(begin: 0.5, end: 0),
                      Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ).animate().fade(delay: 400.ms).slideY(begin: 0.5, end: 0),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.black26 : Colors.white60,
                            hintText: 'Email / Username',
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                            return null;
                          },
                        ),
                      ).animate().fade(delay: 500.ms).slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.black26 : Colors.white60,
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => passwordVisible = !passwordVisible),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                            return null;
                          },
                        ),
                      ).animate().fade(delay: 600.ms).slideX(begin: 0.2, end: 0),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, "/lupa-password"),
                          child: const Text(
                            "Lupa Password?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ).animate().fade(delay: 700.ms),
                      const SizedBox(height: 20),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return Column(
                            children: [
                              if (authProvider.errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    authProvider.errorMessage,
                                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ElevatedButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          final currentContext = this.context;
                                          final success = await authProvider.login(
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                          if (!mounted || !currentContext.mounted) return;
                                          if (success) Navigator.pushReplacementNamed(currentContext, "/main");
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  minimumSize: const Size(double.infinity, 55),
                                  elevation: 5,
                                ),
                                child: authProvider.isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        'LOGIN',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                      ),
                              ).animate().fade(delay: 800.ms).scale(delay: 800.ms),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum punya akun? ", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                          InkWell(
                            onTap: () => Navigator.pushNamed(context, "/register"),
                            child: const Text(
                              "Daftar Disini",
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryPurple),
                            ),
                          ),
                        ],
                      ).animate().fade(delay: 900.ms),
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
