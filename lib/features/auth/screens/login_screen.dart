import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
/// This is the state class for the LoginScreen widget
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key
  bool _passwordVisible = false; // Password visibility flag
  String userEmail = ''; // User email
  String userPassword = ''; // User password

  /// This method builds the LoginScreen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: const MainNavigator(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 48.0 : 16.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(constraints),
                      SizedBox(height: constraints.maxWidth > 600 ? 50 : 30),
                      _buildLoginContainer(constraints),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// This method builds the header section of the LoginScreen widget
  Widget _buildHeader(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    /// Return the header section
    return Column(
      children: [
        Text(
          'Login',
          style: TextStyle(
            color: const Color(0xFFCCA43B),
            fontSize: isMobile ? 36 : 72,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.9 : 800,
          ),
          child: Text(
            "Welcome to South Africa's secure digital voting platform. To maintain election integrity and prevent duplicate voting, all citizens must authenticate their identity before casting their vote. Please log in using your registered email and password. Your participation is crucial for a democratic South Africa, and we ensure your vote remains confidential and secure through security measures.",
            style: TextStyle(
              color: const Color(0xFF242F40),
              fontSize: isMobile ? 16 : 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// This method builds the login container section of the LoginScreen widget
  Widget _buildLoginContainer(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double containerWidth = isMobile ? constraints.maxWidth * 0.95 : 800;

    /// Return the login container section
    return Container(
      width: containerWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInputField(
            title: 'Email address:',
            hintText: 'Please enter your Email Address',
            icon: Icons.email,
            onChanged: (value) => setState(() => userEmail = value),
            constraints: constraints,
          ),
          SizedBox(height: isMobile ? 24 : 40),
          _buildPasswordField(constraints),
          SizedBox(height: isMobile ? 24 : 40),
          _buildSubmitButton(constraints),
          SizedBox(height: isMobile ? 30 : 50),
          _buildLogo(constraints),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// This method builds the input field section of the LoginScreen widget
  Widget _buildInputField({
    required String title,
    required String hintText,
    required IconData icon,
    required Function(String) onChanged,
    required BoxConstraints constraints,
  }) {
    final bool isMobile = constraints.maxWidth <= 600;

    /// Return the input field section
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF242F40),
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.85 : 600,
          ),
          child: TextFormField(
            onChanged: onChanged,
            style: const TextStyle(color: Color(0xFF363636)),
            decoration: InputDecoration(
              hintText: hintText,
              icon: Icon(icon, color: const Color(0xFF363636)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF363636), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// This method builds the password field section of the LoginScreen widget
  Widget _buildPasswordField(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return Column(
      children: [
        Text(
          'Password:',
          style: TextStyle(
            color: const Color(0xFF242F40),
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.85 : 600,
          ),
          child: TextFormField(
            onChanged: (value) => setState(() => userPassword = value),
            obscureText: !_passwordVisible,
            style: const TextStyle(color: Color(0xFF363636)),
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

  /// This method builds the submit button section of the LoginScreen widget
  Widget _buildSubmitButton(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
/// Return the submit button section
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Add login logic
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCCA43B),
        foregroundColor: const Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 32 : 50,
          vertical: isMobile ? 8 : 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        'Submit',
        style: TextStyle(fontSize: isMobile ? 20 : 24),
      ),
    );
  }

  /// This method builds the logo section of the LoginScreen widget
  Widget _buildLogo(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double size = isMobile ? 150 : 200;

    /// Return the logo section
    return Image.asset(
      'assets/logo/Psystem_logo-removebg.png',
      width: size,
      height: size,
    );
  }
}