import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/utils/money_formatter.dart';
import '../../features/settings/presentation/controllers/settings_controller.dart';

final _moneyFormatterProvider = Provider.family<MoneyFormatter, String>(
  (ref, locale) => MoneyFormatter(
    locale: locale,
    currencyCode: ref.watch(settingsControllerProvider.select((s) => s.currencyCode)),
  ),
);

extension MoneyFormatterRef on WidgetRef {
  /// Cached per locale; rebuilds the caller when the currency changes.
  MoneyFormatter money(BuildContext context) => watch(_moneyFormatterProvider(context.localeName));

  /// For callbacks and lifecycle methods, where watching is not allowed.
  MoneyFormatter readMoney(BuildContext context) =>
      read(_moneyFormatterProvider(context.localeName));
}
