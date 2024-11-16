import 'package:note/features/folders/domain/entities/folder_entity.dart';

class FolderModel extends FolderEntity {
  FolderModel({
    required super.isSynced,
    required super.isDeleted,
    required super.isUpdated,
    required super.userID,
    required super.description,
    required super.id,
    required super.name,
    required super.color,
  });

  FolderModel copyWith({
    String? id,
    String? name,
    String? description,
    int? color,
    String? userID,
    int? isSynced,
    int? isDeleted,
    int? isUpdated,
  }) {
    return FolderModel(
      userID: userID ?? this.userID,
      isSynced: isSynced ?? this.isSynced,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      isDeleted: isDeleted ?? this.isDeleted,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'is_synced': isSynced,
      'user_id': userID,
      'name': name,
      'description': description,
      'color': color,
      'is_deleted': isDeleted,
      'is_updated': isUpdated,
    };
  }

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: json['color'] as int,
      isSynced: json['is_synced'] as int,
      userID: json['user_id'] as String,
      isDeleted: json['is_deleted'] as int,
      isUpdated: json['is_updated'] as int,
    );
  }

  // Mapper function to create FolderModel from FolderEntity
  static FolderModel fromEntity(FolderEntity entity) {
    return FolderModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      color: entity.color,
      userID: entity.userID,
      isSynced: entity.isSynced,
      isDeleted: entity.isDeleted,
      isUpdated: entity.isUpdated,
    );
  }

  // Mapper function to convert FolderModel back to FolderEntity
  FolderEntity toEntity() {
    return FolderEntity(
      id: id,
      name: name,
      description: description,
      color: color,
      userID: userID,
      isSynced: isSynced,
      isDeleted: isDeleted,
      isUpdated: isUpdated,
    );
  }
}
