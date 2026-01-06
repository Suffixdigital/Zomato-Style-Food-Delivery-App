class EmailPhoneLinkRequest {
  /*"email": "kkpatadiya@gmail.com",
  "password": "Test@123",
  "phone": "918866121456",
  "full_name": "KK Patadiya",
  "dob": "17/05/1991",
  "gender": "male"*/
  final String email;
  final String password;
  final String phone;
  final String fullName;
  final String dob;
  final String gender;

  EmailPhoneLinkRequest({required this.email, required this.password, required this.phone, required this.fullName, required this.dob, required this.gender});

  Map<String, dynamic> toJson() => {'email': email, 'password': password, 'phone': phone, 'full_name': fullName, 'dob': dob, 'gender': gender};

  factory EmailPhoneLinkRequest.fromJson(Map<String, dynamic> json) => EmailPhoneLinkRequest(
    email: json['email'],
    fullName: json['fullName'],
    dob: json['dob'],
    gender: json['gender'],
    phone: json['phone'],
    password: json['password'],
  );
}
