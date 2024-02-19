class GroupResponseModel {
  final int groupNumber;
  final List<String> members;
  final String description;

  GroupResponseModel({
    required this.groupNumber,
    required this.members,
    required this.description,
  });

  factory GroupResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupResponseModel(
      groupNumber: json['groupNumber'] ?? 0,
      members: List<String>.from(json['members'] ?? []),
      description: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupNumber': groupNumber,
      'members': members,
      'description':description,
    };
  }
}
