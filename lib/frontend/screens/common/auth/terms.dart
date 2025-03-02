// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class TermsAndConditionsScreen extends StatelessWidget {
//   const TermsAndConditionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Terms and Conditions',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: const Color(0xFF2511D6),
//         elevation: 8,
//         shadowColor: Colors.black.withOpacity(0.3),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFFDFDFD), Color(0xFFEFEFF1)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: screenSize.width * 0.04,
//               vertical: screenSize.height * 0.02),
//           child: Column(
//             children: [
//               _buildHeader(screenSize),
//               Expanded(
//                 child: ListView.separated(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(
//                       top: screenSize.height * 0.02,
//                       bottom: screenSize.height * 0.05),
//                   separatorBuilder: (_, __) =>
//                       SizedBox(height: screenSize.height * 0.03),
//                   itemCount: sections.length,
//                   itemBuilder: (context, index) =>
//                       _buildSection(sections[index], screenSize),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(Size screenSize) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: const Color(0xFF2511D6).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.info_outline,
//                   color: const Color(0xFF2511D6), size: screenSize.width * 0.06),
//               SizedBox(width: screenSize.width * 0.03),
//               Expanded(
//                 child: Text(
//                   'Please read these terms carefully before using our services',
//                   style: TextStyle(
//                     fontSize: screenSize.width * 0.038,
//                     color: const Color(0xFF2511D6),
//                     fontWeight: FontWeight.w600,
//                   )),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: screenSize.height * 0.02),
//       ],
//     );
//   }

