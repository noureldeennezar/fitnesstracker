class Exercise {
  String name;
  int duration; // Duration in seconds

  Exercise({
    required this.name,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration': duration,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      duration: map['duration'],
    );
  }
}
