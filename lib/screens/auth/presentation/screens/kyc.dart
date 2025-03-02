// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:quickleez/screens/home/presentation/screens/navbar.dart';

// class KYCScreen extends StatefulWidget {
//   const KYCScreen({super.key});

//   @override
//   State<KYCScreen> createState() => _KYCScreenState();
// }

// class _KYCScreenState extends State<KYCScreen> {
//   late String aadhaarNumber, panNumber, addressProofPath;
//   String? aadhaarError, panError, addressProofError;

//   @override
//   void initState() {
//     super.initState();
//     aadhaarNumber = '';
//     panNumber = '';
//     addressProofPath = '';
//   }

//   void resetErrorText() {
//     setState(() {
//       aadhaarError = null;
//       panError = null;
//       addressProofError = null;
//     });
//   }

//   bool validateInputs() {
//     resetErrorText();
//     bool isValid = true;

//     // Aadhaar validation (12 digits)
//     if (aadhaarNumber.isEmpty || !RegExp(r'^\d{12}$').hasMatch(aadhaarNumber)) {
//       setState(() => aadhaarError = 'Enter a valid 12-digit Aadhaar number');
//       isValid = false;
//     }

//     // PAN validation (10 alphanumeric characters)
//     if (panNumber.isEmpty || !RegExp(r'^[A-Z]{5}\d{4}[A-Z]{1}$').hasMatch(panNumber)) {
//       setState(() => panError = 'Enter a valid PAN number');
//       isValid = false;
//     }

//     // Address proof validation (file upload)
//     if (addressProofPath.isEmpty) {
//       setState(() => addressProofError = 'Address proof document is required');
//       isValid = false;
//     }

//     return isValid;
//   }

//   Future<void> uploadDocument() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//     );

//     if (result != null) {
//       // Check file size (100KB to 10MB)
//       if (result.files.single.size < 10 * 1024 || result.files.single.size > 10 * 1024 * 1024) {
//         setState(() {
//           addressProofError = 'File size must be between 100KB and 10MB';
//         });
//       } else {
//         setState(() {
//           addressProofPath = result.files.single.path!;
//           addressProofError = null; // Clear any previous error
//         });
//       }
//     }
//   }

//   Future<void> submit() async {
//     if (!validateInputs()) return;

//     // Show loading indicator
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );

//     // Simulate KYC verification process
//     await Future.delayed(const Duration(seconds: 2));

//     // Close loading indicator
//     Navigator.pop(context);

//     // Navigate to the home screen directly
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const NavBar()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFFFD5D5), Color(0xFFFFA07A)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: ListView(
//             children: [
//               SizedBox(height: screenHeight * 0.1),
//               Image.network(
//                 'https://raw.githubusercontent.com/SnvvSuchandraEtti/quickleez/refs/heads/main/assets/logo/quickleez_1.png',
//                 height: 200,
//               ),
//               SizedBox(height: screenHeight * 0.04),
//               const Text(
//                 'Complete KYC Verification',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Verify your identity to continue',
//                 style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.6)),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: screenHeight * 0.03),
//               _buildInputField(
//                 label: 'Aadhaar Number',
//                 errorText: aadhaarError,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => setState(() => aadhaarNumber = value),
//               ),
//               SizedBox(height: screenHeight * 0.024),
//               _buildInputField(
//                 label: 'PAN Number',
//                 errorText: panError,
//                 onChanged: (value) => setState(() => panNumber = value),
//               ),
//               SizedBox(height: screenHeight * 0.024),
//               _buildDocumentUploadWidget(),
//               SizedBox(height: screenHeight * 0.025),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: submit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrange,
//                     minimumSize: const Size(double.infinity, 56),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(26),
//                     ),
//                   ),
//                   child: const Text(
//                     'Submit KYC',
//                     style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required String label,
//     String? errorText,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     TextInputAction textInputAction = TextInputAction.next,
//     required void Function(String) onChanged,
//     void Function(String)? onSubmitted,
//   }) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: label,
//         errorText: errorText,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//       ),
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       onChanged: onChanged,
//       onFieldSubmitted: onSubmitted,
//     );
//   }
//  Widget _buildDocumentUploadWidget() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Upload Address Proof',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: uploadDocument,
//           child: Container(
//             height: 48, // Reduced height compared to the submit button
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.deepOrange.shade200),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 )
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   addressProofPath.isEmpty
//                       ? Icons.cloud_upload_outlined
//                       : Icons.check_circle_outline,
//                   color: addressProofPath.isEmpty ? Colors.deepOrange : Colors.green,
//                   size: 24,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   addressProofPath.isEmpty ? 'Tap to upload document' : 'Document uploaded',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: addressProofPath.isEmpty ? Colors.deepOrange : Colors.green,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (addressProofError != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(
//               addressProofError!,
//               style: const TextStyle(color: Colors.red),
//             ),
//           ),
//       ],
//     );
//   }
// }
