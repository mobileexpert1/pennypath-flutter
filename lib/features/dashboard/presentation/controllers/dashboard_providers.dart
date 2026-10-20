import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/core_providers.dart';
import '../../../../app/di/transactions_providers.dart';
import '../../../transactions/presentation/controllers/transactions_providers.dart';
import '../../domain/entities/dashboard_summary.dart';

final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final compute = ref.watch(computeDashboardSummaryProvider);
  final now = ref.watch(clockProvider)();
  return ref.watch(transactionsProvider).whenData((all) => compute(all, now));
});
