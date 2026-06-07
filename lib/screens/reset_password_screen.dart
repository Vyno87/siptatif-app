import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool passwordVisible = false;
  bool reconfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 104),
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
              "Reset Password",
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
              child: TextField(
                controller: _passwordController,
                style: const TextStyle(height: 1),
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 22,
            ),
            SizedBox(
              width: 320,
              child: TextField(
                controller: _confirmPasswordController,
                style: const TextStyle(height: 1),
                obscureText: !reconfirmPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Reconfirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(reconfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          reconfirmPasswordVisible = !reconfirmPasswordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextButton(
              onPressed: () async {
                if (email == null) return;
                
                final pass = _passwordController.text;
                final confirmPass = _confirmPasswordController.text;
                
                if (pass.isEmpty || confirmPass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password tidak boleh kosong')),
                  );
                  return;
                }
                
                if (pass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password tidak cocok')),
                  );
                  return;
                }

                final currentContext = context;
                final success = await currentContext.read<AuthProvider>().resetPassword(email, pass);
                if (!currentContext.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(currentContext).showSnackBar(
                    const SnackBar(content: Text('Password berhasil diubah! Silakan login kembali.')),
                  );
                  Navigator.pushReplacementNamed(currentContext, "/login");
                } else {
                  ScaffoldMessenger.of(currentContext).showSnackBar(
                    SnackBar(content: Text(currentContext.read<AuthProvider>().errorMessage)),
                  );
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  fixedSize: const Size(329, 50)),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: "Montserrat-Bold",
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
