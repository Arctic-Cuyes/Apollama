import 'package:intl/intl.dart';

class RelativeTime {
  static String format(DateTime date, {bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if (difference.inDays > 7 || !numericDates) {
      return DateFormat.yMMMd().format(date);
    }
    if (difference.inDays == 1) {
      return 'Ayer';
    }
    
    if (difference.inDays >= 1) {
      return 'Hace ${difference.inDays} días';
    }
    
    if (difference.inHours >= 1) {
      return 'Hace ${difference.inHours} hora${(difference.inHours > 1 ? "s" : "")}';
    }
    if (difference.inMinutes >= 1) {
      return 'Hace ${difference.inMinutes} minuto${(difference.inMinutes > 1 ? "s" : "")}';
    }
    return 'Hace un momento';
  }
}