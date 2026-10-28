class SavedAddress {
  final String id;
  final String title; // 'Home', 'Work', 'Office', etc.
  final String addressLine;
  final String tag; // 'home', 'work', 'other'
  final bool isDefault;

  const SavedAddress({
    required this.id,
    required this.title,
    required this.addressLine,
    this.tag = 'home',
    this.isDefault = false,
  });

  SavedAddress copyWith({
    String? id,
    String? title,
    String? addressLine,
    String? tag,
    bool? isDefault,
  }) {
    return SavedAddress(
      id: id ?? this.id,
      title: title ?? this.title,
      addressLine: addressLine ?? this.addressLine,
      tag: tag ?? this.tag,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'addressLine': addressLine,
      'tag': tag,
      'isDefault': isDefault,
    };
  }

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      id: json['id'] as String,
      title: json['title'] as String,
      addressLine: json['addressLine'] as String,
      tag: (json['tag'] as String?) ?? 'home',
      isDefault: (json['isDefault'] as bool?) ?? false,
    );
  }
}
