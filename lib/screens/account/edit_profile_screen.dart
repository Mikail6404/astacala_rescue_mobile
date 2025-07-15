// package:astacala_rescue_mobile/screens/account/edit_profile_screen.dart

import 'package:astacala_rescue_mobile/cubits/profile/profile_cubit.dart';
import 'package:astacala_rescue_mobile/cubits/profile/profile_state.dart';
import 'package:astacala_rescue_mobile/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..fetchUserProfile(),
      child: const EditProfileView(),
    );
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Akun Profil'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profil berhasil diperbarui!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return _ProfileForm(userProfile: state.userProfile);
          }
          // Show a loading spinner while fetching initial profile data
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _ProfileForm extends StatefulWidget {
  final UserProfileModel userProfile;

  const _ProfileForm({required this.userProfile});

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  late final TextEditingController _usernameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _phoneController;
  late final TextEditingController _organizationController;

  @override
  void initState() {
    super.initState();
    // TODO: Backend Integration - This data is populated from the API call.
    _usernameController = TextEditingController(text: widget.userProfile.username);
    _fullNameController = TextEditingController(text: widget.userProfile.fullName);
    _birthDateController = TextEditingController(text: widget.userProfile.birthDate);
    _phoneController = TextEditingController(text: widget.userProfile.phone);
    _organizationController = TextEditingController(text: widget.userProfile.organization);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _organizationController.dispose();
    super.dispose();
  }
  
  void _onSave() {
      final updatedProfile = UserProfileModel(
          username: _usernameController.text,
          fullName: _fullNameController.text,
          birthDate: _birthDateController.text,
          phone: _phoneController.text,
          organization: _organizationController.text,
          profileImageUrl: widget.userProfile.profileImageUrl,
      );
      context.read<ProfileCubit>().updateUserProfile(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // --- Profile Picture Section ---
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: widget.userProfile.profileImageUrl != null
                    ? NetworkImage(widget.userProfile.profileImageUrl!)
                    : null,
                child: widget.userProfile.profileImageUrl == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: () {
                      // TODO: Backend Integration
                      // This should trigger the image picker, and upon selecting an image,
                      // upload it to your server and get back a new URL.
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Form Fields ---
          TextFormField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: 16),
          TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
          const SizedBox(height: 16),
          TextFormField(controller: _birthDateController, decoration: const InputDecoration(labelText: 'Tanggal Lahir')),
          const SizedBox(height: 16),
          TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'No Telepon')),
          const SizedBox(height: 16),
          TextFormField(controller: _organizationController, decoration: const InputDecoration(labelText: 'Nama Instansi / Organisasi')),
          const SizedBox(height: 32),
          
          // --- Save Button ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSave,
              child: const Text('Simpan'),
            ),
          )
        ],
      ),
    );
  }
}
