import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/entities/transaction_category.dart';

extension TransactionCategoryStyle on TransactionCategory {
  IconData get icon => switch (this) {
    TransactionCategory.salary => Icons.work_outline_rounded,
    TransactionCategory.freelance => Icons.laptop_mac_rounded,
    TransactionCategory.investment => Icons.trending_up_rounded,
    TransactionCategory.gift => Icons.card_giftcard_rounded,
    TransactionCategory.otherIncome => Icons.add_card_rounded,
    TransactionCategory.food => Icons.restaurant_rounded,
    TransactionCategory.groceries => Icons.local_grocery_store_outlined,
    TransactionCategory.transport => Icons.directions_transit_rounded,
    TransactionCategory.shopping => Icons.shopping_bag_outlined,
    TransactionCategory.housing => Icons.home_outlined,
    TransactionCategory.utilities => Icons.receipt_long_outlined,
    TransactionCategory.entertainment => Icons.movie_outlined,
    TransactionCategory.health => Icons.favorite_outline_rounded,
    TransactionCategory.travel => Icons.flight_takeoff_rounded,
    TransactionCategory.otherExpense => Icons.more_horiz_rounded,
  };

  /// Mid-tone hues that read well on both light and dark surfaces.
  Color get color => switch (this) {
    TransactionCategory.salary => const Color(0xFF2E9E6A),
    TransactionCategory.freelance => const Color(0xFF3A8FB7),
    TransactionCategory.investment => const Color(0xFF7A6FD0),
    TransactionCategory.gift => const Color(0xFFD06FA8),
    TransactionCategory.otherIncome => const Color(0xFF4FA39A),
    TransactionCategory.food => const Color(0xFFE07A3F),
    TransactionCategory.groceries => const Color(0xFF6BA34F),
    TransactionCategory.transport => const Color(0xFF3F7FE0),
    TransactionCategory.shopping => const Color(0xFFD0558A),
    TransactionCategory.housing => const Color(0xFF8C6BD6),
    TransactionCategory.utilities => const Color(0xFFC9A227),
    TransactionCategory.entertainment => const Color(0xFFE05A5A),
    TransactionCategory.health => const Color(0xFF2FA7A0),
    TransactionCategory.travel => const Color(0xFF4C9BE8),
    TransactionCategory.otherExpense => const Color(0xFF8A8F98),
  };

  String label(AppLocalizations l10n) => switch (this) {
    TransactionCategory.salary => l10n.categorySalary,
    TransactionCategory.freelance => l10n.categoryFreelance,
    TransactionCategory.investment => l10n.categoryInvestment,
    TransactionCategory.gift => l10n.categoryGift,
    TransactionCategory.otherIncome => l10n.categoryOtherIncome,
    TransactionCategory.food => l10n.categoryFood,
    TransactionCategory.groceries => l10n.categoryGroceries,
    TransactionCategory.transport => l10n.categoryTransport,
    TransactionCategory.shopping => l10n.categoryShopping,
    TransactionCategory.housing => l10n.categoryHousing,
    TransactionCategory.utilities => l10n.categoryUtilities,
    TransactionCategory.entertainment => l10n.categoryEntertainment,
    TransactionCategory.health => l10n.categoryHealth,
    TransactionCategory.travel => l10n.categoryTravel,
    TransactionCategory.otherExpense => l10n.categoryOtherExpense,
  };
}
