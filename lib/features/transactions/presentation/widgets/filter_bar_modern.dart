import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../bloc/filter/filter_state.dart';

typedef OnApplyFilter = void Function(FilterState state);

/// Modern filter bar with segmented type selector, date range, category dropdown and search
class FilterBarModern extends StatefulWidget {
  final FilterState current;
  final OnApplyFilter onApply;
  final VoidCallback onClear;
  final List<String> categories;
  const FilterBarModern({super.key, required this.current, required this.onApply, required this.onClear, this.categories = const []});

  @override
  State<FilterBarModern> createState() => _FilterBarModernState();
}

class _FilterBarModernState extends State<FilterBarModern> {
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
        // Segmented toggle for type
        SegmentedButton<TransactionType?>(
          style: ButtonStyle(visualDensity: VisualDensity.compact, shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)))),
          segments: [
            ButtonSegment(value: null, label: Text('All', style: TextStyle(fontSize: 12.sp)), icon: Icon(PhosphorIcons.regular.rows, size: 16.sp)),
            ButtonSegment(value: TransactionType.income, label: Text('Income', style: TextStyle(fontSize: 12.sp)), icon: Icon(PhosphorIcons.regular.arrowDown, size: 16.sp)),
            ButtonSegment(value: TransactionType.expense, label: Text('Expense', style: TextStyle(fontSize: 12.sp)), icon: Icon(PhosphorIcons.regular.arrowUp, size: 16.sp)),
          ],
          selected: {_type},
          onSelectionChanged: (s) => setState(() => _type = s.first),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
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
                icon: Icon(PhosphorIcons.regular.calendar, size: 18.sp),
                label: Text(_start == null ? 'Date range' : '${_start!.day}/${_start!.month} - ${_end!.day}/${_end!.month}'),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: DropdownButtonFormField<String?>(
                value: _category,
                isExpanded: true,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined), labelText: 'Category'),
                items: <String>['All', ...widget.categories]
                    .toSet()
                    .map((c) => DropdownMenuItem<String?>(value: c == 'All' ? null : c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          decoration: InputDecoration(prefixIcon: Icon(PhosphorIcons.regular.magnifyingGlass, size: 18.sp), labelText: 'Search'),
          onChanged: (v) => _search = v.trim().isEmpty ? null : v.trim(),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            FilledButton(onPressed: () => widget.onApply(FilterState(type: _type, dateStart: _start, dateEnd: _end, category: _category, search: _search)), child: const Text('Apply')),
            SizedBox(width: 8.w),
            TextButton(onPressed: widget.onClear, child: const Text('Clear')),
          ],
        )
      ],
    );
  }
}
