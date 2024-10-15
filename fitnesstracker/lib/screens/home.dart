import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/workout.dart';
import '../database/workout_database.dart';
import 'create_workout.dart';
import 'modify_workout.dart';
import 'settings.dart';

const String cardioImageUrl =
    'https://th.bing.com/th/id/OIP.LXfQEBUswD7U0kg0LSZFvQHaEK?rs=1&pid=ImgDetMain';
const String strengthImageUrl =
    'https://th.bing.com/th/id/R.7fea2c175cd965afeecf786f30b4c16c?rik=NxEBnnJN9cPcNA&pid=ImgRaw&r=0';
const String flexibilityImageUrl =
    'https://th.bing.com/th/id/R.5f18f030d1a84d36c1bfdef74a9ea97b?rik=%2fHHBMzEFFsB3fw&pid=ImgRaw&r=0';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.user});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final WorkoutDatabase _dbHelper = WorkoutDatabase();
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await _dbHelper.getAllWorkouts();
    setState(() {
      _workouts = workouts;
    });
  }

  String _getCategoryImage(String category) {
    switch (category) {
      case 'Cardio':
        return cardioImageUrl;
      case 'Strength':
        return strengthImageUrl;
      case 'Flexibility':
        return flexibilityImageUrl;
      default:
        return '';
    }
  }

  void _navigateToCreateWorkout() async {
    final newWorkout = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateWorkoutScreen(user: widget.user)),
    );

    if (newWorkout != null) {
      _loadWorkouts(); // Refresh the workouts list after adding a new workout
    }
  }

  void _navigateToEditWorkout(Workout workout) async {
    final updatedWorkout = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifyWorkoutScreen(user: widget.user, workout: workout),
      ),
    );

    if (updatedWorkout != null) {
      _loadWorkouts(); // Refresh the workouts list after editing
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings(user: widget.user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workouts',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          final imageUrl = _getCategoryImage(workout.category ?? '');

          return Card(
            child: Column(
              children: [
                if (imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Image not available'));
                    },
                  ),
                ListTile(
                  title: Text(workout.name),
                  subtitle: Text(workout.description ?? 'No description available'),
                  trailing: Text(workout.category ?? 'Unknown'),
                  onTap: () => _navigateToEditWorkout(workout),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateWorkout,
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
