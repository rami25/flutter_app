import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _cardIdController = TextEditingController();

  DateTime? _cardDate;

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  void _pickCardDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      setState(() {
        _cardDate = picked;
      });
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final userName = _userNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final cardId = int.tryParse(_cardIdController.text.trim());
      final cardDate = _cardDate;

      // TODO: Send this data to your backend or process it
      // print('Username: $userName');
      // print('Email: $email');
      // print('Password: $password');
      // print('Card ID: $cardId');
      // print('Card Date: $cardDate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.person_add_alt_1, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),

              // Username
              TextFormField(
                controller: _userNameController,
                decoration: _inputDecoration('Username', Icons.person_outline),
                validator: (value) => value!.isEmpty ? 'Enter your username' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email', Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration('Password', Icons.lock_outline).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (value) => value!.length < 6 ? 'Minimum 6 characters' : null,
              ),
              const SizedBox(height: 16),

              // Confirm password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmVisible,
                decoration:
                    _inputDecoration('Confirm Password', Icons.lock_outline).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _isConfirmVisible = !_isConfirmVisible),
                  ),
                ),
                validator: (value) =>
                    value != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 16),

              // Card ID
              TextFormField(
                controller: _cardIdController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Card ID', Icons.credit_card),
                validator: (value) =>
                    int.tryParse(value!) == null ? 'Enter a valid number' : null,
              ),
              const SizedBox(height: 16),

              // Card Date
              ListTile(
                title: Text(
                  _cardDate != null
                      ? DateFormat.yMMMd().format(_cardDate!)
                      : 'Select Card Date',
                  style: TextStyle(
                    color: _cardDate != null ? Colors.black : Colors.grey[600],
                  ),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickCardDate,
              ),
              const SizedBox(height: 30),

              // Sign Up button
              ElevatedButton(
                onPressed: _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18, color : Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
