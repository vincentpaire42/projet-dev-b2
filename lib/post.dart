class Post {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorFirstName;
  final String authorLastNameInitial;
  final String budget;
  final String Lieux;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorFirstName,
    required this.authorLastNameInitial,
    required this.budget,
    required this.Lieux,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      authorId: map['authorId'],
      authorFirstName: map['authorFirstName'],
      authorLastNameInitial: map['authorLastNameInitial'],
      budget: map['budget'],
      Lieux: map['lieu']
    );
  }
}
