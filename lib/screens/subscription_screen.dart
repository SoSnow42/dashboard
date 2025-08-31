import 'package:flutter/material.dart';
import 'package:swipe_card_animation/swipe_card_animation.dart';

class SubscriptionScreen extends StatefulWidget {
  final VoidCallback onSubscribe;

  const SubscriptionScreen({super.key, required this.onSubscribe});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<String> _features = [
    "Расширенная аналитика",
    "Детальные отчеты",
    "Персональные рекомендации",
    "Экспорт данных в PDF",
    "Приоритетная поддержка",
    "Кастомные дашборды",
  ];

  final List<IconData> _featureIcons = [
    Icons.analytics,
    Icons.description,
    Icons.recommend,
    Icons.picture_as_pdf,
    Icons.headset_mic,
    Icons.dashboard_customize,
  ];

final List<Gradient> beautifulGradients = [
  // 1. Морская волна
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF00C9FF),
      const Color(0xFF92FE9D),
    ],
  ),

  // 2. Пурпурный закат
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFFDA22FF),
      const Color(0xFF9733EE),
    ],
  ),

  // 3. Огненный восход
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFFF512F),
      const Color(0xFFDD2476),
    ],
  ),

  // 4. Тропический рай
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF11998E),
      const Color(0xFF38EF7D),
    ],
  ),

  // 5. Глубокий космос
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFF0F2027),
      const Color(0xFF203A43),
      const Color(0xFF2C5364),
    ],
    stops: [0.0, 0.5, 1.0],
  ),

  // 6. Неоновая мечта
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFA6FFCB),
      const Color(0xFF12D8FA),
      const Color(0xFF1FA2FF),
    ],
    stops: [0.1, 0.5, 1.0],
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Контейнер с преимуществами
            Column(
              children: [
                const Text(
                  "Все преимущества подписки:",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            StackCardAnimation(
              cardStyle: CardStyle(
                height: 300,
                width: 300,
                activeColor: Colors.blue.shade300,
                inactiveColor: Colors.grey,
                borderRadius: 15,
              ),
              totalCards: 5,
              builder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: beautifulGradients[index],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_featureIcons[index], size: 40),
                      Text(
                        _features[index],
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Кнопка подписки
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              onPressed: () {
                widget.onSubscribe();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Подписка активирована!"),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: const Text(
                "ПОДПИСАТЬСЯ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
