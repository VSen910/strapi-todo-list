class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['attributes']['Title'],
      description: json['attributes']['Description'],
      isCompleted: json['attributes']['Completed'],
    );
  }
}
