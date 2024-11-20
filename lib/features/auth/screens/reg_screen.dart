import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/main_navigator.dart';
import 'package:election_platform/shared/services/auth_services.dart';
import '../services/email_verification_service.dart';
import 'package:logger/logger.dart';
import '../../../shared/providers/service_providers.dart';


class RegScreen extends ConsumerStatefulWidget {
  const RegScreen({super.key});

  @override
  ConsumerState<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends ConsumerState<RegScreen> {

  // Initialize services and controllers
  final _formKey = GlobalKey<FormState>();
  late final AuthService _authService;
  final _emailVerificationService = EmailVerificationService();

  // Logger
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    // Initialize AuthService using the provider
    _authService = ref.read(authServiceProvider);
  }

// State variables
  bool _passwordVisible = false;
  bool _isLoading = false;
  bool _isEmailVerified = false;
  bool _isVerifyingEmail = false;

  // Form fields
  String name = '';
  String surname = '';
  String email = '';
  String idNumber = '';
  String province = 'Western Cape';
  String password = '';

  // Province list
  final List<String> provinces = [
    'Western Cape',
    'Eastern Cape',
    'Northern Cape',
    'North West',
    'Free State',
    'Gauteng',
    'Limpopo',
    'Mpumalanga',
    'KwaZulu-Natal',
  ];


  @override
  void dispose() {
    _logger.d('Disposing RegScreen');
    super.dispose();
  }

// Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

// ID Number validation
  String? _validateIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an ID number';
    }
    final idRegex = RegExp(r'^\d{13}$');
    if (!idRegex.hasMatch(value)) {
      return 'Please enter a valid 13-digit ID number';
    }
    return null;
  }

// Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Verify email address
  Future<void> _verifyEmail() async {
    if (email.isEmpty) return;

    setState(() => _isVerifyingEmail = true);
    _logger.i('Starting email verification for: $email');

    try {
      final (isValid, message) = await _emailVerificationService.verifyEmail(email);
      _logger.i('Email verification response: Valid: $isValid, Message: $message');

      setState(() {
        _isEmailVerified = isValid;
        _isVerifyingEmail = false;
      });  if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isValid ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e, stackTrace) {
      _logger.e('Email verification failed', error: e, stackTrace: stackTrace);
      setState(() => _isVerifyingEmail = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to verify email. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  // Registration handler
  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      _logger.w('Form validation failed');
      return;
    }

    if (!_isEmailVerified) {
      _logger.w('Attempted registration with unverified email');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your email first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    _logger.i('Starting registration process for user: $email');

    try {
      final (user, message) = await _authService.registerUser(
        email: email,
        password: password,
        name: name,
        surname: surname,
        idNumber: idNumber,
        province: province,
      );

      _logger.i('Registration response: User: ${user?.uid}, Message: $message');

      if (mounted) {
        if (user != null) {
          _logger.i('Registration successful for user: ${user.uid}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _logger.w('Registration failed: $message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Registration error', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
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

      /// Handle form submission
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
                      _buildRegistrationForm(constraints),
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

  /// Build header
  Widget _buildHeader(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return Column(
      children: [
        Text(
          'Register',
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
            "Welcome to South Africa's digital future. To ensure election integrity and security, please provide accurate personal information for voter verification. Your details will be protected and used solely for electoral purposes.",
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

  /// Build registration form
  Widget _buildRegistrationForm(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double containerWidth =
        isMobile ? constraints.maxWidth * 0.95 : constraints.maxWidth * 0.8;

    return Container(
      width: containerWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildFormFields(constraints),
          const SizedBox(height: 50),
          _buildLogo(constraints),
        ],
      ),
    );
  }

  /// Build logo
  Widget _buildLogo(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double size = isMobile ? 150 : 200;

    return Image.asset(
      'assets/logo/Psystem_logo-removebg.png',
      width: size,
      height: size,
    );
  }

  /// Build form fields
  Widget _buildFormFields(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double fieldPadding = isMobile ? 16 : 32;

    return Column(
      children: [
        if (!isMobile)
          _buildDesktopFormFields(fieldPadding)
        else
          _buildMobileFormFields(fieldPadding),
        SizedBox(height: isMobile ? 24 : 40),
        _buildSubmitButton(constraints),
      ],
    );
  }

  /// Build form fields for desktop
  Widget _buildDesktopFormFields(double padding) {
    return Column(
      children: [
        // Name and Surname row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Name',
                icon: Icons.person,
                onChanged: (v) => setState(() => name = v),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
            ),
            SizedBox(width: padding),
            Expanded(
              child: _buildTextField(
                label: 'Surname',
                icon: Icons.person_outline,
                onChanged: (v) => setState(() => surname = v),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your surname' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: padding),
        // Email
        _buildEmailField(),
        SizedBox(height: padding),
        // ID Number
        _buildTextField(
          label: 'ID Number',
          icon: Icons.credit_card,
          onChanged: (v) => setState(() => idNumber = v),
          validator: _validateIdNumber,
        ),
        SizedBox(height: padding),
        // Province
        _buildDropdownField(
          label: 'Province',
          value: province,
          items: provinces,
          onChanged: (v) => setState(() => province = v!),
          icon: Icons.location_city,
        ),
        SizedBox(height: padding),
        // Password
        _buildPasswordField(),
      ],
    );
  }

  /// Build form fields for mobile
  Widget _buildMobileFormFields(double padding) {
    return Column(
      children: [
        _buildTextField(
          label: 'Name',
          icon: Icons.person,
          onChanged: (v) => setState(() => name = v),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        SizedBox(height: padding),
        _buildTextField(
          label: 'Surname',
          icon: Icons.person_outline,
          onChanged: (v) => setState(() => surname = v),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your surname' : null,
        ),
        SizedBox(height: padding),
        _buildEmailField(),
        SizedBox(height: padding),
        _buildTextField(
          label: 'ID Number',
          icon: Icons.credit_card,
          onChanged: (v) => setState(() => idNumber = v),
          validator: _validateIdNumber,
        ),
        SizedBox(height: padding),
        _buildDropdownField(
          label: 'Province',
          value: province,
          items: provinces,
          onChanged: (v) => setState(() => province = v!),
          icon: Icons.location_city,
        ),
        SizedBox(height: padding),
        _buildPasswordField(),
      ],
    );
  }

  /// Build text field
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator ??
          (value) => value?.isEmpty ?? true ? 'Please enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon, color: const Color(0xFF363636)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF363636), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
        ),
      ),
    );
  }

  /// Build email field with verification button
  Widget _buildEmailField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (v) => setState(() {
              email = v;
              _isEmailVerified = false;
            }),
            validator: _validateEmail,
            decoration: InputDecoration(
              labelText: 'Email Address',
              icon: const Icon(Icons.email, color: Color(0xFF363636)),
              suffixIcon: _isEmailVerified
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
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
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: (email.isEmpty || _isVerifyingEmail) ? null : _verifyEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCA43B),
            foregroundColor: Colors.white,
          ),
          child: _isVerifyingEmail
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text('Verify'),
        ),
      ],
    );
  }

  /// Build password field
  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: !_passwordVisible,
      onChanged: (value) => setState(() => password = value),
      validator: _validatePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        icon: const Icon(Icons.lock, color: Color(0xFF363636)),
        suffixIcon: IconButton(
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF363636)),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF363636), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
        ),
      ),
    );
  }

  /// Build dropdown field for provinces
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon, color: const Color(0xFF363636)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF363636), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
        ),
      ),
      dropdownColor: const Color(0xFFE5E5E5),
      style: const TextStyle(color: Color(0xFF363636)),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  /// Build submit button
  Widget _buildSubmitButton(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return ElevatedButton(
      onPressed: _isLoading ? null : _handleRegistration,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCCA43B),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 32 : 50,
          vertical: isMobile ? 8 : 10,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
              'Register',
              style: TextStyle(fontSize: isMobile ? 20 : 24),
            ),
    );
  }

}
