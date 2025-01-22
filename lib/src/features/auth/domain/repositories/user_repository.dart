import '../../../features.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(UserProfile profile);
  Future<UserProfile?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> deleteUserProfile(String userId);
}