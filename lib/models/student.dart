class Student {
  final int id;
  final String name;
  final String profilePicture;

  const Student(
      {required this.id, required this.name, required this.profilePicture});

  factory Student.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'profile_picture': String profilePicture,
      } =>
        Student(id: id, name: name, profilePicture: profilePicture),
      _ => throw const FormatException('Failed to fetch student.'),
    };
  }
}
