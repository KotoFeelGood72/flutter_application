class UserItemNews {
  final String id;
  final String name;

  UserItemNews({required this.id, required this.name});

  factory UserItemNews.fromJson(Map<String, dynamic> json) {
    return UserItemNews(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
