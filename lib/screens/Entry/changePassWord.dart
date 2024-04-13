import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // May be needed if using REST API

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  // Text controllers for input fields
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureTextCurrent = true;
  bool _obscureTextNew = true;
  bool _obscureTextConfirm = true;

  void _togglePasswordVisibilityCurrent() {
    setState(() {
      _obscureTextCurrent = !_obscureTextCurrent;
    });
  }

  void _togglePasswordVisibilityNew() {
    setState(() {
      _obscureTextNew = !_obscureTextNew;
    });
  }

  void _togglePasswordVisibilityConfirm() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Password")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // add show password icon
              TextFormField(
                obscureText: _obscureTextCurrent,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextCurrent
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibilityCurrent,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureTextNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextNew ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibilityNew,
                  ),
                ),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureTextConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibilityConfirm,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _updatePassword,
                    child: Text(
                      "Update Password",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // background color of button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // rounded edges
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      // Validate the form
      if (_newPasswordController.text == _confirmPasswordController.text) {
        // Passwords match
        // Send a request to the server to update the password
        final response = await http.post(
          Uri.parse('http://10.0.2.2:4400/api/user/changePassword'),
          body: {
            'oldPassword': _currentPasswordController.text,
            'newPassword': _newPasswordController.text,
          },
        );

        if (response.statusCode == 200) {
          // Password updated successfully
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password updated successfully')));
        } else {
          // Password update failed
          // Show an error message
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update password')));
        }
      } else {
        // Passwords do not match
        // Show an error message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Passwords do not match')));
      }
    }
  }
}
