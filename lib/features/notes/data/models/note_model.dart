import 'package:note/features/notes/domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    super.imageUrl,
    super.color,
    required super.folders,
    required super.uploadedAt,
    required super.isSynced,
    required super.isDeleted,
    required super.isUpdated,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'color': color,
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'folders': folders.join(','),
      'uploaded_at': uploadedAt.toIso8601String(),
      'is_deleted': isDeleted,
      'is_synced': isSynced,
      'is_updated': isUpdated,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      color: map['color'],
      isDeleted: map['is_deleted'],
      isSynced: map['is_synced'],
      isUpdated: map['is_updated'],
      userId: map['user_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String?,
      folders: (map['folders'] as String)
          .split(','), // Explicitly casting the dynamic list to List<String>
      uploadedAt: DateTime.parse(map['uploaded_at']),
    );
  }

  NoteModel copyWith({
    int? color,
    String? id,
    String? userId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? folders,
    DateTime? uploadedAt,
    int? isSynced,
    int? isDeleted,
    int? isUpdated,
  }) {
    return NoteModel(
      color: color ?? this.color,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      folders: folders ?? this.folders,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }
}
