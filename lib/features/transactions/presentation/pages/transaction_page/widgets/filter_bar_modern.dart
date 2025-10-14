import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../../bloc/filter/filter_state.dart';

typedef OnApplyFilter = void Function(FilterState state);

class FilterBarModern extends StatefulWidget {
  final FilterState current;
  final OnApplyFilter onApply;
  final VoidCallback onClear;
  final List<String> categories;
  const FilterBarModern({
    super.key,
    required this.current,
    required this.onApply,
    required this.onClear,
    this.categories = const [],
  });

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

  void _applyInstantly() {
    widget.onApply(
      FilterState(
        type: _type,
        dateStart: _start,
        dateEnd: _end,
        category: _category,
        search: _search,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uniqueCategories = widget.categories.toSet().toList();

    if (_category != null && !uniqueCategories.contains(_category)) {
      _category = null;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // transaction_types:
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<TransactionType?>(
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            segments: const [
              ButtonSegment(
                value: null,
                label: Text('All'),
                icon: Icon(Icons.list_alt_rounded),
              ),
              ButtonSegment(
                value: TransactionType.income,
                label: Text('Income'),
                icon: Icon(Icons.arrow_downward_rounded),
              ),
              ButtonSegment(
                value: TransactionType.expense,
                label: Text('Expense'),
                icon: Icon(Icons.arrow_upward_rounded),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) {
              setState(() => _type = s.first);
              _applyInstantly();
            },
          ),
        ),
        SizedBox(height: 14.h),

        Row(
          spacing: 8.w,
          children: [
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final r = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(now.year - 5),
                      lastDate: DateTime(now.year + 5),
                      initialDateRange: _start != null && _end != null
                          ? DateTimeRange(start: _start!, end: _end!)
                          : null,
                    );
                    if (r != null) {
                      setState(() {
                        _start = r.start;
                        _end = r.end;
                      });
                      _applyInstantly();
                    }
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/calendar.svg",
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryText,
                      BlendMode.srcIn,
                    ),
                  ),

                  label: Text(
                    _start == null
                        ? 'Date range'
                        : '${_start!.day}/${_start!.month} - ${_end!.day}/${_end!.month}',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: DropdownButtonFormField<String?>(
                  value: _category,
                  isExpanded: true,
                  decoration:  InputDecoration(
                    prefixIcon: const Icon(Icons.category_outlined),
                    labelText: 'Category',
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                  ),
                  items: <String>{'All', ...uniqueCategories}
                      .map(
                        (c) => DropdownMenuItem<String?>(
                      value: c == 'All' ? null : c,
                      child: Text(c),
                    ),
                  )
                      .toList(),
                  onChanged: (v) {
                    setState(() => _category = v);
                    _applyInstantly();
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search ...',
          ),
          onChanged: (v) {
            _search = v.trim().isEmpty ? null : v.trim();
            _applyInstantly();
          },
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: widget.onClear,
            icon: const Icon(Icons.clear),
            label: const Text('Clear filters'),
          ),
        ),
      ],
    );
  }
}

