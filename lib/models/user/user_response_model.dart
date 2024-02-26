class UserResponseModel {
  late String iD;
  late String rollNo;
  late String fName;
  late String lName;
  late String email;
  late String phone;
  late int role;

  UserResponseModel(
      {required this.iD,
        required this.rollNo,
        required this.fName,
        required this.lName,
        required this.email,
        required this.phone,
        required this.role});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    rollNo = json['Roll_No'];
    fName = json['FName'];
    lName = json['LName'];
    email = json['Email'];
    phone = json['Phone'];
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Roll_No'] = rollNo;
    data['FName'] = fName;
    data['LName'] = lName;
    data['Email'] = email;
    data['Phone'] = phone;
    data['Role'] = role;
    return data;
  }
}
