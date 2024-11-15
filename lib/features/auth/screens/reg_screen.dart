import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

/// This class builds the registration screen
class _RegScreenState extends State<RegScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key
  bool _passwordVisible = false; // Password visibility flag

  // Form fields
  String name = '', surname = '', email = '', idNumber = '';
  String sex = 'Male', province = 'Western Cape';
  String nationality = '', countryOfBirth = '', password = '';
  DateTime? dateOfBirth;

  // Province dropdown options
  final List<String> provinces = [
    'Western Cape', 'Eastern Cape', 'Northern Cape', 'North West',
    'Free State', 'Gauteng', 'Limpopo', 'Mpumalanga', 'KwaZulu-Natal',
  ];
  // Sex Dropdown options
  final List<String> sexOptions = ['Male', 'Female', 'Other'];

  /// This method builds the registration screen
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

  /// This method builds the header section of the registration screen
  Widget _buildHeader(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    /// This method builds the header section of the registration screen
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

  /// This method builds the registration form
  Widget _buildRegistrationForm(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double containerWidth = isMobile ? constraints.maxWidth * 0.95 : constraints.maxWidth * 0.8;

    /// This method builds the registration form container
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

  /// This method builds the logo section of the registration form
  Widget _buildLogo(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double size = isMobile ? 150 : 200;

    return Image.asset(
      'assets/logo/Psystem_logo-removebg.png',
      width: size,
      height: size,
    );
  }

  /// This method builds the form fields of the registration form
  Widget _buildFormFields(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double fieldPadding = isMobile ? 16 : 32;

    /// This method builds the form fields of the registration form
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

  /// This method builds the form fields for desktop screens
  Widget _buildDesktopFormFields(double padding) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'Name', icon: Icons.person, onChanged: (v) => setState(() => name = v))),
            SizedBox(width: padding),
            Expanded(child: _buildTextField(label: 'Surname', icon: Icons.person_outline, onChanged: (v) => setState(() => surname = v))),
          ],
        ),
        SizedBox(height: padding),
        _buildTextField(label: 'Email Address', icon: Icons.email, onChanged: (v) => setState(() => email = v)),
        SizedBox(height: padding),
        _buildPasswordField(),
        SizedBox(height: padding),
        _buildTextField(label: 'ID Number', icon: Icons.credit_card, onChanged: (v) => setState(() => idNumber = v)),
        SizedBox(height: padding),
        Row(
          children: [
            Expanded(child: _buildDropdownField(label: 'Sex', value: sex, items: sexOptions, onChanged: (v) => setState(() => sex = v!), icon: Icons.person_outline)),
            SizedBox(width: padding),
            Expanded(child: _buildDateField()),
          ],
        ),
        SizedBox(height: padding),
        _buildDropdownField(label: 'Province', value: province, items: provinces, onChanged: (v) => setState(() => province = v!), icon: Icons.location_city),
      ],
    );
  }

  /// This method builds the form fields for mobile screens
  Widget _buildMobileFormFields(double padding) {
    return Column(
      children: [
        _buildTextField(label: 'Name', icon: Icons.person, onChanged: (v) => setState(() => name = v)),
        SizedBox(height: padding),
        _buildTextField(label: 'Surname', icon: Icons.person_outline, onChanged: (v) => setState(() => surname = v)),
        SizedBox(height: padding),
        _buildTextField(label: 'Email Address', icon: Icons.email, onChanged: (v) => setState(() => email = v)),
        SizedBox(height: padding),
        _buildPasswordField(),
        SizedBox(height: padding),
        _buildTextField(label: 'ID Number', icon: Icons.credit_card, onChanged: (v) => setState(() => idNumber = v)),
        SizedBox(height: padding),
        _buildDropdownField(label: 'Sex', value: sex, items: sexOptions, onChanged: (v) => setState(() => sex = v!), icon: Icons.person_outline),
        SizedBox(height: padding),
        _buildDateField(),
        SizedBox(height: padding),
        _buildDropdownField(label: 'Province', value: province, items: provinces, onChanged: (v) => setState(() => province = v!), icon: Icons.location_city),
        SizedBox(height: padding),
        _buildTextField(label: 'Nationality', icon: Icons.flag, onChanged: (v) => setState(() => nationality = v)),
        SizedBox(height: padding),
        _buildTextField(label: 'Country of Birth', icon: Icons.public, onChanged: (v) => setState(() => countryOfBirth = v)),
      ],
    );
  }

  /// This method builds a text field
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      onChanged: onChanged,
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
      validator: (value) => value?.isEmpty ?? true ? 'Please enter $label' : null,
    );
  }

  /// This method builds a password field
  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: !_passwordVisible,
      onChanged: (value) => setState(() => password = value),
      decoration: InputDecoration(
        labelText: 'Password',
        icon: const Icon(Icons.lock, color: Color(0xFF363636)),
        suffixIcon: IconButton(
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF363636)),
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
      validator: (value) => value?.isEmpty ?? true ? 'Please enter a password' : null,
    );
  }

  /// This method builds a dropdown field
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
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  /// This method builds a date field
  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        icon: Icon(Icons.calendar_today, color: Color(0xFF363636)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF363636), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
        ),
      ),
      controller: TextEditingController(
        text: dateOfBirth?.toLocal().toString().split(' ')[0] ?? '',
      ),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) setState(() => dateOfBirth = pickedDate);
      },
      validator: (value) => dateOfBirth == null ? 'Please select your date of birth' : null,
    );
  }

  /// This method builds the submit button
  Widget _buildSubmitButton(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Add registration logic here
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCCA43B),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 32 : 50,
          vertical: isMobile ? 8 : 10,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(
        'Register',
        style: TextStyle(fontSize: isMobile ? 20 : 24),
      ),
    );
  }
}
