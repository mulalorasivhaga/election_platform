import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:election_platform/shared/services/auth_services.dart';
import '../../../shared/providers/service_providers.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthService _authService;

  /// Logger instance
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  /// This method initializes the AuthService
  @override
  void initState() {
    super.initState();
    // Initialize AuthService using the provider
    _authService = ref.read(authServiceProvider);
  }

  @override
  void dispose() {
    _logger.d('Disposing LoginScreen');
    super.dispose();
  }

// variables
  bool _passwordVisible = false;
  bool _isLoading = false;
  String userEmail = '';
  String userPassword = '';

  /// This method validates the email address
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      _logger.w('Email validation failed: Empty email');
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      _logger.w('Email validation failed: Invalid format - $value');
      return 'Please enter a valid email address';
    }
    _logger.d('Email validation passed: $value');
    return null;
  }

  /// This method validates the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      _logger.w('Password validation failed: Empty password');
      return 'Please enter your password';
    }
    if (value.length < 6) {
      _logger.w('Password validation failed: Too short');
      return 'Password must be at least 6 characters';
    }
    _logger.d('Password validation passed');
    return null;
  }


  /// This method handles the login process
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      _logger.w('Form validation failed');
      return;
    }

    setState(() => _isLoading = true);
    _logger.i('Starting login process for user: $userEmail');

    try {
      final (user, message) = await _authService.loginUser(
        email: userEmail,
        password: userPassword,
      );

      _logger.i('Login response: User: ${user?.uid}, Message: $message');

      if (mounted) {
        if (user != null) {
          _logger.i('Login successful for user: ${user.uid}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/users');
        } else {
          _logger.w('Login failed: $message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Login error', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
            validator: _validateEmail,  // Add the validator here
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
    String? Function(String?)? validator,
  }) {
    final bool isMobile = constraints.maxWidth <= 600;

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
            validator: validator,
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
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
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
            validator: _validatePassword,
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
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
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

    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCCA43B),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 32 : 50,
          vertical: isMobile ? 8 : 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : Text(
        'Login',
        style: TextStyle(fontSize: isMobile ? 20 : 24),
      ),
    );
  }
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
