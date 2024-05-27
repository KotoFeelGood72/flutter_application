class NotificationModel {
  final int id;
  final String createdAt;
  final String iconPath;
  final String title;
  final String description;
  final bool isView;
  final String type;
  final int contentId;
  final String image;
  final int? apartmentId;

  NotificationModel({
    required this.id,
    required this.createdAt,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.isView,
    required this.type,
    required this.contentId,
    required this.image,
    this.apartmentId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      createdAt: json['created_at'],
      iconPath: json['icon_path'],
      title: json['title'],
      description: json['description'],
      isView: json['is_view'],
      type: json['type'],
      contentId: json['content_id'],
      image: json['image'],
      apartmentId: json['apartment_id'],
    );
  }
}
