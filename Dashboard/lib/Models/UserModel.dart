class UserModel {
  String? adminId;
  int? clientNumber;
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? phone;
  String? token;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.adminId,
    this.clientNumber,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.token,
    this.userType,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      adminId: json['_id'],
      clientNumber: json['client_number'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      token: json['token'],
      userType: json['user_type'] = 'admin',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': adminId,
      'client_number': clientNumber,
      'first_name': firstname,
      'last_name': lastname,
      'email': email,
      'phone': phone,
      'password': password,
      'token': token,
      'user_type': userType,
    };
  }
}
