import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../database/workout_database.dart';
import 'exercise_details.dart';
import 'home.dart';

class ModifyWorkoutScreen extends StatefulWidget {
  final Workout workout;
  final Map<String, dynamic> user;

  const ModifyWorkoutScreen({super.key, required this.workout, required this.user});

  @override
  ModifyWorkoutScreenState createState() => ModifyWorkoutScreenState();
}

class ModifyWorkoutScreenState extends State<ModifyWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final WorkoutDatabase _dbHelper = WorkoutDatabase();
  String? _name;
  String? _description;
  List<Exercise> _exercises = [];
  final _exerciseNameController = TextEditingController();
  final _exerciseDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.workout.name;
    _description = widget.workout.description;
    _exercises = List.from(widget.workout.exercises);
  }

  void _updateWorkout() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedWorkout = Workout(
        id: widget.workout.id,
        name: _name!,
        description: _description!,
        exercises: _exercises,
      );
      await _dbHelper.updateWorkout(updatedWorkout);
      Navigator.pop(context); // Return to HomeScreen
    }
  }

  void _addExercise() {
    if (_exerciseNameController.text.isNotEmpty &&
        _exerciseDurationController.text.isNotEmpty) {
      setState(() {
        _exercises.add(Exercise(
          name: _exerciseNameController.text,
          duration: int.parse(_exerciseDurationController.text),
        ));
        _exerciseNameController.clear();
        _exerciseDurationController.clear();
      });
    }
  }

  void _deleteWorkout() async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Workout'),
          content: const Text('Are you sure you want to delete this workout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      print("Attempting to delete workout with id: ${widget.workout.id}");
      int rowsDeleted = await _dbHelper.deleteWorkout(widget.workout.id!);
      print("Rows deleted: $rowsDeleted");
      if (rowsDeleted > 0) {
        Navigator.pop(context); // Return to HomeScreen
      } else {
        print("Deletion failed or workout not found.");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modify Workout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900], // Match the color with HomeScreen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
            );
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Workout Name'),
                onSaved: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _exerciseNameController,
                decoration: const InputDecoration(labelText: 'Exercise Name'),
              ),
              TextFormField(
                controller: _exerciseDurationController,
                decoration: const InputDecoration(labelText: 'Duration (seconds)'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _addExercise,
                child: const Text('Add Exercise'),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                itemCount: _exercises.length,
                shrinkWrap: true, // Add this
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                itemBuilder: (context, index) {
                  final exercise = _exercises[index];
                  return Card(
                    child: ListTile(
                      title: Text(exercise.name),
                      subtitle: Text('Duration: ${exercise.duration} seconds'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetailsScreen(
                              exerciseName: exercise.name,
                              duration: exercise.duration,
                              user: widget.user,
                              workout: widget.workout,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _updateWorkout,
                    child: const Text('Update Workout'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteWorkout,
                    child: const Text('Delete Workout', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
