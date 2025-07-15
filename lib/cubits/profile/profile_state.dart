// package:astacala_rescue_mobile/cubits/profile/profile_state.dart

import 'package:astacala_rescue_mobile/models/user_profile_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel userProfile;
  ProfileLoaded(this.userProfile);
}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure(this.error);
}
