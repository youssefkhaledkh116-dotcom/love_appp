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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          const Text(
                            'مستوى الحب: 100% (ما شاء الله لا ينتهي) 🚀💖',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedBuilder(
                            animation: _loveMeterAnimation,
                            builder: (context, child) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: _loveMeterAnimation.value,
                                  minHeight: 12,
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
                      const SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HeartCatchGamePage(),
                            ),
                          );
                        },
                        child: const Text(
                          'ادخلي العبي اللعبة الأولى 🎮❤️',
                          style: TextStyle(fontSize: 16),
                        ),
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

class HeartCatchGamePage extends StatefulWidget {
  const HeartCatchGamePage({super.key});

  @override
  State<HeartCatchGamePage> createState() => _HeartCatchGameState();
}

class _HeartCatchGameState extends State<HeartCatchGamePage>
    with TickerProviderStateMixin {
  int score = 0;
  bool hasWon = false;
  final Random _random = Random();

  double heartX = 150;
  double heartY = 0;
  double basketX = 130;

  late AnimationController _gameController;

  @override
  void initState() {
    super.initState();
    _gameController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 15),
          )
          ..addListener(_updateGame)
          ..repeat();
  }

  void _updateGame() {
    if (hasWon) return;
    setState(() {
      heartY += 5.0;
      if (heartY > 360) {
        if ((heartX - basketX).abs() < 60) {
          score += 1;
          _resetHeart();
          if (score >= 10) {
            hasWon = true;
            _gameController.stop();
          }
        } else if (heartY > 410) {
          _resetHeart();
        }
      }
    });
  }

  void _resetHeart() {
    heartY = 0;
    heartX = _random.nextDouble() * 260;
  }

  @override
  void dispose() {
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MovingBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text(
            'المرحلة 1: قلوب الجيزاوي 🎮❤️',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 550),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withValues(alpha: 0.95),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: !hasWon
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'القلوب المجمعة: $score / 10 💖',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  basketX += details.delta.dx;
                                  basketX = basketX.clamp(0.0, 260.0);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink[50],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.pink.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: heartX,
                                      top: heartY,
                                      child: const Text(
                                        '❤️',
                                        style: TextStyle(fontSize: 28),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: basketX,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Text(
                                          '🧺 الجيزاوي',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'اجمعي 10 قلوب عشان تفتحي المرحلة التانية! ✨',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 80, color: Colors.amber),
                          const SizedBox(height: 15),
                          const Text(
                            'أعظم إنجاز يا أجمل شهد! 🎉',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'اجتزتِ المرحلة الأولى بنجاح وكسبتِ قلوب قلبي كلهم!\nيلا بينا على المرحلة التانية: سواقة العربية وتفادي الحواجز! 🚗💨',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CarDrivingGamePage(),
                                ),
                              );
                            },
                            child: const Text(
                              'ابدأ المرحلة التانية 🚗✨',
                              style: TextStyle(fontSize: 16),
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

class CarDrivingGamePage extends StatefulWidget {
  const CarDrivingGamePage({super.key});

  @override
  State<CarDrivingGamePage> createState() => _CarDrivingGamePageState();
}

class _CarDrivingGamePageState extends State<CarDrivingGamePage>
    with TickerProviderStateMixin {
  int passedBarriers = 0;
  bool isGameOver = false;
  bool hasWonGame2 = false;

  double carX = 130;
  double barrierX = 130;
  double barrierY = 0;

  final Random _random = Random();
  late AnimationController _carController;

  @override
  void initState() {
    super.initState();
    _resetBarrier();
    _carController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 15),
          )
          ..addListener(_updateDrivingGame)
          ..repeat();
  }

  void _updateDrivingGame() {
    if (isGameOver || hasWonGame2) return;
    setState(() {
      barrierY += 4.5;

      if (barrierY > 350 && barrierY < 420) {
        if ((carX - barrierX).abs() < 45) {
          isGameOver = true;
        }
      }

      if (barrierY > 450) {
        passedBarriers += 1;
        _resetBarrier();

        if (passedBarriers >= 15) {
          hasWonGame2 = true;
          _carController.stop();
        }
      }
    });
  }

  void _resetBarrier() {
    barrierY = 0;
    List<double> lanes = [40.0, 130.0, 220.0];
    barrierX = lanes[_random.nextInt(lanes.length)];
  }

  void _restartGame() {
    setState(() {
      passedBarriers = 0;
      isGameOver = false;
      hasWonGame2 = false;
      _resetBarrier();
      _carController.repeat();
    });
  }

  @override
  void dispose() {
    _carController.dispose();
    super.dispose();
  }

  Widget _buildGameContent() {
    if (hasWonGame2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, size: 90, color: Colors.pink),
          const SizedBox(height: 15),
          const Text(
            'مبروك الفوز الأسطوري يا أجمل شهد! 🏆❤️',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Text(
            'أثبتِ إنك شاطرة في كل حاجة، حتى سواقة العربية وتفادي الصعاب!\nالجيزاوي بيحبك بجنون وعايزك تفضلي منورة حياته دايماً ومبتسمة يا أجمل حاجة في عمري 💍✨',
            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'العودة للبداية 💖',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    } else if (isGameOver) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.car_crash, size: 80, color: Colors.red),
          const SizedBox(height: 15),
          const Text(
            'ياااه خبطتِ في الحاجز! 😅',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Text(
            'معليش يا ست البنات، السواقة عاوزة تركيز شوية.. جربي تاني وهتعديها بسهولة! 💪❤️',
            style: TextStyle(fontSize: 15, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _restartGame,
            child: const Text(
              'إعادة المحاولة 🔄',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'الحواجز المجتازة: $passedBarriers / 15 🚧',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  carX += details.delta.dx;
                  carX = carX.clamp(20.0, 260.0);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.pink.withValues(alpha: 0.5),
                    width: 3,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(child: Container(width: 4, color: Colors.white24)),
                    Positioned(
                      left: barrierX,
                      top: barrierY,
                      child: Container(
                        width: 70,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '🚧 خطر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      left: carX,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.pink, blurRadius: 8),
                          ],
                        ),
                        child: const Text(
                          '🚗 شهد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'حركي العربية يمين ويسار لتفادي الحواجز الحمراء! 🛣️',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovingBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text(
            'المرحلة 2: سواقة العربية وتفادي الحواجز 🚗✨',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 580),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withValues(alpha: 0.95),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildGameContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
