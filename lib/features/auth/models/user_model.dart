// lib/features/auth/models/user_model.dart

class User {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final String idNumber;
  final String province;
  final String role; // Added role field
  final DateTime createdAt;

  User({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.idNumber,
    required this.province,
    this.role = 'user', // Default role is 'user'
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'email': email,
      'idNumber': idNumber,
      'province': province,
      'role': role, // Include role in map
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      email: map['email'] ?? '',
      idNumber: map['idNumber'] ?? '',
      province: map['province'] ?? '',
      role: map['role'] ?? 'user', // Parse role from map
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  User copyWith({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? idNumber,
    String? province,
    String? role, // Add role to copyWith
    DateTime? createdAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      idNumber: idNumber ?? this.idNumber,
      province: province ?? this.province,
      role: role ?? this.role, // Include role in copyWith
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, surname: $surname, email: $email, idNumber: $idNumber, province: $province, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.name == name &&
        other.surname == surname &&
        other.email == email &&
        other.idNumber == idNumber &&
        other.province == province &&
        other.role == role;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
    name.hashCode ^
    surname.hashCode ^
    email.hashCode ^
    idNumber.hashCode ^
    province.hashCode ^
    role.hashCode; // Include role in hash
  }
}