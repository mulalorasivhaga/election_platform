import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/providers/stream_providers.dart';
import '../utils/vote_exception.dart';
import '../../auth/models/user_model.dart' as auth;

class VotingDialog extends ConsumerStatefulWidget {
  final auth.User currentUser;
  const VotingDialog({super.key, required this.currentUser});

  @override
  ConsumerState<VotingDialog> createState() => _VotingDialogState();
}

class _VotingDialogState extends ConsumerState<VotingDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final Logger _logger = Logger();
  String? _selectedNationalCandidateId;
  String? _selectedProvincialCandidateId;
  String _selectedProvince = 'Western Cape';
  bool _isLoading = false;

  final List<String> provinces = [
    'Western Cape',
    'Eastern Cape',
    'Northern Cape',
    'North West',
    'Free State',
    'Gauteng',
    'Limpopo',
    'Mpumalanga',
    'KwaZulu-Natal'
  ];

  @override
  void initState() {
    super.initState();
    _idController.text = widget.currentUser.idNumber;
    _selectedProvince = widget.currentUser.province;
    _checkVoteStatus();
  }

  Future<void> _checkVoteStatus() async {
    try {
      final voteService = ref.read(voteServiceProvider);
      final hasVoted = await voteService.hasUserVoted(widget.currentUser.uid);
      if (hasVoted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have already cast your vote'))
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      _logger.e('Error checking vote status: $e');
    }
  }

  Future<void> _submitVote() async {
    if (!_formKey.currentState!.validate() ||
        _selectedNationalCandidateId == null ||
        _selectedProvincialCandidateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields'))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_idController.text != widget.currentUser.idNumber) {
        throw const VoteException('ID number does not match your profile');
      }

      final voteService = ref.read(voteServiceProvider);

      await voteService.castVote(
        userId: widget.currentUser.uid,
        nationalCandidateId: _selectedNationalCandidateId!,
        provincialCandidateId: _selectedProvincialCandidateId!,
        province: _selectedProvince,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vote cast successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
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
                _buildProvinceDropdown(),
                const SizedBox(height: 20),
                _buildNationalVotingSection(),
                const SizedBox(height: 20),
                _buildProvincialVotingSection(),
                const SizedBox(height: 30),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
                'Vote for both National and Provincial Elections',
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
            icon: const Icon(Icons.close, color: Color(0xFFCCA43B), size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  /// Build the ID Field
  Widget _buildIdField() {
    return TextFormField(
      controller: _idController,
      enabled: false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'ID Number',
        labelStyle: const TextStyle(color: Color(0xFFCCA43B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        filled: true,
        fillColor: const Color(0xFF2A3750),
      ),
    );
  }

  /// Build the Province Dropdown
  Widget _buildProvinceDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedProvince,
      dropdownColor: const Color(0xFF2A3750),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Voting Province',
        labelStyle: const TextStyle(color: Color(0xFFCCA43B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCCA43B)),
        ),
        filled: true,
        fillColor: const Color(0xFF2A3750),
      ),
      items: provinces.map((province) {
        return DropdownMenuItem<String>(
          value: province,
          child: Text(province),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedProvince = value);
        }
      },
    );
  }

  /// Build the National Voting Section
  Widget _buildNationalVotingSection() {
    return Consumer(
      builder: (context, ref, child) {
        final candidatesAsync = ref.watch(candidatesProvider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'National Vote',
              style: TextStyle(
                color: Color(0xFFCCA43B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            candidatesAsync.when(
              loading: () => const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCA43B)),
              ),
              error: (error, stack) => Text(
                'Error loading candidates: $error',
                style: const TextStyle(color: Colors.red),
              ),
              data: (candidates) => DropdownButtonFormField<String>(
                value: _selectedNationalCandidateId,
                dropdownColor: const Color(0xFF2A3750),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Select National Party',
                  labelStyle: const TextStyle(color: Color(0xFFCCA43B)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCA43B)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A3750),
                ),
                items: candidates.map((candidate) {
                  return DropdownMenuItem<String>(
                    value: candidate.id,
                    child: Text(candidate.partyName),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Please select a party' : null,
                onChanged: (value) {
                  setState(() => _selectedNationalCandidateId = value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build the Provincial Voting Section
  Widget _buildProvincialVotingSection() {
    return Consumer(
      builder: (context, ref, child) {
        final candidatesAsync = ref.watch(candidatesProvider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provincial Vote',
              style: TextStyle(
                color: Color(0xFFCCA43B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            candidatesAsync.when(
              loading: () => const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCA43B)),
              ),
              error: (error, stack) => Text(
                'Error loading candidates: $error',
                style: const TextStyle(color: Colors.red),
              ),
              data: (candidates) => DropdownButtonFormField<String>(
                value: _selectedProvincialCandidateId,
                dropdownColor: const Color(0xFF2A3750),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Select Provincial Party',
                  labelStyle: const TextStyle(color: Color(0xFFCCA43B)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCA43B)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A3750),
                ),
                items: candidates.map((candidate) {
                  return DropdownMenuItem<String>(
                    value: candidate.id,
                    child: Text(candidate.partyName),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Please select a party' : null,
                onChanged: (value) {
                  setState(() => _selectedProvincialCandidateId = value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build the Cancel and Submit Vote buttons
  Widget _buildButtons() {
    return Row(
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
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitVote,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCCA43B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}