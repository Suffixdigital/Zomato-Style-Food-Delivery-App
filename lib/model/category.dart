class Category {
  final String id; // UUID as string
  final String icon;
  final String label;
  final int displayOrder;

  Category({
    required this.id,
    required this.icon,
    required this.label,
    required this.displayOrder,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      icon: json['icon'] as String,
      label: json['label'] as String,
      displayOrder: json['display_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'label': label,
      'display_order': displayOrder,
    };
  }
}
