import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/datas/models/user.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  final _extraController = TextEditingController();
  
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  String _selectedRole = 'Mahasiswa';

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _extraController.dispose();
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                      const SizedBox(height: 20),
                      Text(
                        "Daftar Akun",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ).animate().fade(delay: 300.ms).slideY(begin: 0.5, end: 0),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.black26 : Colors.white60,
                            hintText: 'Nama Lengkap',
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
                            return null;
                          },
                        ),
                      ).animate().fade(delay: 400.ms).slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 15),
                      // Dropdown Role
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedRole,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.black26 : Colors.white60,
                            prefixIcon: const Icon(Icons.work),
                          ),
                          dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                          items: <String>['Mahasiswa', 'Dosen'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                              _nimController.clear();
                              _extraController.clear();
                            });
                          },
                        ),
                      ).animate().fade(delay: 425.ms).slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _nimController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.black26 : Colors.white60,
                            hintText: _selectedRole == 'Mahasiswa' ? 'Masukkan NIM' : 'Masukkan NIDN',
                            prefixIcon: const Icon(Icons.badge),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${_selectedRole == 'Mahasiswa' ? 'NIM' : 'NIDN'} tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ).animate().fade(delay: 450.ms).slideX(begin: 0.2, end: 0),
                      const SizedBox(height: 15),
                      // Extra Field
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _extraController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.black26 : Colors.white60,
                            hintText: _selectedRole == 'Mahasiswa' ? 'Program Studi' : 'Bidang Keahlian',
                            prefixIcon: Icon(_selectedRole == 'Mahasiswa' ? Icons.book : Icons.lightbulb),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${_selectedRole == 'Mahasiswa' ? 'Program Studi' : 'Bidang Keahlian'} tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ).animate().fade(delay: 475.ms).slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 15),
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
                            hintText: 'Email Address',
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Email Address tidak boleh kosong';
                            if (!value.contains('@')) return 'Format email tidak valid';
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
                            if (value.length < 6) return 'Password minimal 6 karakter';
                            return null;
                          },
                        ),
                      ).animate().fade(delay: 550.ms).slideX(begin: 0.2, end: 0),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          obscureText: confirmPasswordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.black26 : Colors.white60,
                            hintText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(confirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Confirm Password tidak boleh kosong';
                            if (value != _passwordController.text) return 'Password tidak cocok';
                            return null;
                          },
                        ),
                      ).animate().fade(delay: 600.ms).slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final newUser = User(
                              fullName: _namaController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              roles: _selectedRole,
                              nimNidn: _nimController.text,
                              extraInfo: _extraController.text,
                              profilePict: 'assets/img/default-profile.png',
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              status: 'pending',
                            );
                            final currentContext = context;
                            final success = await currentContext.read<AuthProvider>().register(newUser);
                            if (!currentContext.mounted) return;
                            if (success) {
                              ScaffoldMessenger.of(currentContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Pendaftaran berhasil! Silakan tunggu persetujuan dari Admin sebelum Anda dapat login.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacementNamed(currentContext, "/login");
                            } else {
                              ScaffoldMessenger.of(currentContext).showSnackBar(
                                SnackBar(content: Text(currentContext.read<AuthProvider>().errorMessage)),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          minimumSize: const Size(double.infinity, 55),
                          elevation: 5,
                        ),
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                      ).animate().fade(delay: 700.ms).scale(delay: 700.ms),
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
