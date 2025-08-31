import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'dashboard_screen.dart';
import 'subscription_screen.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = const User(
    name: "Гость",
    isSubscribed: false, // Начинаем без подписки
  );

  void _activateSubscription() {
    setState(() {
      user = User(
        name: user.name,
        isSubscribed: true, // Активируем подписку
        revenue: 15000,
        profit: 5000,
        adSpend: 2000,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ],
      ),
      drawer: const AppDrawer(),
      body: user.isSubscribed
          ? DashboardScreen(user: user)
          : SubscriptionScreen(onSubscribe: _activateSubscription),
    );
  }
}