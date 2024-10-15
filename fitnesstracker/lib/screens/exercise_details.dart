import 'dart:async';
import 'package:fitnesstracker/models/workout.dart';
import 'package:flutter/material.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final String exerciseName;
  final int duration;
  final Map<String, dynamic> user;
  final Workout workout;

  const ExerciseDetailsScreen({
    super.key,
    required this.exerciseName,
    required this.duration,
    required this.user,
    required this.workout,
  });

  @override
  ExerciseDetailsScreenState createState() => ExerciseDetailsScreenState();
}

class ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  late int remainingTime;
  Timer? timer;
  bool isRunning = false; // Track if the timer is running

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
  }

  void startCountdown() {
    if (!isRunning) {
      isRunning = true;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          timer.cancel();
          isRunning = false; // Mark timer as not running
          // Show completion dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Exercise Complete!"),
                content: Text("${widget.exerciseName} is complete!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  void stopCountdown() {
    if (isRunning) {
      timer?.cancel(); // This is safe; it won't throw if timer is null
      setState(() {
        isRunning = false; // Mark timer as not running
      });
    }
  }

  void cancelCountdown() {
    stopCountdown(); // Stop the timer if it's running
    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
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
        title: Text(widget.exerciseName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Remaining Time: ${remainingTime}s',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startCountdown,
              child: const Text('Start Exercise'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: stopCountdown,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Optional: change button color
              ),
              child: const Text('Stop'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: cancelCountdown,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Optional: change button color
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
