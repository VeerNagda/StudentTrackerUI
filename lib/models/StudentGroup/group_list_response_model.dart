
import 'dart:convert';

GroupListResponseModel groupListResponse(String str) =>
    GroupListResponseModel.fromJson(jsonDecode(str));


class GroupListResponseModel {
  late String iD;
  late String name;
  late int numMembers;

  GroupListResponseModel({required this.iD, required this.name, required this.numMembers});

  GroupListResponseModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    numMembers = json['num_members'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    data['num_members'] = numMembers;
    return data;
  }
}