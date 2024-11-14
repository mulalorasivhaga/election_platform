import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key
  bool _passwordVisible = false; // Password visibility flag
  String userEmail = ''; // User email
  String userPassword = ''; // User password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: const MainNavigator(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header section
              _buildHeader(),
              const SizedBox(height: 50),
              // Main login container
              _buildLoginContainer(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for header section
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: const Column(
        children: [
          Text(
            'Login',
            style: TextStyle(
              color: Color(0xFFCCA43B),
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 250.0),
            child: Text(
              "Welcome to South Africa's secure digital voting platform. To maintain election integrity and prevent duplicate voting, all citizens must authenticate their identity before casting their vote. Please log in using your registered email and password. Your participation is crucial for a democratic South Africa, and we ensure your vote remains confidential and secure through security measures.",
              style: TextStyle(
                color: Color(0xFF242F40),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for main login container
  Widget _buildLoginContainer() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildInputField(
              title: 'Email address:',
              hintText: 'Please enter your Email Address',
              icon: Icons.email,
              onChanged: (value) => setState(() => userEmail = value),
            ),
            const SizedBox(height: 40),
            _buildPasswordField(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
            const SizedBox(height: 50),
            _buildLogo(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method for input fields
  Widget _buildInputField({
    required String title,
    required String hintText,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF242F40),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: TextFormField(
            onChanged: onChanged,
            style: const TextStyle(color: Color(0xFF363636)),
            decoration: InputDecoration(
              hintText: hintText,
              icon: Icon(icon, color: const Color(0xFF363636)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF363636),
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFCCA43B),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for password field
  Widget _buildPasswordField() {
    return Column(
      children: [
        const Text(
          'Password:',
          style: TextStyle(
            color: Color(0xFF242F40),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: TextFormField(
            onChanged: (value) => setState(() => userPassword = value),
            style: const TextStyle(color: Color(0xFF363636)),
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              hintText: 'Please enter your Password',
              icon: const Icon(Icons.lock, color: Color(0xFF363636)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF363636), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF363636),
                ),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for submit button
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Add login logic
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCCA43B),
        foregroundColor: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  // Helper method for logo
  Widget _buildLogo() {
    return Image.asset(
      'assets/logo/Psystem_logo-removebg.png',
      width: 200,
      height: 200,
    );
  }
}