import 'package:shared_preferences/shared_preferences.dart';

// Save the current logged-in user
Future<void> loginUser(Map<String, dynamic> user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('userId', user['id']); // Save the user id
  prefs.setString('username', user['username']);
}

// Get current logged-in user
Future<Map<String, dynamic>?> getLoggedInUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userId');
  String? username = prefs.getString('username');

  return {
    'id': userId,
    'username': username,
  };

  return null;
}

// Clear the current session (logout)
Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');  // Clear user id
  await prefs.remove('username');  // Clear username
}
