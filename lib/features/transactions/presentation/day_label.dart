import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';

String dayLabel(BuildContext context, DateTime day, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final difference = today.difference(DateTime(day.year, day.month, day.day)).inDays;
  if (difference == 0) return context.l10n.today;
  if (difference == 1) return context.l10n.yesterday;
  return DateFormat.MMMMEEEEd(context.localeName).format(day);
}