//   Widget _buildSection(Map<String, String> section, Size screenSize) {
//     return Material(
//       borderRadius: BorderRadius.circular(20),
//       elevation: 1.5,
//       color: Colors.white,
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(screenSize.width * 0.04),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.grey.withOpacity(0.1)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2511D6).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(_getSectionIcon(section['title']!),
//                       color: const Color(0xFF2511D6),
//                       size: screenSize.width * 0.055),
//                 ),
//                 SizedBox(width: screenSize.width * 0.03),
//                 Expanded(
//                   child: Text(
//                     section['title']!,
//                     style: TextStyle(
//                       fontSize: screenSize.width * 0.045,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF2511D6),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: screenSize.height * 0.015),
//             Padding(
//               padding: EdgeInsets.only(left: screenSize.width * 0.1),
//               child: Text(
//                 section['content']!,
//                 style: TextStyle(
//                   fontSize: screenSize.width * 0.038,
//                   color: Colors.grey[850],
//                   height: 1.6,
//                 ),
//               ),
//             ),
//             if (section['title']!.contains('Contact Us'))
//               Padding(
//                 padding: EdgeInsets.only(
//                     left: screenSize.width * 0.1, top: screenSize.height * 0.01),
//                 child: _buildContactButton(screenSize),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContactButton(Size screenSize) {
//     return InkWell(
//       onTap: () => launchUrl(Uri.parse('mailto:qvikleez@gmail.com')),
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//             horizontal: screenSize.width * 0.04,
//             vertical: screenSize.height * 0.008),
//         decoration: BoxDecoration(
//           color: const Color(0xFF2511D6).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.mail_outline,
//                 color: const Color(0xFF2511D6),
//                 size: screenSize.width * 0.045),
//             SizedBox(width: screenSize.width * 0.02),
//             Text(
//               'Contact Support',
//               style: TextStyle(
//                 color: const Color(0xFF2511D6),
//                 fontWeight: FontWeight.w600,
//                 fontSize: screenSize.width * 0.035,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getSectionIcon(String title) {
//     switch (title.substring(0, 2)) {
//       case '1.':
//         return Icons.waving_hand;
//       case '2.':
//         return Icons.assignment_outlined;
//       case '3.':
//         return Icons.privacy_tip_outlined;
//       case '4.':
//         return Icons.shopping_cart_outlined;
//       case '5.':
//         return Icons.notifications_active_outlined;
//       case '6.':
//         return Icons.gavel_outlined;
//       case '7.':
//         return Icons.update;
//       case '8.':
//         return Icons.contact_support_outlined;
//       default:
//         return Icons.info_outline;
//     }
//   }

//   static const List<Map<String, String>> sections = [
//     {
//       'title': '1. Welcome to QUICKLEEZ',
//       'content':
//           'Thank you for choosing QUICKLEEZ! This platform is designed to help you rent and buy products quickly and securely. Please read these terms carefully before using the app.',
//     },
//     {
//       'title': '2. User Agreement',
//       'content':
//           'By using the QUICKLEEZ app, you agree to follow all applicable guidelines and terms of use. You are responsible for maintaining the accuracy of your personal information and for keeping your login credentials secure.',
//     },
//     {
//       'title': '3. Privacy Policy',
//       'content':
//           'We prioritize your privacy. Our privacy policy explains how your data is collected, used, and protected. By using QUICKLEEZ, you consent to these practices.',
//     },
//     {
//       'title': '4. Platform Information',
//       'content':
//           'QUICKLEEZ provides a marketplace for renting and buying products. Listings are provided by sellers, so we encourage users to verify information before making transactions.',
//     },
//     {
//       'title': '5. Notifications and Updates',
//       'content':
//           'Stay informed with notifications about new listings, special offers, and updates. Enable notifications to receive timely information.',
//     },
//     {
//       'title': '6. Limitation of Liability',
//       'content':
//           'QUICKLEEZ is not liable for discrepancies or issues arising from platform use. Users are advised to conduct their own research before transactions.',
//     },
//     {
//       'title': '7. Modifications to Terms',
//       'content':
//           'We may update these terms at any time. Major changes will be communicated through the app. Continued use of QUICKLEEZ means you accept the updated terms.',
//     },
//     {
//       'title': '8. Contact Us',
//       'content':
//           'For any queries or concerns, contact us at qvikleez@gmail.com or through our official channels.',
//     },
//   ];
// }

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFDFD), Color(0xFFEFEFF1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
              vertical: screenSize.height * 0.02,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSection(
                    '1. Welcome to QUICKLEEZ',
                    'Thank you for choosing QUICKLEEZ! This platform is designed to help you rent and buy products quickly and securely. Please read these terms carefully before using the app.',
                    screenSize,
                  ),
                  _buildSection(
                    '2. User Agreement',
                    'By using the QUICKLEEZ app, you agree to follow all applicable guidelines and terms of use. You are responsible for maintaining the accuracy of your personal information and for keeping your login credentials secure.',
                    screenSize,
                  ),
                  _buildSection(
                    '3. Privacy Policy',
                    'We prioritize your privacy. Our privacy policy explains how your data is collected, used, and protected. By using QUICKLEEZ, you consent to these practices.',
                    screenSize,
                  ),
                  _buildSection(
                    '4. Platform Information',
                    'QUICKLEEZ provides a marketplace for renting and buying products. Listings are provided by sellers, so we encourage users to verify information before making transactions.',
                    screenSize,
                  ),
                  _buildSection(
                    '5. Notifications and Updates',
                    'Stay informed with notifications about new listings, special offers, and updates. Enable notifications to receive timely information.',
                    screenSize,
                  ),
                  _buildSection(
                    '6. Limitation of Liability',
                    'QUICKLEEZ is not liable for discrepancies or issues arising from platform use. Users are advised to conduct their own research before transactions.',
                    screenSize,
                  ),
                  _buildSection(
                    '7. Modifications to Terms',
                    'We may update these terms at any time. Major changes will be communicated through the app. Continued use of QUICKLEEZ means you accept the updated terms.',
                    screenSize,
                  ),
                  _buildSection(
                    '8. Contact Us',
                    'For any queries or concerns, contact us at qvikleez@gmail.com or through our official channels.',
                    screenSize,
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildFooter(screenSize),
                  SizedBox(height: screenSize.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Size screenSize) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title, screenSize),
            SizedBox(height: screenSize.height * 0.01),
            _buildSectionContent(content, screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Size screenSize) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenSize.width * 0.05,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Widget _buildSectionContent(String content, Size screenSize) {
    return Text(
      content,
      style: TextStyle(
        fontSize: screenSize.width * 0.042,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildFooter(Size screenSize) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: screenSize.width * 0.029,
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
          children: [
            const TextSpan(text: 'Built with ❤️ by '),
            _buildHyperlink('PAVAN KUMAR', 'https://x.com/7pavankumar9'),
            const TextSpan(text: ', '),
            _buildHyperlink('SUBBU', 'https://x.com/subbu_surampudi'),
            const TextSpan(text: ', and '),
            _buildHyperlink('SUCHANDRA', 'https://x.com/snvvs369'),
          ],
        ),
      ),
    );
  }

  TextSpan _buildHyperlink(String name, String url) {
    return TextSpan(
      text: name,
      style: const TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () => launchUrl(Uri.parse(url)),
    );
  }
}


