class GroupResponseModel {
  final int? groupNumber; // Change int to int?
  final List<String> members;
  final String name;

  GroupResponseModel({
    required this.groupNumber,
    required this.members,
    required this.name,
  });

  factory GroupResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupResponseModel(
      groupNumber: json['groupNumber'],
      members: List<String>.from(json['members'] ?? []),
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupNumber': groupNumber, // groupNumber can be null
      'members': members,
      'name': name,
    };
  }
}
