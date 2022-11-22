class UserObj {
  late final id;
  late final fullName;
  late final emailAddress;
  late final phoneNumber;
  late final password;
  late final status;
  late final role;
  late final gender;
  late final image;
  late final dob;
  late final fcmToken;
  late final authToken;
  UserObj(
      {this.id,
      this.fullName,
      this.emailAddress,
      this.password,
      this.phoneNumber,
      this.status,
      this.role,
      this.gender,
      this.image,
      this.dob,
      this.fcmToken,
      this.authToken});
  UserObj.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    fullName = json["fullName"];
    emailAddress = json["emailAddress"];
    phoneNumber = json["phoneNumber"];
    password = json["password"];
    status = json["status"];
    role = json["role"];
    gender = json["gender"];
    image = json["image"];
    dob = json["dob"];
    fcmToken = json["fcmToken"];
  }
  UserObj.login(Map<String, dynamic> json) {
    id = json["id"];
    fullName = json["fullName"];
    emailAddress = json["email"];
    phoneNumber = json["phone"];
    status = json["status"];
    role = json["role"];
    gender = json["gender"];
    image = json["image"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['email'] = this.emailAddress;
    data['phone'] = this.phoneNumber;
    data['password'] = this.password;
    data['fullname'] = this.fullName;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['dob'] = this.dob;

    return data;
  }
}
