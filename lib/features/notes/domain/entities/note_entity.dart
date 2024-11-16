class NoteEntity {
  final String id;
  final int color;
  final String userId;
  final String title;
  final String content;
  final String? imageUrl;
  final List<String> folders;
  final DateTime uploadedAt;
  final int isSynced;
  final int isDeleted;
  final int isUpdated;

  NoteEntity({
    required this.id,
    required this.isSynced,
    required this.isDeleted,
    required this.isUpdated,
    required this.userId,
    required this.title,
    required this.content,
    this.color = 0,
    this.imageUrl,
    required this.folders,
    required this.uploadedAt,
  });
}
