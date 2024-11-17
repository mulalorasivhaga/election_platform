import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VotingDialog extends StatefulWidget {
  const VotingDialog({super.key});

  @override
  State<VotingDialog> createState() => _VotingDialogState();
}

class _VotingDialogState extends State<VotingDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  String? _selectedCandidate;
  String? _selectedProvince;
  bool _isLoading = false;

  // Sample data
  final List<String> _candidates = [
    'Candidate 1',
    'Candidate 2',
    'Candidate 3',
    'Candidate 4',
  ];

  final List<String> _provinces = [
    'Eastern Cape',
    'Free State',
    'Gauteng',
    'KwaZulu-Natal',
    'Limpopo',
    'Mpumalanga',
    'Northern Cape',
    'North West',
    'Western Cape',
  ];

  /// This method builds the header section
  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 16, bottom: 0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Cast Your Vote',
                style: TextStyle(
                  color: Color(0xFFCCA43B),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Please fill in all required fields',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 0,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Color(0xFFCCA43B),
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  /// This method builds the ID input field
  Widget _buildIdField() {
    return TextFormField(
      controller: _idController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'ID Number',
        labelStyle: const TextStyle(color: Color(0xFFCCA43B)),
        hintText: 'Enter your 13-digit ID number',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B), width: 2),
        ),
        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFCCA43B)),
        filled: true,
        fillColor: const Color(0xFF2A3750),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ID number';
        }
        if (value.length != 13) {
          return 'ID number must be 13 digits';
        }
        return null;
      },
    );
  }

  /// This method builds the candidate dropdown
  Widget _buildCandidateDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCandidate,
      dropdownColor: const Color(0xFF2A3750),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Select Candidate',
        labelStyle: const TextStyle(color: Color(0xFFCCA43B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B), width: 2),
        ),
        prefixIcon: const Icon(Icons.how_to_vote_outlined, color: Color(0xFFCCA43B)),
        filled: true,
        fillColor: const Color(0xFF2A3750),
      ),
      items: _candidates.map((String candidate) {
        return DropdownMenuItem<String>(
          value: candidate,
          child: Text(candidate),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select a candidate' : null,
      onChanged: (String? newValue) {
        setState(() {
          _selectedCandidate = newValue;
        });
      },
    );
  }

  /// This method builds the province dropdown
  Widget _buildProvinceDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedProvince,
      dropdownColor: const Color(0xFF2A3750),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Select Province',
        labelStyle: const TextStyle(color: Color(0xFFCCA43B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B), width: 2),
        ),
        prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFFCCA43B)),
        filled: true,
        fillColor: const Color(0xFF2A3750),
      ),
      items: _provinces.map((String province) {
        return DropdownMenuItem<String>(
          value: province,
          child: Text(province),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select a province' : null,
      onChanged: (String? newValue) {
        setState(() {
          _selectedProvince = newValue;
        });
      },
    );
  }

  /// This method builds the submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
          if (_formKey.currentState!.validate()) {
            setState(() => _isLoading = true);
            try {
              // TODO: Implement vote submission logic

              // Show success message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vote submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop(true); // Return success
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error submitting vote: $e'),
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
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCCA43B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Submit Vote',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// This method builds the voting form
  Widget _buildVotingForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              color: Color(0xFFCCA43B),
              thickness: 2,
            ),
            const SizedBox(height: 20),
            _buildIdField(),
            const SizedBox(height: 20),
            _buildCandidateDropdown(),
            const SizedBox(height: 20),
            _buildProvinceDropdown(),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSubmitButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242F40),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildVotingForm(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}