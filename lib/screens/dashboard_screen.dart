import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/stats_card.dart';
import 'tabs/charts_tab.dart';
import 'tabs/tables_tab.dart';

class DashboardScreen extends StatelessWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Количество вкладок
      child: Column(
        children: [
          // Статистика сверху
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StatsCard(title: "Выручка", value: "\$${user.revenue}", icon: Icons.attach_money),
                StatsCard(title: "Прибыль", value: "\$${user.profit}", icon: Icons.trending_up),
              ],
            ),
          ),
          const TabBar(tabs: [
              Tab(icon: Icon(Icons.show_chart)),
              Tab(icon: Icon(Icons.table_chart)), // Таблицы
            ],
          ),
          // Контент вкладок
          Expanded(
            child: TabBarView(
              children: [
                ChartsTab(), // Графики
                TablesTab(), // Таблицы
              ],
            ),
          ),
        ],
      ),
    );
  }
}