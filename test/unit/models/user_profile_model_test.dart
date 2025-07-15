// Unit tests for UserProfileModel
// test/unit/models/user_profile_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:astacala_rescue_mobile/models/user_profile_model.dart';

void main() {
  group('UserProfileModel Tests', () {
    late UserProfileModel testUserProfile;

    setUp(() {
      testUserProfile = UserProfileModel(
        username: 'john_doe',
        fullName: 'John Doe',
        birthDate: '1990-01-01',
        phone: '081234567890',
        organization: 'Astacala Rescue Team',
        profileImageUrl: 'https://example.com/profile.jpg',
      );
    });

    test('should create UserProfileModel with all fields', () {
      expect(testUserProfile.username, 'john_doe');
      expect(testUserProfile.fullName, 'John Doe');
      expect(testUserProfile.birthDate, '1990-01-01');
      expect(testUserProfile.phone, '081234567890');
      expect(testUserProfile.organization, 'Astacala Rescue Team');
      expect(
          testUserProfile.profileImageUrl, 'https://example.com/profile.jpg');
    });

    test('should create UserProfileModel without profile image', () {
      final userWithoutImage = UserProfileModel(
        username: 'jane_doe',
        fullName: 'Jane Doe',
        birthDate: '1992-05-15',
        phone: '087654321098',
        organization: 'Emergency Response',
      );

      expect(userWithoutImage.username, 'jane_doe');
      expect(userWithoutImage.fullName, 'Jane Doe');
      expect(userWithoutImage.profileImageUrl, null);
    });

    test('should validate phone number format', () {
      expect(
          testUserProfile.phone, matches(r'^08\d{8,}$')); // Indonesian format
      expect(testUserProfile.phone.length, greaterThanOrEqualTo(10));
    });

    test('should validate birth date format', () {
      expect(testUserProfile.birthDate,
          matches(r'^\d{4}-\d{2}-\d{2}$')); // YYYY-MM-DD
    });

    test('should validate username format', () {
      expect(testUserProfile.username, isNotEmpty);
      expect(testUserProfile.username,
          matches(r'^[a-zA-Z0-9_]+$')); // Alphanumeric + underscore
    });

    test('should handle full name with special characters', () {
      final userWithSpecialName = UserProfileModel(
        username: 'user_123',
        fullName: 'Dr. John O\'Connor Jr.',
        birthDate: '1985-12-25',
        phone: '081234567890',
        organization: 'Medical Team',
      );

      expect(userWithSpecialName.fullName, contains('\''));
      expect(userWithSpecialName.fullName, contains('.'));
    });

    test('should handle long organization names', () {
      final userWithLongOrg = UserProfileModel(
        username: 'volunteer_1',
        fullName: 'Test User',
        birthDate: '1988-03-10',
        phone: '081234567890',
        organization:
            'International Emergency Response and Disaster Management Organization',
      );

      expect(userWithLongOrg.organization.length, greaterThan(50));
      expect(userWithLongOrg.organization, isNotEmpty);
    });
  });

  group('UserProfileModel Validation Tests', () {
    test('should handle empty string fields appropriately', () {
      final userWithEmptyFields = UserProfileModel(
        username: '',
        fullName: '',
        birthDate: '',
        phone: '',
        organization: '',
      );

      expect(userWithEmptyFields.username, isEmpty);
      expect(userWithEmptyFields.fullName, isEmpty);
      expect(userWithEmptyFields.birthDate, isEmpty);
      expect(userWithEmptyFields.phone, isEmpty);
      expect(userWithEmptyFields.organization, isEmpty);
    });

    test('should handle various profile image URL formats', () {
      final userWithHttpUrl = UserProfileModel(
        username: 'user1',
        fullName: 'User One',
        birthDate: '1990-01-01',
        phone: '081234567890',
        organization: 'Team A',
        profileImageUrl: 'http://example.com/image.png',
      );

      final userWithHttpsUrl = UserProfileModel(
        username: 'user2',
        fullName: 'User Two',
        birthDate: '1990-01-01',
        phone: '081234567890',
        organization: 'Team B',
        profileImageUrl: 'https://secure.example.com/profile.jpg',
      );

      final userWithLocalPath = UserProfileModel(
        username: 'user3',
        fullName: 'User Three',
        birthDate: '1990-01-01',
        phone: '081234567890',
        organization: 'Team C',
        profileImageUrl: '/local/path/to/image.jpg',
      );

      expect(userWithHttpUrl.profileImageUrl, startsWith('http://'));
      expect(userWithHttpsUrl.profileImageUrl, startsWith('https://'));
      expect(userWithLocalPath.profileImageUrl, startsWith('/'));
    });

    test('should handle different date formats edge cases', () {
      final usersWithDifferentDates = [
        UserProfileModel(
          username: 'user_leap',
          fullName: 'Leap Year User',
          birthDate: '2000-02-29', // Leap year
          phone: '081234567890',
          organization: 'Test Org',
        ),
        UserProfileModel(
          username: 'user_old',
          fullName: 'Old User',
          birthDate: '1950-01-01', // Very old
          phone: '081234567890',
          organization: 'Test Org',
        ),
        UserProfileModel(
          username: 'user_recent',
          fullName: 'Recent User',
          birthDate: '2005-12-31', // Recent birth
          phone: '081234567890',
          organization: 'Test Org',
        ),
      ];

      for (final user in usersWithDifferentDates) {
        expect(user.birthDate, matches(r'^\d{4}-\d{2}-\d{2}$'));
        expect(user.birthDate.length, 10);
      }
    });
  });

  group('UserProfileModel Business Logic Tests', () {
    test('should represent volunteer profile correctly', () {
      final volunteer = UserProfileModel(
        username: 'volunteer_rescue_001',
        fullName: 'Ahmad Wijaya',
        birthDate: '1985-08-17',
        phone: '081234567890',
        organization: 'Astacala Rescue Jakarta',
        profileImageUrl:
            'https://storage.astacala.com/profiles/volunteer_001.jpg',
      );

      expect(volunteer.organization, contains('Astacala'));
      expect(volunteer.fullName, contains('Ahmad'));
      expect(volunteer.username, contains('volunteer'));
    });

    test('should represent team leader profile correctly', () {
      final teamLeader = UserProfileModel(
        username: 'leader_team_alpha',
        fullName: 'Siti Nurhaliza',
        birthDate: '1980-12-05',
        phone: '081987654321',
        organization: 'Tim Alpha - Astacala Rescue',
      );

      expect(teamLeader.username, contains('leader'));
      expect(teamLeader.organization, contains('Tim Alpha'));
    });

    test('should handle profile update scenarios', () {
      final originalProfile = UserProfileModel(
        username: 'user_original',
        fullName: 'Original Name',
        birthDate: '1990-01-01',
        phone: '081111111111',
        organization: 'Original Org',
      );

      // Simulate profile update
      final updatedProfile = UserProfileModel(
        username: originalProfile.username, // Username typically doesn't change
        fullName: 'Updated Full Name',
        birthDate:
            originalProfile.birthDate, // Birth date typically doesn't change
        phone: '082222222222',
        organization: 'Updated Organization',
        profileImageUrl: 'https://new-image-url.com/profile.jpg',
      );

      expect(updatedProfile.username, originalProfile.username);
      expect(updatedProfile.birthDate, originalProfile.birthDate);
      expect(updatedProfile.fullName, isNot(originalProfile.fullName));
      expect(updatedProfile.phone, isNot(originalProfile.phone));
      expect(updatedProfile.organization, isNot(originalProfile.organization));
    });
  });
}
