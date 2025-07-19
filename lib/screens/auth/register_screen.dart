// lib/screens/auth/register_screen.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
import 'package:astacala_rescue_mobile/cubits/auth/auth_state.dart';
import 'package:astacala_rescue_mobile/widgets/custom_button.dart';
import 'package:astacala_rescue_mobile/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  // Controllers for form data
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _organizationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _organizationController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    // Basic validation
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi data yang wajib diisi')),
      );
      return;
    }

    // Call registration
    context.read<AuthCubit>().register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
          phone:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          organization: _organizationController.text.isNotEmpty
              ? _organizationController.text
              : null,
          birthDate: _birthDateController.text.isNotEmpty
              ? _birthDateController.text
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Field
                    CustomTextField(
                      labelText: 'Email *',
                      controller: _emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    CustomTextField(
                      labelText: 'Password *',
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      enabled: !isLoading,
                      suffixIcon: _isPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    CustomTextField(
                      labelText: 'Konfirmasi Password *',
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmPasswordObscured,
                      enabled: !isLoading,
                      suffixIcon: _isConfirmPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isConfirmPasswordObscured =
                              !_isConfirmPasswordObscured;
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Name Field
                    CustomTextField(
                      labelText: 'Nama lengkap *',
                      controller: _nameController,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Birth Date Field
                    CustomTextField(
                      labelText: 'Tanggal Lahir (yyyy-mm-dd)',
                      controller: _birthDateController,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Organization Field
                    CustomTextField(
                      labelText: 'Organisasi',
                      controller: _organizationController,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    CustomTextField(
                      labelText: 'Nomor handphone',
                      controller: _phoneController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),

                    // Register Button
                    CustomButton(
                      text: isLoading ? 'Mendaftar...' : 'Daftar',
                      onPressed: isLoading ? null : _handleRegistration,
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      '* Wajib diisi',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
