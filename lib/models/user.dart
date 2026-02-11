class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String location;
  final String profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.location,
    required this.profileImageUrl,
  });

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? location,
    String? profileImageUrl,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
