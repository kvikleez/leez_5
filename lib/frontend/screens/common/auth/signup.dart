import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:leez/frontend/screens/common/auth/login.dart';
import 'package:leez/frontend/screens/user/home/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class SimpleRegisterScreen extends StatefulWidget {
  const SimpleRegisterScreen({super.key});

  @override
  _SimpleRegisterScreenState createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
  // Current step (0, 1, or 2 for Stepper, corresponding to 1, 2, 3 in UI)
  int _currentStep = 0; // Stepper uses 0-based indexing
  bool _isLoading = false;

  // Controllers for each step to isolate input
  // Step 1: Basic Info
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? nameError, emailError, phoneError;

  // Step 2: Account Details
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? passwordError, confirmPasswordError;

  // Step 3: KYC Details
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  String? aadhaarError, panError, addressProofError;
  String addressProofPath = '';
  File? addressProofFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _aadhaarController.dispose();
    _panController.dispose();
    super.dispose();
  }

  // ─────────────────────────────
  // Validation Methods - Same as original
  // ─────────────────────────────

  bool _validateStep1() {
    bool isValid = true;
    setState(() {
      nameError = null;
      emailError = null;
      phoneError = null;
    });
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z-A-Z]{2,}$");
    final phoneRegExp = RegExp(r"^[6-9]\d{9}$");

    if (_nameController.text.trim().isEmpty) {
      setState(() => nameError = 'Full name is required');
      isValid = false;
    }
    if (_emailController.text.trim().isEmpty || !emailRegExp.hasMatch(_emailController.text.trim())) {
      setState(() => emailError = 'Enter a valid email');
      isValid = false;
    }
    if (_phoneController.text.trim().isEmpty || !phoneRegExp.hasMatch(_phoneController.text.trim())) {
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
    if (_passwordController.text.isEmpty) {
      setState(() => passwordError = 'Password is required');
      isValid = false;
    } else if (_passwordController.text.length < 8) {
      setState(() => passwordError = 'Password must be at least 8 characters');
      isValid = false;
    }
    if (_confirmPasswordController.text.isEmpty) {
      setState(() => confirmPasswordError = 'Please confirm your password');
      isValid = false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
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
    // Aadhaar: exactly 12 digits
    if (_aadhaarController.text.isEmpty || !RegExp(r'^\d{12}$').hasMatch(_aadhaarController.text)) {
      setState(() => aadhaarError = 'Enter a valid 12-digit Aadhaar number');
      isValid = false;
    }
    // PAN: 10 alphanumeric characters in the pattern
    if (_panController.text.isEmpty || !RegExp(r'^[A-Z]{5}\d{4}[A-Z]{1}$').hasMatch(_panController.text)) {
      setState(() => panError = 'Enter a valid PAN number');
      isValid = false;
    }
    return isValid;
  }

  // ─────────────────────────────
  // Navigation: Next & Back Buttons - Same as original
  // ─────────────────────────────

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        setState(() {
          _currentStep++;
        });
      }
    } else if (_currentStep == 1) {
      if (_validateStep2()) {
        setState(() {
          _currentStep++;
        });
      }
    } else if (_currentStep == 2) {
      if (_validateStep3()) {
        _submitRegistration();
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // ─────────────────────────────
  // Skip KYC and Register User (New Method)
  // ─────────────────────────────

  Future<void> _skipKycAndRegister() async {
    setState(() {
      _isLoading = true;
    });

    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Create user with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // 2. Store basic user details in Firestore (without KYC)
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'kycCompleted': false, // Flag that KYC is not complete
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // 3. Update the user profile with display name
      await userCredential.user!.updateDisplayName(_nameController.text.trim());

      // 4. Close loading indicator
      Navigator.pop(context);
      
      // 5. Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavBar()),
      );
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'Registration failed. Please try again.';
      }
      
      // Show error alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      
      // Show generic error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An unexpected error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ─────────────────────────────
  // Firebase Registration Process - Updated for Firebase Auth
  // ─────────────────────────────

  Future<void> _submitRegistration() async {
    setState(() {
      _isLoading = true;
    });

    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Create user with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // 2. Upload address proof document to Firebase Storage (if available)
      String addressProofUrl = '';
      if (addressProofFile != null) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('users')
              .child(userCredential.user!.uid)
              .child('address_proof');
          
          await storageRef.putFile(addressProofFile!);
          addressProofUrl = await storageRef.getDownloadURL();
        } catch (uploadError) {
          // Log the error but continue with registration
          print('Document upload failed: $uploadError');
          // We don't show an error to the user or halt the registration
        }
      }
      
      // 3. Store additional user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'aadhaarNumber': _aadhaarController.text,
        'panNumber': _panController.text,
        'addressProofUrl': addressProofUrl, // Will be empty if upload failed
        'documentUploaded': addressProofFile != null, // Flag to indicate if document was provided
        'kycCompleted': true, // Flag that KYC is complete
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // 4. Update the user profile with display name
      await userCredential.user!.updateDisplayName(_nameController.text.trim());

      // 5. Close loading indicator
      Navigator.pop(context);
      
      // 6. Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavBar()),
      );
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'Registration failed. Please try again.';
      }
      
      // Show error alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading indicator
      Navigator.pop(context);
        print('DETAILED ERROR: $e'); // Add this line to log the exact error

      
      // Show generic error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An unexpected error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Modified document upload method - won't show errors that block registration
  Future<void> _uploadDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        
        // Check file size (between 50KB and 10MB) but only show informational message
        if (fileSize < 50 * 1024 || fileSize > 10 * 1024 * 1024) {
          setState(() {
            addressProofError = 'File size must be between 50KB and 10MB';
            // Don't update the file if size validation fails
          });
        } else {
          setState(() {
            addressProofPath = result.files.single.name;
            addressProofFile = file;
            addressProofError = null; // Clear any previous error
          });
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      // Show non-blocking error message
      setState(() {
        addressProofError = 'Failed to select file. You can continue registration.';
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black87),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          onChanged: (value) => setState(() {}), // Trigger rebuild to clear errors if input changes
        ),
        if (errorText != null) const SizedBox(height: 8),
      ],
    );
  }

  // ─────────────────────────────
  // Document Upload Widget (for Step 3) - Modified to indicate it's optional
  // ─────────────────────────────

  Widget _buildDocumentUploadWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Address Proof (Optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _uploadDocument,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
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
                  addressProofPath.isEmpty ? Icons.cloud_upload_outlined : Icons.check_circle_outline,
                  color: addressProofPath.isEmpty ? Colors.deepOrange : Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  addressProofPath.isEmpty ? 'Tap to upload document' : 'Document uploaded',
                  style: TextStyle(
                    fontSize: 14,
                    color: addressProofPath.isEmpty ? Colors.deepOrange : Colors.green,
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
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 4),
        const Text(
          'You can continue registration without providing this document.',
          style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  // ─────────────────────────────
  // Build Steps for Stepper
  // ─────────────────────────────

  List<Step> _buildSteps() {
    return [
      Step(
        title: const SizedBox.shrink(), // Remove default title
        content: _buildStep1(),
        isActive: _currentStep == 0,
        state: _currentStep >= 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const SizedBox.shrink(), // Remove default title
        content: _buildStep2(),
        isActive: _currentStep == 1,
        state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const SizedBox.shrink(), // Remove default title
        content: _buildStep3(),
        isActive: _currentStep == 2,
        state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  // ─────────────────────────────
  // Build Steps Content
  // ─────────────────────────────

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'Full Name',
          hintText: 'Enter your full name',
          errorText: nameError,
          controller: _nameController,
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'Email Address',
          hintText: 'Enter your email',
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'Phone Number',
          hintText: 'Enter your phone number',
          errorText: phoneError,
          keyboardType: TextInputType.phone,
          controller: _phoneController,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'Password',
          hintText: 'Enter your password',
          errorText: passwordError,
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'Confirm Password',
          hintText: 'Re-enter your password',
          errorText: confirmPasswordError,
          obscureText: true,
          controller: _confirmPasswordController,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Skip KYC Button
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: _skipKycAndRegister,
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Skip KYC',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'Aadhaar Number',
          hintText: 'Enter your 12-digit Aadhaar number',
          errorText: aadhaarError,
          keyboardType: TextInputType.number,
          controller: _aadhaarController,
        ),
        const SizedBox(height: 15),
        _buildInputField(
          label: 'PAN Number',
          hintText: 'Enter your PAN number',
          errorText: panError,
          controller: _panController,
        ),
        const SizedBox(height: 15),
        _buildDocumentUploadWidget(),
      ],
    );
  }

  // ─────────────────────────────
  // Custom Step Indicator
  // ─────────────────────────────

  Widget _buildCustomStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentStep == index
                ? Colors.black
                : Colors.grey.shade300, // Unfilled circle for inactive steps
          ),
        );
      }),
    );
  }

  // ─────────────────────────────
  // Main Build Method
  // ─────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Pinkish background as in the image
      body: SafeArea(
        child: Padding(
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
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Custom Step Indicator
              _buildCustomStepIndicator(),
              const SizedBox(height: 20),
              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_currentStep == 0) _buildStep1(),
                      if (_currentStep == 1) _buildStep2(),
                      if (_currentStep == 2) _buildStep3(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Navigation Buttons (Back & Next/Submit)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                      onPressed: _onStepCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                  ElevatedButton(
                    onPressed: _onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep == 2 ? 'Submit' : 'Next',
                      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
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
                        MaterialPageRoute(builder: (_) => const SimpleLoginScreen()),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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