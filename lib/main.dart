import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const LoveApp());
}

class LoveApp extends StatelessWidget {
  const LoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'For You',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF0F3),
      ),
      home: const LoginPage(),
    );
  }
}

// خلفية متحركة مدمجة بكلمات "شهد" وقلوب متطايرة
class MovingBackground extends StatefulWidget {
  final Widget child;
  const MovingBackground({super.key, required this.child});

  @override
  State<MovingBackground> createState() => _MovingBackgroundState();
}

class _MovingBackgroundState extends State<MovingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F3),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: MovingElementsPainter(
                    animationValue: _controller.value,
                  ),
                ),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class MovingElementsPainter extends CustomPainter {
  final double animationValue;
  MovingElementsPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.rtl);
    final random = Random(42);

    for (int i = 0; i < 40; i++) {
      double x = (i * 85.0 + random.nextDouble() * 40) % (size.width + 50);
      double y =
          ((i * 60.0) + (animationValue * size.height)) % (size.height + 60) -
          30;

      if (i % 2 == 0) {
        textPainter.text = TextSpan(
          text: 'شهد ',
          style: TextStyle(
            fontSize: 18 + (i % 3) * 6.0,
            color: Colors.pink.withValues(alpha: 0.16),
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      } else {
        textPainter.text = TextSpan(
          text: '❤️ ',
          style: TextStyle(
            fontSize: 16 + (i % 4) * 4.0,
            color: Colors.redAccent.withValues(alpha: 0.15),
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant MovingElementsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final String correctName = "شهد احمد علي";
  final String correctPassword = "14231";

  void _login() {
    if (_nameController.text.trim() == correctName.trim() &&
        _passwordController.text.trim() == correctPassword.trim()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuestionPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الاسم أو الباسورد مش مظبوط يا غالي، جربي تاني!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovingBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 8,
              shadowColor: Colors.pink.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withValues(alpha: 0.92),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, size: 70, color: Colors.pink),
                    const SizedBox(height: 15),
                    const Text(
                      'مرحباً بكِ 💖',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اكتبي اسمك الثلاثي',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text(
                        'دخول ✨',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with SingleTickerProviderStateMixin {
  bool answeredYes = false;
  double noBtnX = 0;
  double noBtnY = 0;
  final Random _random = Random();

  late AnimationController _loveMeterController;
  late Animation<double> _loveMeterAnimation;

  @override
  void initState() {
    super.initState();
    _loveMeterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _loveMeterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loveMeterController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _loveMeterController.dispose();
    super.dispose();
  }

  void _moveNoButton() {
    setState(() {
      noBtnX = (_random.nextDouble() - 0.5) * 200;
      noBtnY = (_random.nextDouble() - 0.5) * 150;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MovingBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              shadowColor: Colors.pink.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withValues(alpha: 0.92),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!answeredYes) ...[
                      const Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.pink,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'هل تحبين الجيزاوي؟',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                answeredYes = true;
                              });
                              _loveMeterController.forward();
                            },
                            child: const Text(
                              'نعم ❤️',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Transform.translate(
                            offset: Offset(noBtnX, noBtnY),
                            child: MouseRegion(
                              onEnter: (_) => _moveNoButton(),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _moveNoButton,
                                child: const Text(
                                  'لا',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const Icon(Icons.favorite, size: 90, color: Colors.pink),
                      const SizedBox(height: 15),
                      const Text(
                        'والجيزاوي كمان بيحبك جداً 💍✨',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      // أنيميشن مستوى الحب (Love Meter)
                      Column(
                        children: [
                          const Text(
                            'مستوى الحب: 100% (ما شاء الله لا ينتهي) 🚀💖',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          AnimatedBuilder(
                            animation: _loveMeterAnimation,
                            builder: (context, child) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: _loveMeterAnimation.value,
                                  minHeight: 14,
                                  backgroundColor: Colors.pink[100],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.redAccent,
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
