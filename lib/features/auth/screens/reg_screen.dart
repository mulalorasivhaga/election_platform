import 'package:flutter/material.dart';
import '../../../shared/widgets/main_navigator.dart';
import '../services/auth_service.dart';


class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _passwordVisible = false;
  bool _isLoading = false;

  // Form fields - only keep what's needed
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

// Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    // Regular expression for email validation
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
    // South African ID number is 13 digits
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
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
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
        _buildTextField(
          label: 'Email Address',
          icon: Icons.email,
          onChanged: (v) => setState(() => email = v),
          validator: _validateEmail,
        ),
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
        _buildTextField(
          label: 'Email Address',
          icon: Icons.email,
          onChanged: (v) => setState(() => email = v),
          validator: _validateEmail,
        ),
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

  /// Build dropdown field
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

  /// Handle form submission
  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final (user, message) = await _authService.registerUser(
        email: email,
        password: password,
        name: name,
        surname: surname,
        idNumber: idNumber,
        province: province,
      );

      if (mounted) {
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
