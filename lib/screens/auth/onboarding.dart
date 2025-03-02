import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  int currentPage = 0;
  bool isLastPage = false;

  // For animated bubble background
  final List<BubbleData> bubbles = List.generate(
    15,
    (index) => BubbleData(
      position: Offset(
        math.Random().nextDouble() * 400,
        math.Random().nextDouble() * 800,
      ),
      size: math.Random().nextDouble() * 50 + 20,
      speed: math.Random().nextDouble() * 2 + 1,
      color: Color.fromRGBO(
        math.Random().nextInt(50) + 200,
        math.Random().nextInt(50) + 200,
        math.Random().nextInt(100) + 155,
        math.Random().nextDouble() * 0.4 + 0.1,
      ),
    ),
  );

  List<OnboardingItem> onboardingData = [
    OnboardingItem(
      title: "Welcome to LEEZ",
      description: "Revolutionizing rentals in tier 2 cities. Connect with local retailers and discover what you need.",
      animationPath: "assets/animations/welcome_anim.json",
      gradientColors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
      illustration: CustomIllustration.storefront,
    ),
    OnboardingItem(
      title: "Discover Local Inventory",
      description: "Browse through a wide variety of rental products from retailers near you.",
      animationPath: "assets/animations/discover_anim.json",
      gradientColors: [Color(0xFFFE6197), Color(0xFFFFB463)],
      illustration: CustomIllustration.browse,
    ),
    OnboardingItem(
      title: "Simplified Rentals",
      description: "Seamless booking process with transparent pricing and secure payments.",
      animationPath: "assets/animations/payment_anim.json",
      gradientColors: [Color(0xFF61A3FE), Color(0xFF63FFD5)],
      illustration: CustomIllustration.payment,
    ),
    OnboardingItem(
      title: "Empowering Local Businesses",
      description: "Supporting local retailers by connecting them directly with customers in need.",
      animationPath: "assets/animations/community_anim.json",
      gradientColors: [Color(0xFFFF61DC), Color(0xFF6E61FF)],
      illustration: CustomIllustration.growth,
    ),
    OnboardingItem(
      title: "Join the LEEZ Community",
      description: "Be part of a rental revolution that's changing how people access what they need.",
      animationPath: "assets/animations/join_anim.json",
      gradientColors: [Color(0xFF61FECF), Color(0xFF6193FE)],
      illustration: CustomIllustration.community,
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(_backgroundController);
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    _animationController.reset();
    _animationController.forward();
    
    setState(() {
      currentPage = page;
      isLastPage = page == onboardingData.length - 1;
    });
  }

  void _goToNextPage() {
    if (isLastPage) {
      _navigateToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SimpleLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOutCubic));
          var opacityTween = Tween(begin: 0.0, end: 1.0);
          var scaleTween = Tween(begin: 0.8, end: 1.0);
          
          return ScaleTransition(
            scale: animation.drive(scaleTween),
            child: FadeTransition(
              opacity: animation.drive(opacityTween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: BubbleBackgroundPainter(
                  bubbles: bubbles,
                  animationValue: _backgroundAnimation.value,
                ),
              );
            },
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button with custom animation
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedOpacity(
                      opacity: isLastPage ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: isLastPage 
                        ? const SizedBox(height: 40)
                        : CustomAnimatedButton(
                            onPressed: _navigateToLogin,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Skip",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward, size: 16, color: Colors.black87),
                              ],
                            ),
                          ),
                    ),
                  ),
                ),
                
                // Logo animation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - _animationController.value)),
                      child: Opacity(
                        opacity: _animationController.value,
                        child: Container(
                          height: 60,
                          width: 150,
                          margin: const EdgeInsets.only(top: 8, bottom: 20),
                          child: Center(
                            child: LogoWidget(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Page view with custom transitions
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) => buildOnboardingPage(
                      context,
                      onboardingData[index],
                      index,
                      size,
                    ),
                  ),
                ),
                
                // Page indicator with animated dots
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: currentPage == index 
                              ? onboardingData[currentPage].gradientColors[1]
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Next or Get Started button with animated gradient
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 40 * (1 - _animationController.value)),
                        child: Opacity(
                          opacity: _animationController.value,
                          child: GradientButton(
                            onPressed: _goToNextPage,
                            gradientColors: onboardingData[currentPage].gradientColors,
                            child: Text(
                              isLastPage ? "Get Started" : "Next",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(BuildContext context, OnboardingItem item, int index, Size size) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.translate(
            offset: Offset(50 * (1 - _animationController.value), 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Custom illustration with animated painter
                  Container(
                    height: size.height * 0.35,
                    width: size.width * 0.85,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Stack(
                      children: [
                        // Background gradient shape
                        CustomPaint(
                          size: Size(size.width * 0.85, size.height * 0.35),
                          painter: BlobPainter(
                            colors: item.gradientColors,
                            animationValue: _animationController.value,
                          ),
                        ),
                        
                        // Custom illustration
                        Center(
                          child: CustomPaint(
                            size: Size(size.width * 0.6, size.height * 0.25),
                            painter: IllustrationPainter(
                              illustration: item.illustration,
                              animationValue: _animationController.value,
                              colors: item.gradientColors,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Title with gradient text
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: item.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description with improved readability and animation
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Widgets

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "LEEZ",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [
                  Color(0xFF6448FE),
                  Color(0xFF5FC6FF),
                ],
              ).createShader(Rect.fromLTWH(0, 0, 150, 60)),
            letterSpacing: 1.5,
          ),
        ),
        Positioned(
          right: 25,
          bottom: 6,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFE6197),
                  Color(0xFFFF61DC),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final List<Color> gradientColors;

  const GradientButton({
    required this.onPressed,
    required this.child,
    required this.gradientColors,
    super.key,
  });

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: widget.gradientColors,
                    begin: Alignment(_animation.value, 0),
                    end: Alignment(_animation.value + 2, 1),
                  ),
                ),
                child: Center(child: widget.child),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomAnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CustomAnimatedButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  @override
  _CustomAnimatedButtonState createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _controller.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _controller.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _isHovered ? Colors.grey.shade200 : Colors.transparent,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom Painters

class BubbleBackgroundPainter extends CustomPainter {
  final List<BubbleData> bubbles;
  final double animationValue;

  BubbleBackgroundPainter({
    required this.bubbles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      // Calculate movement
      final offset = Offset(
        bubble.position.dx,
        (bubble.position.dy + (animationValue * bubble.speed * 100)) % size.height,
      );

      // Draw bubble
      final paint = Paint()
        ..color = bubble.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(offset, bubble.size, paint);
    }
  }

  @override
  bool shouldRepaint(BubbleBackgroundPainter oldDelegate) => true;
}

class BlobPainter extends CustomPainter {
  final List<Color> colors;
  final double animationValue;

  BlobPainter({
    required this.colors,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Create gradient
    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create blob shape
    final radius = math.min(size.width, size.height) * 0.4;
    final variance = radius * 0.2;
    
    List<Offset> points = [];
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * math.pi * 2;
      final noise = math.sin((animationValue * 2 + i) * 0.5) * variance;
      final r = radius + noise;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;
      points.add(Offset(x, y));
    }
    
    // Create the path
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      final midPoint = Offset(
        (p1.dx + p2.dx) / 2,
        (p1.dy + p2.dy) / 2,
      );
      path.quadraticBezierTo(p1.dx, p1.dy, midPoint.dx, midPoint.dy);
    }
    path.close();
    
    // Apply a slight shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 15, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class IllustrationPainter extends CustomPainter {
  final CustomIllustration illustration;
  final double animationValue;
  final List<Color> colors;

  IllustrationPainter({
    required this.illustration,
    required this.animationValue,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Create base paint
    final paint = Paint()
      ..color = colors[0]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [colors[0].withOpacity(0.2), colors[1].withOpacity(0.3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw the illustration based on type
    switch (illustration) {
      case CustomIllustration.storefront:
        _drawStorefront(canvas, size, center, paint, fillPaint);
        break;
      case CustomIllustration.browse:
        _drawBrowse(canvas, size, center, paint, fillPaint);
        break;
      case CustomIllustration.payment:
        _drawPayment(canvas, size, center, paint, fillPaint);
        break;
      case CustomIllustration.growth:
        _drawGrowth(canvas, size, center, paint, fillPaint);
        break;
      case CustomIllustration.community:
        _drawCommunity(canvas, size, center, paint, fillPaint);
        break;
    }
  }

  void _drawStorefront(Canvas canvas, Size size, Offset center, Paint paint, Paint fillPaint) {
    // Building outline with animated drawing
    final progress = animationValue;
    final path = Path();
    
    // Building base
    final buildingWidth = size.width * 0.7;
    final buildingHeight = size.height * 0.6;
    final buildingTop = center.dy - buildingHeight * 0.3;
    final buildingLeft = center.dx - buildingWidth / 2;
    
    final buildingRect = Rect.fromLTWH(
      buildingLeft, 
      buildingTop, 
      buildingWidth, 
      buildingHeight
    );
    
    // Draw the building with rounded corners
    path.addRRect(RRect.fromRectAndRadius(
      buildingRect, 
      Radius.circular(12)
    ));
    
    // Draw windows and door with animation
    if (progress > 0.3) {
      // Door
      final doorWidth = buildingWidth * 0.25;
      final doorHeight = buildingHeight * 0.4;
      final doorPath = Path();
      doorPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
          center.dx - doorWidth / 2,
          buildingTop + buildingHeight - doorHeight,
          doorWidth,
          doorHeight
        ),
        Radius.circular(8)
      ));
      canvas.drawPath(doorPath, fillPaint);
      canvas.drawPath(doorPath, paint);
      
      // Windows
      if (progress > 0.5) {
        final windowSize = buildingWidth * 0.15;
        final windowY = buildingTop + buildingHeight * 0.2;
        
        // Left window
        final leftWindowPath = Path();
        leftWindowPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(
            buildingLeft + buildingWidth * 0.2,
            windowY,
            windowSize,
            windowSize
          ),
          Radius.circular(4)
        ));
        canvas.drawPath(leftWindowPath, fillPaint);
        canvas.drawPath(leftWindowPath, paint);
        
        // Right window
        final rightWindowPath = Path();
        rightWindowPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(
            buildingLeft + buildingWidth * 0.65,
            windowY,
            windowSize,
            windowSize
          ),
          Radius.circular(4)
        ));
        canvas.drawPath(rightWindowPath, fillPaint);
        canvas.drawPath(rightWindowPath, paint);
      }
    }
    
    // Animate the building outline
    canvas.drawPath(path, fillPaint);
    
    // Draw the path with animated stroke
    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0, 
      pathMetrics.length * progress
    );
    canvas.drawPath(extractPath, paint);
    
    // Draw shop sign if animation is near complete
    if (progress > 0.7) {
      final signWidth = buildingWidth * 0.5;
      final signHeight = buildingHeight * 0.15;
      final signTop = buildingTop - signHeight - 5;
      final signLeft = center.dx - signWidth / 2;
      
      final signPath = Path();
      signPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
          signLeft,
          signTop,
          signWidth,
          signHeight
        ),
        Radius.circular(6)
      ));
      
      canvas.drawPath(signPath, fillPaint);
      canvas.drawPath(signPath, paint);
      
      // Draw "LEEZ" text on sign
      final textPaint = Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      
      final textPath = Path();
      // Simplified "LEEZ" text
      final textLeft = signLeft + signWidth * 0.2;
      final textTop = signTop + signHeight * 0.3;
      final letterWidth = signWidth * 0.15;
      
      // L
      textPath.moveTo(textLeft, textTop);
      textPath.lineTo(textLeft, textTop + signHeight * 0.4);
      textPath.lineTo(textLeft + letterWidth * 0.8, textTop + signHeight * 0.4);
      
      // E
      textPath.moveTo(textLeft + letterWidth, textTop);
      textPath.lineTo(textLeft + letterWidth, textTop + signHeight * 0.4);
      textPath.moveTo(textLeft + letterWidth, textTop);
      textPath.lineTo(textLeft + letterWidth * 1.7, textTop);
      textPath.moveTo(textLeft + letterWidth, textTop + signHeight * 0.2);
      textPath.lineTo(textLeft + letterWidth * 1.5, textTop + signHeight * 0.2);
      textPath.moveTo(textLeft + letterWidth, textTop + signHeight * 0.4);
      textPath.lineTo(textLeft + letterWidth * 1.7, textTop + signHeight * 0.4);
      
      // E
      textPath.moveTo(textLeft + letterWidth * 2, textTop);
      textPath.lineTo(textLeft + letterWidth * 2, textTop + signHeight * 0.4);
      textPath.moveTo(textLeft + letterWidth * 2, textTop);
      textPath.lineTo(textLeft + letterWidth * 2.7, textTop);
      textPath.moveTo(textLeft + letterWidth * 2, textTop + signHeight * 0.2);
      textPath.lineTo(textLeft + letterWidth * 2.5, textTop + signHeight * 0.2);
      textPath.moveTo(textLeft + letterWidth * 2, textTop + signHeight * 0.4);
      textPath.lineTo(textLeft + letterWidth * 2.7, textTop + signHeight * 0.4);
      
      // Z
      textPath.moveTo(textLeft + letterWidth * 3, textTop);
      textPath.lineTo(textLeft + letterWidth * 3.7, textTop);
      textPath.lineTo(textLeft + letterWidth * 3, textTop + signHeight * 0.4);
      textPath.lineTo(textLeft + letterWidth * 3.7, textTop + signHeight * 0.4);
      
      canvas.drawPath(textPath, textPaint);
    }
  }

  void _drawBrowse(Canvas canvas, Size size, Offset center, Paint paint, Paint fill