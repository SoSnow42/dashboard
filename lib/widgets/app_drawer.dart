import 'package:dashboard/screens/pl_screen.dart';
import 'package:dashboard/screens/unit_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: const Text(
              "Меню",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildListTile(Icons.home, "Главная", context, onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/');
          }),
          _buildListTile(Icons.person, "Аккаунт", context),
          _buildListTile(Icons.payment, "Подписка", context),
          _buildListTile(Icons.monetization_on, "P&L Отчет", context, onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => DashboardPage()
            ));
          }),
          _buildListTile(Icons.monetization_on, "Unit экономика", context, onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => UnitPage()
            ));
          }),
          _buildListTile(Icons.settings, "Настройки", context),
          const Divider(color: Colors.grey),
          _buildListTile(Icons.exit_to_app, "Выйти", context),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, BuildContext context, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap ?? () {
        Navigator.pop(context);
      },
    );
  }
}