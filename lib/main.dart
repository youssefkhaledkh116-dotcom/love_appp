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

// خلفية متحركة وواضحة مليانة بكلمة "شهد"
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
      duration: const Duration(seconds: 12), // سرعة الحركة الهادية
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
          // طبقة الكلمات المتحركة في الخلفية
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: MovingTextPainter(animationValue: _controller.value),
                ),
              );
            },
          ),
          // محتوى التطبيق الأساسي فوق الخلفية
          widget.child,
        ],
      ),
    );
  }
}

// رسام الكلمات المتحركة بوضوح أكتر
class MovingTextPainter extends CustomPainter {
  final double animationValue;
  MovingTextPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.rtl);

    // عدد أكبر من الكلمات عشان تملى الشاشة وتكون ظاهرة حلو
    for (int i = 0; i < 35; i++) {
      double x = (i * 95.0) % (size.width + 50);
      // حساب حركة الـ Y عشان تطلع وتنزل باستمرار
      double y =
          ((i * 70.0) + (animationValue * size.height)) % (size.height + 60) -
          30;

      textPainter.text = TextSpan(
        text: 'شهد ',
        style: TextStyle(
          fontSize: 20 + (i % 4) * 5.0, // أحجام متنوعة وشكلها لطيف
          color: Colors.pink.withValues(
            alpha: 0.18,
          ), // وضحناها شوية (زودنا الشفافية لـ 0.18 عشان تكون واضحة ومش مزعجة)
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant MovingTextPainter oldDelegate) {
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
  final String correctPassword = "14231"; // الباسورد هنا

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, size: 80, color: Colors.pink),
                const SizedBox(height: 20),
                const Text(
                  'مرحباً بكِ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'اكتبي اسمك الثلاثي',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.95),
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
                    fillColor: Colors.white.withValues(alpha: 0.95),
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
                  child: const Text('دخول', style: TextStyle(fontSize: 18)),
                ),
              ],
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

class _QuestionPageState extends State<QuestionPage> {
  bool answeredYes = false;

  @override
  Widget build(BuildContext context) {
    return MovingBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
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
                        },
                        child: const Text(
                          'نعم',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
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
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'مفيش الاختيار ده أصلاً! جربي تدوسي نعم ❤️',
                              ),
                            ),
                          );
                        },
                        child: const Text('لا', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ] else ...[
                  const Icon(Icons.favorite, size: 100, color: Colors.pink),
                  const SizedBox(height: 20),
                  const Text(
                    'والجيزاوي بيحبك جداً وعايزك تكوني دايما بخير ❤️',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
