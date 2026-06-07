import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LupaPasswordScreen extends StatefulWidget {
  const LupaPasswordScreen({super.key});

  @override
  State<LupaPasswordScreen> createState() => _LupaPasswordScreenState();
}

class _LupaPasswordScreenState extends State<LupaPasswordScreen> {
  final _emailController = TextEditingController();
  bool passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 120),
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
              "Lupa Password",
              style: TextStyle(
                  fontFamily: "Montserrat-Bold",
                  fontSize: 36,
                  letterSpacing: -2,
                  decoration: TextDecoration.underline),
            ),
            Container(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 7,
                ),
                SizedBox(
                  width: 243,
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(height: 1),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Email/Username',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Harap masukkan email terlebih dahulu')),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tautan reset password berhasil dikirim (Simulasi)!')),
                    );
                    Navigator.pushNamed(context, "/reset-password", arguments: email);
                  },
                  icon: SvgPicture.asset(
                    "assets/svgs/sent-verif-link.svg",
                    width: 66,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 317,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Didn't receive the reset link? ",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4)),
                  InkWell(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                    'Kami sudah mengirimkan ulang tautan verifikasi ke alamat email anda, silahkan anda cek kembali!'),
                                const SizedBox(height: 15),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.purple[100],
                                      ),
                                      child: const Text(
                                        'Tutup Pesan',
                                        style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: -0.2),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text("Resend verif email.",
                        style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  fixedSize: const Size(329, 50)),
              child: Text(
                'Back To Login Page',
                style: TextStyle(
                  fontFamily: "Montserrat-SemiBold",
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
