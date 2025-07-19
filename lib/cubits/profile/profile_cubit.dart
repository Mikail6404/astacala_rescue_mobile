// package:astacala_rescue_mobile/cubits/profile/profile_cubit.dart

import 'package:astacala_rescue_mobile/cubits/profile/profile_state.dart';
import 'package:astacala_rescue_mobile/models/user_profile_model.dart';
import 'package:astacala_rescue_mobile/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      // Call the real API endpoint
      final response = await ApiService.getUserProfile();

      // Extract user data from response
      final userData = response['user'] ?? response;

      // Convert API response to UserProfileModel
      final profile = UserProfileModel(
        username: userData['email'] ?? '', // Use email as username for now
        fullName: userData['name'] ?? '',
        birthDate: userData['birth_date'] ?? '',
        phone: userData['phone'] ?? '',
        organization: userData['organization'] ?? '',
        profileImageUrl: userData['avatar_url'] ?? '',
      );

      emit(ProfileLoaded(profile));
    } on ApiException catch (e) {
      emit(ProfileFailure(e.toString()));
    } catch (e) {
      emit(ProfileFailure('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> updateUserProfile(UserProfileModel updatedProfile) async {
    emit(ProfileLoading());
    try {
      // Call the real API endpoint
      await ApiService.updateUserProfile(
        name: updatedProfile.fullName,
        phone: updatedProfile.phone.isNotEmpty ? updatedProfile.phone : null,
        organization: updatedProfile.organization.isNotEmpty
            ? updatedProfile.organization
            : null,
        birthDate: updatedProfile.birthDate.isNotEmpty
            ? updatedProfile.birthDate
            : null,
      );

      emit(ProfileUpdateSuccess());

      // After successful update, fetch the profile again to show the latest data
      await fetchUserProfile();
    } on ApiException catch (e) {
      emit(ProfileFailure(e.toString()));
    } catch (e) {
      emit(ProfileFailure('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> updateUserAvatar(File avatarFile) async {
    emit(ProfileLoading());
    try {
      // Call the real API endpoint for avatar upload
      await ApiService.updateUserAvatar(avatarFile);

      emit(ProfileUpdateSuccess());

      // After successful avatar update, fetch the profile again to show the new avatar
      await fetchUserProfile();
    } on ApiException catch (e) {
      emit(ProfileFailure(e.toString()));
    } catch (e) {
      emit(ProfileFailure('Failed to update avatar: ${e.toString()}'));
    }
  }
}
