import 'package:flutter/material.dart';
import '../../data/repositories/mock_transaction_repository.dart';
import '../../domain/models/transaction.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  final bool isIncome;
  final int accountId;

  const AnalysisPage({Key? key, required this.isIncome, required this.accountId}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _repo = MockTransactionRepository();
  late DateTime _startDate;
  late DateTime _endDate;
  bool _loading = true;
  List<TransactionWithDetails> _all = [];
  Map<int, List<TransactionWithDetails>> _byCategory = {};
  Map<int, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month - 1, now.day);
    _endDate = now;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final txs = await _repo.getTransactionsByAccountAndPeriod(
      widget.accountId,
      startDate: _startDate,
      endDate: _endDate,
    );
    final filtered = txs.where((t) => t.category.isIncome == widget.isIncome).toList();
    final byCat = <int, List<TransactionWithDetails>>{};
    for (final t in filtered) {
      byCat.putIfAbsent(t.category.id, () => []).add(t);
    }
    setState(() {
      _all = filtered;
      _byCategory = byCat;
      _expanded = {};
      _loading = false;
    });
  }

  double get _total => _all.fold(0.0, (s, t) => s + (double.tryParse(t.amount) ?? 0.0));

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) _endDate = _startDate;
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) _startDate = _endDate;
        }
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Анализ')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(isStart: true),
                          child: _PillDateButton(date: _startDate),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(isStart: false),
                          child: _PillDateButton(date: _endDate),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Сумма', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('${_total.toStringAsFixed(2)} ₽', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    itemCount: _byCategory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final entry = _byCategory.entries.elementAt(idx);
                      final cat = entry.value.first.category;
                      final sum = entry.value.fold(0.0, (s, t) => s + (double.tryParse(t.amount) ?? 0.0));
                      final percent = _total > 0 ? (sum / _total * 100).round() : 0;
                      final lastTx = entry.value.reduce((a, b) => a.transactionDate.isAfter(b.transactionDate) ? a : b);
                      final expanded = _expanded[cat.id] ?? false;
                      return Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Color(cat.backgroundColor),
                                child: Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                              ),
                              title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: lastTx.comment != null && lastTx.comment!.isNotEmpty ? Text(lastTx.comment!) : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('$percent%', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                  const SizedBox(width: 8),
                                  Text('${sum.toStringAsFixed(0)} ₽', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  const SizedBox(width: 8),
                                  Icon(expanded ? Icons.expand_less : Icons.chevron_right, size: 22),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              onTap: () {
                                setState(() => _expanded[cat.id] = !expanded);
                              },
                              minVerticalPadding: 12,
                              horizontalTitleGap: 12,
                              isThreeLine: false,
                              dense: false,
                            ),
                          ),
                          if (expanded)
                            Container(
                              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: entry.value.length,
                                itemBuilder: (context, i) {
                                  final tx = entry.value[i];
                                  return ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.only(left: 24, right: 8),
                                    title: Text('${tx.amount} ₽', style: const TextStyle(fontWeight: FontWeight.w500)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(DateFormat('dd.MM.yyyy').format(tx.transactionDate)),
                                        if (tx.comment != null && tx.comment!.isNotEmpty)
                                          Text(tx.comment!, style: const TextStyle(color: Colors.black54)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _PillDateButton extends StatelessWidget {
  final DateTime date;
  const _PillDateButton({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7E6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          _formatDate(date),
          style: const TextStyle(
            color: Color(0xFF1DB954),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${_monthName(d.month)} ${d.year}';

  String _monthName(int m) {
    const months = [
      '', 'январь', 'февраль', 'март', 'апрель', 'май', 'июнь',
      'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь'
    ];
    return months[m];
  }
} 