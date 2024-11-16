class FolderEntity {
  final String id;
  final String userID;
  final int isSynced;
  final int isUpdated;
  final int isDeleted;
  final String name;
  final String description;
  final int color;

  FolderEntity({
    required this.userID,
    this.isSynced = 0,
    this.isDeleted = 0,
    this.isUpdated = 0,
    required this.description,
    required this.id,
    required this.name,
    required this.color,
  });
}
