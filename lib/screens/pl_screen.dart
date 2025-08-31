import 'package:dashboard/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // тёмный фон
      appBar: AppBar(
        title: const Text('P&L отчет'),
      ),
      drawer: AppDrawer(), // <-- используем существующий AppDrawer
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Левая колонка: только таблица
              Expanded(
                flex: 2,
                child: _buildTableCard(),
              ),
              const SizedBox(width: 10),
              // Правая колонка: прокручиваемая часть с графиками
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildBarChartCard()),
                          const SizedBox(width: 10),
                          Expanded(child: _buildGrossProfitCard()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildExpensesCard()),
                          const SizedBox(width: 10),
                          Expanded(child: _buildProfitCard()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: _buildROICard(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard() {
    return Card(
      color: Colors.grey[850],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            dataTextStyle: const TextStyle(color: Colors.white70),
            columns: const [
              DataColumn(label: Text("Месяц")),
              DataColumn(label: Text("Выручка")),
              DataColumn(label: Text("Себестоимость")),
              DataColumn(label: Text("Прибыль")),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text("Янв 23")), DataCell(Text("48 320")), DataCell(Text("22 110")), DataCell(Text("12 450"))]),
              DataRow(cells: [DataCell(Text("Фев 23")), DataCell(Text("45 520")), DataCell(Text("20 280")), DataCell(Text("10 275"))]),
              DataRow(cells: [DataCell(Text("Мар 23")), DataCell(Text("37 027")), DataCell(Text("24 234")), DataCell(Text("11 353"))]),
              DataRow(cells: [DataCell(Text("Апр 23")), DataCell(Text("32 572")), DataCell(Text("14 717")), DataCell(Text("5 657"))]),
              DataRow(cells: [DataCell(Text("Май 23")), DataCell(Text("29 526")), DataCell(Text("13 627")), DataCell(Text("5 277"))]),
              DataRow(cells: [DataCell(Text("Июн 23")), DataCell(Text("34 118")), DataCell(Text("15 432")), DataCell(Text("6 200"))]),
              DataRow(cells: [DataCell(Text("Июл 23")), DataCell(Text("36 945")), DataCell(Text("16 800")), DataCell(Text("7 125"))]),
              DataRow(cells: [DataCell(Text("Авг 23")), DataCell(Text("38 400")), DataCell(Text("18 220")), DataCell(Text("7 600"))]),
              DataRow(cells: [DataCell(Text("Сен 23")), DataCell(Text("40 520")), DataCell(Text("19 845")), DataCell(Text("8 050"))]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChartCard() {
    return _chartCard(
      title: "Структура P&L",
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: Colors.green), BarChartRodData(toY: 35, color: Colors.red)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 37, color: Colors.green), BarChartRodData(toY: 30, color: Colors.red)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 32, color: Colors.green), BarChartRodData(toY: 27, color: Colors.red)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 29, color: Colors.green), BarChartRodData(toY: 24, color: Colors.red)]),
          ],
        ),
      ),
    );
  }

  Widget _buildGrossProfitCard() => _simpleChartCard("Валовая прибыль");
  Widget _buildExpensesCard() => _simpleChartCard("Расходы");
  Widget _buildProfitCard() => _simpleChartCard("Прибыль");
  Widget _buildROICard() => _simpleChartCard("ROI");

  Widget _simpleChartCard(String title) {
    return _chartCard(
      title: title,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: const [
                FlSpot(0, 20),
                FlSpot(1, 18),
                FlSpot(2, 15),
                FlSpot(3, 13),
              ],
              color: Colors.orange,
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard({required String title, required Widget child}) {
    return Card(
      color: Colors.grey[850],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Divider(height: 1, color: Colors.white24),
            const SizedBox(height: 10),
            SizedBox(height: 150, child: child),
          ],
        ),
      ),
    );
  }
}
