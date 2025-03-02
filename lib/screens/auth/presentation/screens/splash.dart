// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'onboarding.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the animation controller
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );

//     // Create fade animation from 0.0 to 1.0
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeIn,
//       ),
//     );

//     // Start the animation
//     _controller.forward();

//     // Navigate to Onboarding screen after a delay
//     _navigateToOnboarding();
//   }

//   void _navigateToOnboarding() async {
//     await Future.delayed(const Duration(seconds: 4));
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => const OnboardingScreen(),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Initialize ScreenUtil (for older versions; newer versions may use ScreenUtilInit)
//     ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true);

//     // MediaQuery for responsive layout
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Gradient background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black,
//                   Color.fromARGB(255, 0, 0, 0),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),

//           // Centered Column with logo, text, and progress indicator
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo with fade animation and errorBuilder
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Image.asset(
//                     'assets/logo/ql.png', // Replace with your logo URL
//                     height: screenHeight * 0.3, // Adjusted to fit better
//                     width: screenWidth * 0.6,
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Icon(
//                         Icons.error,
//                         color: Colors.white,
//                         size: 50,
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 // Text with fade animation
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Text(
//                     '',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 // // Circular loading indicator with fade animation
//                 // FadeTransition(
//                 //   opacity: _fadeAnimation,
//                 //   child: const CircularProgressIndicator(
//                 //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
