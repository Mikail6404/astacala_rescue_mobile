// lib/screens/auth/register_screen.dart

import 'package:astacala_rescue_mobile/widgets/custom_button.dart';
import 'package:astacala_rescue_mobile/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomTextField(labelText: 'Username'),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Password',
                obscureText: _isPasswordObscured,
                suffixIcon: _isPasswordObscured 
                    ? Icons.visibility_off 
                    : Icons.visibility,
                onSuffixIconPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
              ),
              const SizedBox(height: 8),
              const Text(
                '• Password berisi minimal 8 karakter\n• Terdapat huruf kapital, nomor dan karakter unik',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Isi data diri',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const CustomTextField(labelText: 'Nama lengkap'),
              const SizedBox(height: 16),
              const CustomTextField(labelText: 'Tanggal Lahir (dd-mm-yyyy)'),
              const SizedBox(height: 16),
              const CustomTextField(labelText: 'Tempat Lahir'),
              const SizedBox(height: 16),
              const CustomTextField(labelText: 'Nomor handphone'),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Daftar',
                onPressed: () {
                  // TODO: Implement registration logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}