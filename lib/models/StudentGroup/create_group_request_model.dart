class CreateGroupRequestModel {
  late String groupId;
  late String groupName;

  CreateGroupRequestModel({required this.groupId, required this.groupName});

  CreateGroupRequestModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupName = json['group_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['group_name'] = groupName;
    return data;
  }
}
