import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/workout_database.dart';
import '../models/workout.dart';
import 'home.dart';


class CreateWorkoutScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const CreateWorkoutScreen({super.key, required this.user});

  @override
  CreateWorkoutScreenState createState() => CreateWorkoutScreenState();
}

class CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final WorkoutDatabase _dbHelper = WorkoutDatabase();
  String? _name;
  String? _description;
  String _selectedCategory = 'Cardio'; // Default category

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
            );
          },
        ),
        title: Text(
          'Create Workout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  labelStyle: TextStyle(color: Colors.green),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onSaved: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.green),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 20),
              Text(
                'Category',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton('Cardio', FontAwesomeIcons.personRunning),
                  _buildCategoryButton('Strength', FontAwesomeIcons.dumbbell),
                  _buildCategoryButton('Flexibility', FontAwesomeIcons.child),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        final workout = Workout(
                          name: _name!,
                          description: _description,
                          category: _selectedCategory, // Include selected category
                          exercises: [], // Add any exercises if needed
                        );

                        await _dbHelper.insertWorkout(workout);
                        Navigator.pop(context, workout); // Return the created workout to the previous screen
                      } catch (e) {
                        print('Error inserting workout: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving workout: $e')),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Create Workout',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label, IconData icon) {
    final bool isSelected = _selectedCategory == label;
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.green[700],
      ),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.green[700],
        ),
      ),
      onPressed: () => _selectCategory(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green[700] : Colors.green[100],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
