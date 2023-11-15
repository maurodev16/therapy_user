class UserModel {
  String? userId;
  int? clientNumber;
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? token;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.userId,
    this.clientNumber,
    this.firstname,
    this.lastname,
    this.email,
    this.token,
    this.userType,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      clientNumber: json['client_number'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      userType: json['user_type'] = 'client',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'client_number': clientNumber,
      'first_name': firstname,
      'last_name': lastname,
      'email': email,
      'password': password,
      'token': token,
      'user_type': userType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
