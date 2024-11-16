// lib/features/auth/models/user.dart

class User {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final String idNumber;
  final String province;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.idNumber,
    required this.province,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'email': email,
      'idNumber': idNumber,
      'province': province,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      email: map['email'] ?? '',
      idNumber: map['idNumber'] ?? '',
      province: map['province'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  // Create a copy of the User with some updated fields
  User copyWith({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? idNumber,
    String? province,
    DateTime? createdAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      idNumber: idNumber ?? this.idNumber,
      province: province ?? this.province,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ToString method for debugging
  @override
  String toString() {
    return 'User(uid: $uid, name: $name, surname: $surname, email: $email, idNumber: $idNumber, province: $province)';
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.name == name &&
        other.surname == surname &&
        other.email == email &&
        other.idNumber == idNumber &&
        other.province == province;
  }

  // Hash code
  @override
  int get hashCode {
    return uid.hashCode ^
    name.hashCode ^
    surname.hashCode ^
    email.hashCode ^
    idNumber.hashCode ^
    province.hashCode;
  }
}