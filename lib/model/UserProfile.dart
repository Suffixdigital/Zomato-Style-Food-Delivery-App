class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String dob;
  final String gender;

  UserProfile({required this.id, required this.fullName, required this.email, required this.phone, required this.dob, required this.gender});

  Map<String, dynamic> toJson() => {'id': id, 'full_name': fullName, 'email': email, 'phone': phone, 'dob': dob, 'gender': gender};

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    dob: json['dob'] as String,
    gender: json['gender'] as String,
  );
}
