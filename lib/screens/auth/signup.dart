import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:leez/screens/auth/login.dart';
import 'package:leez/screens/user/home/homescreen.dart';



class SimpleRegisterScreen extends StatefulWidget {
  const SimpleRegisterScreen({super.key});

  @override
  _SimpleRegisterScreenState createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
  // Current step (1, 2, or 3)
  int _currentStep = 1;

  // ----- Step 1: Basic Info -----
  late String name, email, phone;
  String? nameError, emailError, phoneError;

  // ----- Step 2: Account Details -----
  late String password, confirmPassword;
  String? passwordError, confirmPasswordError;

  // ----- Step 3: KYC Details -----
  late String aadhaarNumber, panNumber, addressProofPath;
  String? aadhaarError, panError, addressProofError;

  @override
  void initState() {
    super.initState();
    // Initialize Step 1 fields
    name = '';
    email = '';
    phone = '';

    // Initialize Step 2 fields
    password = '';
    confirmPassword = '';

    // Initialize Step 3 fields
    aadhaarNumber = '';
    panNumber = '';
    addressProofPath = '';
  }

  // ─────────────────────────────
  // Validation Methods
  // ─────────────────────────────

  bool _validateStep1() {
    bool isValid = true;
    setState(() {
      nameError = null;
      emailError = null;
      phoneError = null;
    });
    final emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    final phoneRegExp = RegExp(r"^[6-9]\d{9}$");

    if (name.trim().isEmpty) {
      setState(() => nameError = 'Full name is required');
      isValid = false;
    }
    if (email.trim().isEmpty || !emailRegExp.hasMatch(email.trim())) {
      setState(() => emailError = 'Enter a valid email');
      isValid = false;
    }
    if (phone.trim().isEmpty || !phoneRegExp.hasMatch(phone.trim())) {
      setState(() => phoneError = 'Enter a valid phone number');
      isValid = false;
    }
    return isValid;
  }

