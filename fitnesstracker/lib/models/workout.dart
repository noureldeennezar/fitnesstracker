import 'exercise.dart';

class Workout {
  int? id;
  String name;
  String? description; // Make description nullable
  String? category; // Add category field
  List<Exercise> exercises; // List of exercises in the workout

  Workout({
    this.id,
    required this.name,
    this.description, // Make description optional
    this.category, // Include category
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description, // Keep it as nullable
      'category': category, // Include category in the map
    };
  }

  static Workout fromMap(Map<String, dynamic> map, List<Exercise> exercises) {
    return Workout(
      id: map['id'],
      name: map['name'],
      description: map['description'], // Handle nullable description
      category: map['category'], // Handle nullable category
      exercises: exercises, // Pass exercises separately
    );
  }
}
