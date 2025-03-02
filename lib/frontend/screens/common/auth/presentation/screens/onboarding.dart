// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:quickleez/screens/auth/presentation/screens/login.dart';
// import 'package:quickleez/screens/auth/presentation/screens/terms.dart';




// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// final _onboardingKey = GlobalKey<_OnboardingScreenState>();

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController(initialPage: 0);
//   int currentPage = 0;
//   bool isPrivacyPolicyChecked = false;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   Widget buildPage(
//     BuildContext context,
//     String title,
//     String description,
//     String imageUrl,
//     String extraText,
//   ) {
//     final screenSize = MediaQuery.of(context).size;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Spacer(),
//           // Title
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: screenSize.width * 0.07, // Adjust size as needed
//               fontWeight: FontWeight.bold,
//               color: const Color.fromARGB(255, 0, 0, 0),
//               fontFamily: 'Montserrat',
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: screenSize.height * 0.02),
//           // Description
//           Text(
//             description,
//             style: TextStyle(
//               fontSize: screenSize.width * 0.05,
//               color: const Color.fromARGB(255, 5, 5, 5).withOpacity(0.9),
//               fontFamily: 'Montserrat',
//               height: 1.4,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: screenSize.height * 0.05),
//           if (imageUrl.isNotEmpty)
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.asset(
//                   imageUrl,
//                   height: screenSize.height * 0.28,
//                   width: screenSize.width * 0.6,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           SizedBox(height: screenSize.height * 0.05),
//           // Extra text
//           Text(
//             extraText,
//             style: TextStyle(
//               fontSize: screenSize.width * 0.045,
//               color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.85),
//               fontFamily: 'Montserrat',
//               fontStyle: FontStyle.italic,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildPageList(BuildContext context) {
//     return [
//       buildPage(
//         context,
//         "Welcome to QUICKLEEZ",
//         "Rent and buy anything quickly with our easy-to-use platform.",
//         'assets/logo/quickleez_1.png', // Your app logo (white version)
//         "Discover a world of convenience at your fingertips.",
//       ),
//       buildPage(
//         context,
//         "Explore Categories",
//         "Browse through various product categories - from gadgets to vehicles.",
//         'assets/logo/quickleez_1.png', // Image representing product exploration
//         "Find the perfect item to rent or buy in just a few clicks.",
//       ),
//       buildPage(
//         context,
//         "Detailed Listings",
//         "Get all the details you need for every product, including reviews and ratings.",
//         'assets/logo/quickleez_1.png', // Image representing product details
//         "Make informed decisions with transparent information.",
//       ),
//       buildPage(
//         context,
//         "Easy Transactions",
//         "Experience fast and secure payment and rental processes.",
//         'assets/logo/quickleez_1.png', // Image representing secure transactions
//         "Your safety and satisfaction are our top priorities.",
//       ),
//       buildPage(
//         context,
//         "Exclusive Deals",
//         "Enjoy special offers and discounts on selected products.",
//         'assets/logo/quickleez_1.png', // Image representing deals or discounts
//         "Save more every time you use QUICKLEEZ.",
//       ),
//       buildPage(
//         context,
//         "Admin Tools Coming Soon!",
//         "Manage your listings and track your transactions with ease.",
//         'assets/logo/quickleez_1.png', // Image for future admin tools
//         "Stay tuned for powerful tools that make managing your items effortless.",
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             // A dark gradient that fits the QUICKLEEZ concept
//             colors: <Color>[
//               const Color.fromARGB(255, 254, 252, 252), // Pure Black
//               const Color.fromARGB(255, 255, 255, 255),
//               const Color.fromARGB(255, 248, 248, 248),
//               const Color.fromARGB(255, 223, 221, 221),
//               const Color.fromARGB(255, 255, 255, 255),
//             ],
//           ),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {
//                   setState(() {
//                     currentPage = index;
//                   });
//                 },
//                 children: _buildPageList(context),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: screenSize.height * 0.02),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ...List.generate(
//                     _buildPageList(context).length,
//                     (index) => Padding(
//                       padding: EdgeInsets.only(right: screenSize.width * 0.01),
//                       child: DotIndicator(
//                         isActive: index == currentPage,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Checkbox(
//                   value: isPrivacyPolicyChecked,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       isPrivacyPolicyChecked = value ?? false;
//                     });
//                   },
//                   activeColor: const Color.fromARGB(255, 0, 0, 0),
//                   checkColor: const Color.fromARGB(255, 0, 0, 0),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: "By proceeding, you agree to our ",
//                     style: TextStyle(
//                       color: const Color.fromARGB(179, 0, 0, 0),
//                       fontSize: screenSize.width * 0.03,
//                       fontFamily: 'Montserrat',
//                     ),
//                     children: [
//                       TextSpan(
//                         text: "Privacy Policy",
//                         style: TextStyle(
//                           color: const Color.fromARGB(255, 27, 47, 177),
//                           fontSize: screenSize.width * 0.035,
//                           fontFamily: 'Montserrat',
//                           fontWeight: FontWeight.bold,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const TermsAndConditionsScreen(),
//                               ),
//                             );
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: screenSize.height * 0.02),
//             InkWell(
//               onTap: isPrivacyPolicyChecked
//                   ? () {
//                       Navigator.of(context).push(_createRoute());
//                     }
//                   : null, // Disable if unchecked
//               child: Container(
//                 margin: EdgeInsets.only(bottom: screenSize.height * 0.05),
//                 height: screenSize.height * 0.075,
//                 width: screenSize.width * 0.9,
//                 decoration: BoxDecoration(
//                   color: isPrivacyPolicyChecked
//                       ? const Color.fromARGB(255, 0, 0, 0)
//                       : const Color.fromARGB(255, 9, 9, 9),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Login / Registration",
//                     style: TextStyle(
//                       fontFamily: "HappyMonkey",
//                       color: Colors.white,
//                       fontSize: screenSize.width * 0.05,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Route _createRoute() {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) =>
//           const SimpleLoginScreen(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(1.0, 0.0);
//         const end = Offset.zero;
//         const curve = Curves.easeInOut;

//         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//         var offsetAnimation = animation.drive(tween);

//         return SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 500),
//     );
//   }
// }

// class DotIndicator extends StatelessWidget {
//   final bool isActive;

//   const DotIndicator({
//     super.key,
//     this.isActive = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       height: screenSize.width * 0.02,
//       width: isActive ? screenSize.width * 0.06 : screenSize.width * 0.02,
//       decoration: BoxDecoration(
//         color: isActive ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
//         borderRadius: BorderRadius.all(
//           Radius.circular(screenSize.width * 0.04),
//         ),
//       ),
//     );
//   }
// }