  bool _validateStep2() {
    bool isValid = true;
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
    });
    if (password.isEmpty) {
      setState(() => passwordError = 'Password is required');
      isValid = false;
    } else if (password.length < 8) {
      setState(() => passwordError = 'Password must be at least 8 characters');
      isValid = false;
    }
    if (confirmPassword.isEmpty) {
      setState(() => confirmPasswordError = 'Please confirm your password');
      isValid = false;
    } else if (password != confirmPassword) {
      setState(() => confirmPasswordError = 'Passwords do not match');
      isValid = false;
    }
    return isValid;
  }

  bool _validateStep3() {
    bool isValid = true;
    setState(() {
      aadhaarError = null;
      panError = null;
      addressProofError = null;
    });
    // Aadhaar: exactly 12 digits.
    if (aadhaarNumber.isEmpty || !RegExp(r'^\d{12}$').hasMatch(aadhaarNumber)) {
      setState(() => aadhaarError = 'Enter a valid 12-digit Aadhaar number');
      isValid = false;
    }
    // PAN: 10 alphanumeric characters in the pattern.
    if (panNumber.isEmpty ||
        !RegExp(r'^[A-Z]{5}\d{4}[A-Z]{1}$').hasMatch(panNumber)) {
      setState(() => panError = 'Enter a valid PAN number');
      isValid = false;
    }
    if (addressProofPath.isEmpty) {
      setState(() => addressProofError = 'Address proof document is required');
      isValid = false;
    }
    return isValid;
  }

  // ─────────────────────────────
  // Navigation: Next & Back Buttons
  // ─────────────────────────────

  void _onNextPressed() {
    if (_currentStep == 1) {
      if (_validateStep1()) {
        setState(() {
          _currentStep = 2;
        });
      }
    } else if (_currentStep == 2) {
      if (_validateStep2()) {
        setState(() {
          _currentStep = 3;
        });
      }
    } else if (_currentStep == 3) {
      if (_validateStep3()) {
        _submitRegistration();
      }
    }
  }

  void _onBackPressed() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // ─────────────────────────────
  // Submission: Final Step (Step 3)
  // ─────────────────────────────

  Future<void> _submitRegistration() async {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator()),
    );
    // Simulate processing (e.g., API call)
    await Future.delayed(const Duration(seconds: 2));
    // Close loading indicator
    Navigator.pop(context);
    // Navigate to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  // ─────────────────────────────
  // File Upload for Address Proof (Step 3)
  // ─────────────────────────────

  Future<void> _uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      // Optionally, check file size (e.g., between 100KB and 10MB)
      if (result.files.single.size < 50 * 1024 ||
          result.files.single.size > 10 * 1024 * 1024) {
        setState(() {
          addressProofError = 'File size must be between 50KB and 10MB';
        });
      } else {
        setState(() {
          addressProofPath = result.files.single.path ?? '';
          addressProofError = null; // Clear any previous error
        });
      }
    }
  }

  // ─────────────────────────────
  // UI: Step Indicator Widget
  // ─────────────────────────────

  Widget _buildStepIndicator() {
    // Three steps: 1, 2, and 3.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1),
        _buildStepLine(),
        _buildStepCircle(2),
        _buildStepLine(),
        _buildStepCircle(3),
      ],
    );
  }

  Widget _buildStepCircle(int stepNumber) {
    bool isActive = _currentStep >= stepNumber;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(color: isActive ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.grey.shade300,
    );
  }

  // ─────────────────────────────
  // Input Field Widget
  // ─────────────────────────────

  Widget _buildInputField({
    required String label,
    required String hintText,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ─────────────────────────────
  // Document Upload Widget (for Step 3)
  // ─────────────────────────────

  Widget _buildDocumentUploadWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Address Proof',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _uploadDocument,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepOrange.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  addressProofPath.isEmpty
                      ? Icons.cloud_upload_outlined
                      : Icons.check_circle_outline,
                  color: addressProofPath.isEmpty
                      ? Colors.deepOrange
                      : Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  addressProofPath.isEmpty
                      ? 'Tap to upload document'
                      : 'Document uploaded',
                  style: TextStyle(
                    fontSize: 14,
                    color: addressProofPath.isEmpty
                        ? Colors.deepOrange
                        : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (addressProofError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              addressProofError!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────
  // Build Step 1: Basic Info
  // ─────────────────────────────

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'Full Name',
          hintText: 'Enter your full name',
          errorText: nameError,
          onChanged: (value) => setState(() => name = value),
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'Email Address',
          hintText: 'Enter your email',
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => setState(() => email = value),
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'Phone Number',
          hintText: 'Enter your phone number',
          errorText: phoneError,
          keyboardType: TextInputType.phone,
          onChanged: (value) => setState(() => phone = value),
        ),
      ],
    );
  }

  // ─────────────────────────────
  // Build Step 2: Account Details
  // ─────────────────────────────

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'Password',
          hintText: 'Enter your password',
          errorText: passwordError,
          obscureText: true,
          onChanged: (value) => setState(() => password = value),
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'Confirm Password',
          hintText: 'Re-enter your password',
          errorText: confirmPasswordError,
          obscureText: true,
          onChanged: (value) => setState(() => confirmPassword = value),
        ),
      ],
    );
  }

  // ─────────────────────────────
  // Build Step 3: KYC Details
  // ─────────────────────────────

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'Aadhaar Number',
          hintText: 'Enter your 12-digit Aadhaar number',
          errorText: aadhaarError,
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() => aadhaarNumber = value),
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'PAN Number',
          hintText: 'Enter your PAN number',
          errorText: panError,
          onChanged: (value) => setState(() => panNumber = value),
        ),
        const SizedBox(height: 15),
        _buildDocumentUploadWidget(),
      ],
    );
  }

  // ─────────────────────────────
  // Main Build Method
  // ─────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo & Title
              Text(
                'leez',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Step Indicator
              _buildStepIndicator(),
              const SizedBox(height: 20),
              // Show form content based on current step
              if (_currentStep == 1) _buildStep1(),
              if (_currentStep == 2) _buildStep2(),
              if (_currentStep == 3) _buildStep3(),
              const SizedBox(height: 30),
              // Navigation Buttons (Back & Next/Submit)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 1)
                    ElevatedButton(
                      onPressed: _onBackPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Submit' : 'Next',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sign In Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SimpleLoginScreen()),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
