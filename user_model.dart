enum UserRole { superAdmin, storeAdmin, ptAdmin, athlete, customer }

UserRole roleFromString(String value) {
  switch (value) {
    case 'super_admin':
      return UserRole.superAdmin;
    case 'store_admin':
      return UserRole.storeAdmin;
    case 'pt_admin':
      return UserRole.ptAdmin;
    case 'athlete':
      return UserRole.athlete;
    default:
      return UserRole.customer;
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String username;
  final UserRole role;
  final String preferredLanguage;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.role,
    required this.preferredLanguage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      role: roleFromString(json['role'] as String),
      preferredLanguage: json['preferred_language'] as String? ?? 'tr',
    );
  }
}
