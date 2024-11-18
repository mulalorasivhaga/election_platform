import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import '../../home/models/candidate_model.dart';
import '../../home/services/candidate_service.dart';
import '../services/vote_service.dart';
import '../utils/vote_exception.dart';
import '../../auth/models/user.dart' as auth;

class VotingDialog extends StatefulWidget {
  final auth.User currentUser;

  const VotingDialog({super.key, required this.currentUser});

  @override
  State<VotingDialog> createState() => _VotingDialogState();
}

class _VotingDialogState extends State<VotingDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final VoteService _voteService = VoteService();
  final CandidateService _candidateService = CandidateService();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  String? _selectedCandidateId;
  bool _isLoading = false;
  List<Candidate> _candidates = [];

  @override
  void initState() {
    super.initState();
    _idController.text = widget.currentUser.idNumber;
    _checkVoteStatus();
  }

  Future<void> _checkVoteStatus() async {
    try {
      final hasVoted = await _voteService.hasUserVoted(widget.currentUser.uid);
      if (hasVoted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have already cast your vote')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      _logger.e('Error checking vote status: $e');
    }
  }

  Future<void> _submitVote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_idController.text != widget.currentUser.idNumber) {
        throw const VoteException('ID number does not match your profile');
      }

      final result = await _voteService.castVote(
        userId: widget.currentUser.uid,
        saId: _idController.text,
        candidateId: _selectedCandidateId!,
      );

      if (result == 'Vote recorded successfully' && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vote cast successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw VoteException(result);
      }
    } on VoteException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  /// This method builds the voting form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242F40),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildIdField(),
                const SizedBox(height: 20),
                _buildCandidateDropdown(),
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
        ),
      ),
    );
  }

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
        hintText: 'Enter your 13-digit South African ID number',
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
    return StreamBuilder<List<Candidate>>(
      stream: _candidateService.getCandidates(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          _logger.e('Error loading candidates: ${snapshot.error}');
          return const Text('Error loading candidates',
              style: TextStyle(color: Colors.white));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCA43B)),
          );
        }

        _candidates = snapshot.data ?? [];

        return DropdownButtonFormField<String>(
          value: _selectedCandidateId,
          dropdownColor: const Color(0xFF2A3750),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Select Party',
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
            prefixIcon: const Icon(Icons.how_to_vote_outlined,
                color: Color(0xFFCCA43B)),
            filled: true,
            fillColor: const Color(0xFF2A3750),
          ),
          items: _candidates.map((candidate) {
            return DropdownMenuItem<String>(
              value: candidate.id,
              // Display party name in dropdown
              child: Text(candidate.partyName,
                  style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          validator: (value) => value == null ? 'Please select a party' : null,
          onChanged: (String? newValue) {
            setState(() {
              _selectedCandidateId = newValue;
            });
          },
        );
      },
    );
  }

  /// This method builds the submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitVote,
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

  /// This method disposes the controller
  @override
  void dispose() {
    _logger.i('🔚 Disposing voting dialog');
    _idController.dispose();
    super.dispose();
  }
}
