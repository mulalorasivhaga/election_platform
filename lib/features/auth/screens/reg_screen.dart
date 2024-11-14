import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  // Form fields
  String name = '';
  String surname = '';
  String email = '';
  String idNumber = '';
  String sex = 'Male'; // Default value
  DateTime? dateOfBirth;
  String province = 'Western Cape'; // Default value
  String nationality = '';
  String countryOfBirth = '';
  String password = '';

  // List of SA provinces
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

  // List of sex options
  final List<String> sexOptions = ['Male', 'Female', 'Other'];

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
              Container(
                padding: const EdgeInsets.only(top: 50),
                child: const Column(
                  children: [
                    Text(
                      'Register',
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
                        "Welcome to South Africa's digital future. To ensure election integrity and security, please provide accurate personal information for voter verification. Your details will be protected and used solely for electoral purposes.",
                        style: TextStyle(
                          color: Color(0xFF242F40),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Logo
                    Image.asset(
                      'assets/logo/Psystem_logo-removebg.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    /// Name and Surname Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Name',
                            onChanged: (value)
                            {
                              setState(() {
                                name = value;
                              });
                              },
                            icon: Icons.person,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            label: 'Surname',
                            onChanged: (value)
                            {
                              setState(() {
                                surname = value;
                              });
                            },
                            icon: Icons.person_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Email
                    _buildTextField(
                      label: 'Email Address',
                      onChanged: (value)
                      {
                        setState(() {
                          email = value;
                        });
                      },
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 20),

                    /// Password
                    _buildPasswordField(),
                    const SizedBox(height: 20),

                    /// ID Number
                    _buildTextField(
                      label: 'ID Number',
                      onChanged: (value)
                      {
                        setState(() {
                          idNumber = value;
                        });
                      },
                      icon: Icons.credit_card,
                    ),
                    const SizedBox(height: 20),

                    /// Sex and Date of Birth Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Sex',
                            value: sex,
                            items: sexOptions,
                            onChanged: (value)
                            {
                              setState(() {
                                sex = value!;
                              });
                            },
                            icon: Icons.person_outline,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildDateField(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Province
                    _buildDropdownField(
                      label: 'Province',
                      value: province,
                      items: provinces,
                      onChanged: (value)
                      {
                        setState(() {
                          province = value!;
                        });
                      },
                      icon: Icons.location_city,
                    ),
                    const SizedBox(height: 20),

                    /// Nationality and Country of Birth Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Nationality',
                            onChanged: (value)
                            {
                              setState(() {
                                nationality = value;
                              });
                            },
                            icon: Icons.flag,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            label: 'Country of Birth',
                            onChanged: (value)
                            {
                              setState(() {
                                countryOfBirth = value;
                              });
                            },
                            icon: Icons.public,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    /// Register Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Add registration logic here
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
                        'Register',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build text fields
  /// This method is used to build text fields templates for more efficient code
  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  /// Helper method to build password field
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: TextFormField(
        obscureText: !_passwordVisible,
        onChanged: (value)
        {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Password',
          icon: const Icon(Icons.lock, color: Color(0xFF363636)),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF363636),
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          }
          return null;
        },
      ),
    );
  }

  /// Helper method to build dropdown fields
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
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
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  // Helper method to build date field
  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: TextFormField(
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
          icon: Icon(Icons.calendar_today, color: Color(0xFF363636)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF363636),
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFCCA43B),
              width: 2,
            ),
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
          if (pickedDate != null) {
            setState(() {
              dateOfBirth = pickedDate;
            });
          }
        },
        validator: (value) {
          if (dateOfBirth == null) {
            return 'Please select your date of birth';
          }
          return null;
        },
      ),
    );
  }
}
