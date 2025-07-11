// lib/screens/auth/welcome_screen.dart

import 'package:astacala_rescue_mobile/screens/auth/login_screen.dart';
import 'package:astacala_rescue_mobile/screens/auth/register_screen.dart';
import 'package:astacala_rescue_mobile/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(
                Icons.shield_outlined,
                size: 150,
                color: Color(0xFF8B0000),
              ),
              const SizedBox(height: 48.0),
              const Text(
                'Selamat datang di aplikasi First Responder',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Masuk atau daftar akun untuk melanjutkan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              const SizedBox(height: 48.0),
              CustomButton(
                text: 'Masuk',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 12.0),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Daftar akun', style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}