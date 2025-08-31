import 'package:flutter/material.dart';

class TablesTab extends StatelessWidget {
  const TablesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Месяц')),
        DataColumn(label: Text('Продажи')),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('Январь')),
          DataCell(Text('\$1000')),
        ]),
        DataRow(cells: [
          DataCell(Text('Февраль')),
          DataCell(Text('\$1500')),
        ]),
      ],
    );
  }
}