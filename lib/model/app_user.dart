class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String dob;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
    'gender': gender,
    'dob': dob,
  };
}
