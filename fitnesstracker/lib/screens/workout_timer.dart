import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutTimer extends StatefulWidget {
  final Workout workout;

  const WorkoutTimer({super.key, required this.workout});

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  late List<int> durations; // Duration of each exercise
  int currentExerciseIndex = 0;
  bool isTimerRunning = false;
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();
    durations = widget.workout.exercises.map((exercise) => exercise.duration).toList();
    if (durations.isNotEmpty) {
      remainingTime = durations[currentExerciseIndex];
    }
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
    });

    Future.delayed(Duration(seconds: remainingTime), () {
      setState(() {
        currentExerciseIndex++;
        if (currentExerciseIndex < durations.length) {
          remainingTime = durations[currentExerciseIndex];
        } else {
          isTimerRunning = false; // Timer finished for all exercises
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text('Workout Timer'),
        backgroundColor: Colors.green[900], // Match HomeScreen style
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to match HomeScreen
        child: Center(
          child: isTimerRunning
              ? Text(
            'Time Remaining: $remainingTime seconds',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Exercise: ${widget.workout.exercises[currentExerciseIndex].name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Match button style
                ),
                child: const Text('Start Timer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
