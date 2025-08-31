import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sf;

class ChartsTab extends StatelessWidget {
  const ChartsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData('Jan', 35),
      SalesData('Feb', 28),
      SalesData('Mar', 45),
    ];

    return sf.SfCartesianChart( // Используем префикс sf
    
      primaryXAxis: sf.CategoryAxis(),
      series: <sf.CartesianSeries<SalesData, String>>[
        sf.LineSeries<SalesData, String>(
          color: Colors.deepPurple,
          dataSource: chartData,
          xValueMapper: (SalesData sales, _) => sales.month,
          yValueMapper: (SalesData sales, _) => sales.sales,
        ),
      ],
    );
  }
}

class SalesData {
  final String month;
  final double sales;
  
  SalesData(this.month, this.sales);
}