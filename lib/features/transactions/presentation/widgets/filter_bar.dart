import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/transaction_entity.dart';
import '../bloc/filter/filter_state.dart';

typedef OnApplyFilter = void Function(FilterState state);

class FilterBar extends StatefulWidget {
  final FilterState current;
  final OnApplyFilter onApply;
  final VoidCallback onClear;
  const FilterBar({super.key, required this.current, required this.onApply, required this.onClear});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  TransactionType? _type;
  DateTime? _start;
  DateTime? _end;
  String? _category;
  String? _search;

  @override
  void initState() {
    super.initState();
    _type = widget.current.type;
    _start = widget.current.dateStart;
    _end = widget.current.dateEnd;
    _category = widget.current.category;
    _search = widget.current.search;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropdownButton<TransactionType?>(
              value: _type,
              hint: const Text('All types'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: TransactionType.income, child: Text('Income')),
                DropdownMenuItem(value: TransactionType.expense, child: Text('Expense')),
              ],
              onChanged: (v) => setState(() => _type = v),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                final now = DateTime.now();
                final r = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(now.year - 5),
                  lastDate: DateTime(now.year + 5),
                  initialDateRange: _start != null && _end != null ? DateTimeRange(start: _start!, end: _end!) : null,
                );
                if (r != null) setState(() {
                  _start = r.start;
                  _end = r.end;
                });
              },
              icon: Icon(Icons.date_range, size: 18.sp),
              label: Text(_start == null ? 'Date range' : '${_start!.day}/${_start!.month} - ${_end!.day}/${_end!.month}'),
            ),
            SizedBox(
              width: 160.w,
              child: TextField(
                decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(), labelText: 'Category'),
                onChanged: (v) => _category = v.trim().isEmpty ? null : v.trim(),
              ),
            ),
            SizedBox(
              width: 180.w,
              child: TextField(
                decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(), labelText: 'Search'),
                onChanged: (v) => _search = v.trim().isEmpty ? null : v.trim(),
              ),
            ),
            FilledButton(
              onPressed: () => widget.onApply(FilterState(type: _type, dateStart: _start, dateEnd: _end, category: _category, search: _search)),
              child: const Text('Apply'),
            ),
            TextButton(onPressed: widget.onClear, child: const Text('Clear')),
          ],
        ),
      ],
    );
  }
}
