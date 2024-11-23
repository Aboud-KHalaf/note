class UploadFolderModel {
  final String id;
  final String userID;
  final String name;
  final String description;
  final int color;

  UploadFolderModel({
    required this.id,
    required this.userID,
    required this.name,
    required this.description,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userID,
      'name': name,
      'description': description,
      'color': color,
    };
  }

  factory UploadFolderModel.fromJson(Map<String, dynamic> json) {
    return UploadFolderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: json['color'] as int,
      userID: json['user_id'] as String,
    );
  }
}
