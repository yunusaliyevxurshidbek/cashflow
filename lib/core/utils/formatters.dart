import 'package:intl/intl.dart';

final DateFormat kDisplayDateFormat = DateFormat('dd MMM yyyy');
final NumberFormat kCurrencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);

String formatDate(DateTime date) => kDisplayDateFormat.format(date);
String formatAmount(double amount) => kCurrencyFormat.format(amount);

