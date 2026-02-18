class Member {
  String uid = "";
  String fullname = "";
  String email = "";
  String password = "";
  // ignore: non_constant_identifier_names
  String img_url = "";

  // ignore: non_constant_identifier_names
  String device_id = "";
  // ignore: non_constant_identifier_names
  String device_type = "";
  // ignore: non_constant_identifier_names
  String device_token = "";

  bool followed = false;
  // ignore: non_constant_identifier_names
  int followers_count = 0;
  // ignore: non_constant_identifier_names
  int following_count = 0;

  Member(this.fullname, this.email);

  Member.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullname = json['fullname'],
        email = json['email'],
        password = json['password'],
        img_url = json['img_url'],
        device_id = json['device_id'],
        device_type = json['device_type'],
        device_token = json['device_token'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'fullname': fullname,
    'email': email,
    'password': password,
    'img_url': img_url,
    'device_id': device_id,
    'device_type': device_type,
    'device_token': device_token,
  };
}