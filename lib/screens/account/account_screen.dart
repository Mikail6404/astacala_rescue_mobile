// package:astacala_rescue_mobile/screens/account/account_screen.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
import 'package:astacala_rescue_mobile/screens/account/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // --- Profile Header ---
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 12),
        const Text(
          'UcupAlamsyah', // This will be dynamic later
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        const Divider(),

        // --- Settings Options ---
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit akun'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Keluar', style: TextStyle(color: Colors.red)),
          onTap: () {
            // Call the logout method from the AuthCubit
            context.read<AuthCubit>().logout();
          },
        ),
      ],
    );
  }
}