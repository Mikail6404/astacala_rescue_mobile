// package:astacala_rescue_mobile/cubits/profile/profile_cubit.dart

import 'package:astacala_rescue_mobile/cubits/profile/profile_state.dart';
import 'package:astacala_rescue_mobile/models/user_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      // TODO: Backend Integration
      // Replace this mock data with a real API call to get the current user's profile.
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      final mockProfile = UserProfileModel(
        username: 'ucupalamsyah',
        fullName: 'Ucup Alamsyah Syahdu',
        birthDate: '04-05-2004',
        phone: '08783736466',
        organization: 'Yayasan Astacala',
        profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      );
      emit(ProfileLoaded(mockProfile));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> updateUserProfile(UserProfileModel updatedProfile) async {
    emit(ProfileLoading());
    try {
      // TODO: Backend Integration
      // Replace this with a real API call (e.g., HTTP PUT/POST) to send the
      // updatedProfile data to your server. The API should handle saving the new data.
      await Future.delayed(const Duration(seconds: 2));
      print('--- Updating Profile ---');
      print('Username: ${updatedProfile.username}');
      print('Full Name: ${updatedProfile.fullName}');
      print('----------------------');
      
      emit(ProfileUpdateSuccess());
      // After success, fetch the profile again to show the latest data.
      fetchUserProfile();
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}