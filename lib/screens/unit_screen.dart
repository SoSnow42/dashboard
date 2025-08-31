import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalesService {
  final String apiKey =
      "eyJhbGciOiJFUzI1NiIsImtpZCI6IjIwMjUwNTIwdjEiLCJ0eXAiOiJKV1QifQ.eyJlbnQiOjEsImV4cCI6MTc3MTM2ODUxMiwiaWQiOiIwMTk4YzFmMS1lNDJmLTcwMWEtYmNlMy1hNTcyZmJhYTk4ZjkiLCJpaWQiOjYxNDIyOTg0LCJvaWQiOjQxMzY3NzQsInMiOjAsInNpZCI6ImJhOTFhOGYxLWRiNzYtNDlmOC1hNjFmLWU3MDZiYzhiOTM3YSIsInQiOnRydWUsInVpZCI6NjE0MjI5ODR9.6NJocwLm-iSwsZEwFIKdJprGLtWGInBxnE8Gt751ljOxyF4zh9WO4MVSfvVWDK9_qkRuxe05B3NcU378E0qi2g"; // вставь свой sandbox ключ
  final String baseUrl =
      "https://statistics-api-sandbox.wildberries.ru/api/v1/supplier/sales";

  Future<List<dynamic>> fetchSales() async {
    final now = DateTime.now();
    final dateFrom = DateTime(now.year, now.month - 4, now.day);
    final url = Uri.parse(
      "$baseUrl?dateFrom=${dateFrom.toIso8601String()}&dateTo=${now.toIso8601String()}",
    );

    final response = await http.get(url, headers: {"Authorization": apiKey});

    if (response.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
        "Ошибка при загрузке данных WB API: ${response.statusCode}",
      );
    }
  }
}

class UnitPage extends StatefulWidget {
  const UnitPage({super.key});

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  final SalesService _service = SalesService();
  List<dynamic> _sales = [];
  List<dynamic> _filteredSales = [];
  bool _loading = false;
  String _searchQuery = "";

  int _currentPage = 0;
  int _rowsPerPage = 20;
  final List<int> _rowsPerPageOptions = const [20, 50, 100];

  // список доступных колонок
  final Map<String, String> _allColumns = {
    "date": "Дата",
    "supplierArticle": "Артикул",
    "category": "Категория",
    "quantity": "Кол-во",
    "totalPrice": "Полная цена",
    "discountPercent": "Скидка, %",
    "forPay": "К оплате",
    "costPrice": "Себестоимость",
    "priceWithDisc": "Цена со скидкой",
    "commission": "Комиссия WB",
    "logistics": "Логистика",
    "brand": "Бренд",
    "profit": "Прибыль",
    "spp": "Комиссия, рублей",
  };

  // какие колонки выбраны для показа
  final Set<String> _visibleColumns = {
    "date",
    "supplierArticle",
    "category",
    "totalPrice",
    "forPay",
  };

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final data = await _service.fetchSales();
      setState(() {
        _sales = data;
        _applyFilter();
        _currentPage = 0;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredSales = _sales;
    } else {
      _filteredSales = _sales
          .where(
            (s) => (s['supplierArticle'] ?? "")
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _filteredSales.isEmpty
        ? 1
        : (_filteredSales.length / _rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Row(
          children: [
            // Поиск
            // Заголовок
            const Text("Unit экономика"),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Поиск по артикулу...",
                    prefixIcon: const Icon(Icons.search),
                    // filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                      _applyFilter();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _loading ? null : _loadData,
              child: const Text("Загрузить данные WB"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                if (_filteredSales.isNotEmpty)
                  Row(
                    children: [
                      const Text(
                        "Строк на странице:",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        dropdownColor: Colors.grey[850],
                        value: _rowsPerPage,
                        items: _rowsPerPageOptions
                            .map(
                              (n) => DropdownMenuItem(
                                value: n,
                                child: Text(
                                  "$n",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            _rowsPerPage = v;
                            _currentPage = 0;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (_loading) const CircularProgressIndicator(),

            if (_filteredSales.isNotEmpty) Expanded(child: _buildSalesTable()),

            if (_filteredSales.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 0
                        ? () => setState(() => _currentPage--)
                        : null,
                    child: const Text("← Назад"),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Страница ${_filteredSales.isEmpty ? 0 : _currentPage + 1} из ${_filteredSales.isEmpty ? 0 : totalPages}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _currentPage < totalPages - 1
                        ? () => setState(() => _currentPage++)
                        : null,
                    child: const Text("Вперёд →"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTable() {
    final startIndex = (_currentPage * _rowsPerPage).clamp(
      0,
      _filteredSales.length,
    );
    final endIndex = ((_currentPage + 1) * _rowsPerPage).clamp(
      0,
      _filteredSales.length,
    );
    final pageSales = _filteredSales.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double colW = (constraints.maxWidth / _visibleColumns.length);

          Widget cell(
            String text, {
            TextAlign align = TextAlign.center,
            FontWeight? fw,
          }) {
            final controller = TextEditingController(text: text);
            return SizedBox(
              width: colW,
              child: TextField(
                controller: controller,
                textAlign: align,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white70, fontWeight: fw),
                onSubmitted: (newValue) {
                  // setState(() {
                  //   _filteredSales[globalIndex][colKey] = newValue;
                  //   // при необходимости обновляем исходный список _sales
                  //   final originalIndex = _sales.indexOf(
                  //     _filteredSales[globalIndex],
                  //   );
                  //   if (originalIndex != -1) {
                  //     _sales[originalIndex][colKey] = newValue;
                  //   }
                  // });
                }
              ),
            );
          }

          return DataTable(
            columnSpacing: 0,
            horizontalMargin: 8,
            headingRowColor: MaterialStateProperty.all(Colors.grey[850]),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            columns: _visibleColumns.map((colKey) {
              return DataColumn(
                label: SizedBox(
                  width: colW, // заранее вычисленная ширина колонки
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _allColumns[colKey] ?? colKey,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            if (_visibleColumns.contains(value)) {
                              _visibleColumns.remove(value);
                            } else {
                              _visibleColumns.add(value);
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          size: 16,
                          color: Colors.white70,
                        ),
                        itemBuilder: (_) {
                          return _allColumns.entries.map((e) {
                            return CheckedPopupMenuItem<String>(
                              value: e.key,
                              checked: _visibleColumns.contains(e.key),
                              child: Text(e.value),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            rows: pageSales.map((sale) {
              return DataRow(
                cells: _visibleColumns.map((colKey) {
                  final val = sale[colKey]?.toString() ?? "-";
                  return DataCell(cell(val));
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
