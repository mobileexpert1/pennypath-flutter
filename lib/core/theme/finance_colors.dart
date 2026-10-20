import 'package:flutter/material.dart';

/// Semantic colours that Material's [ColorScheme] has no slot for.
@immutable
class FinanceColors extends ThemeExtension<FinanceColors> {
  const FinanceColors({
    required this.income,
    required this.expense,
    required this.incomeContainer,
    required this.expenseContainer,
  });

  static const light = FinanceColors(
    income: Color(0xFF16794C),
    expense: Color(0xFFC0362C),
    incomeContainer: Color(0xFFD6F5E3),
    expenseContainer: Color(0xFFFFE1DD),
  );

  static const dark = FinanceColors(
    income: Color(0xFF6FDBA4),
    expense: Color(0xFFFF8A7D),
    incomeContainer: Color(0xFF0F3D28),
    expenseContainer: Color(0xFF4A1A15),
  );

  final Color income;
  final Color expense;
  final Color incomeContainer;
  final Color expenseContainer;

  @override
  FinanceColors copyWith({
    Color? income,
    Color? expense,
    Color? incomeContainer,
    Color? expenseContainer,
  }) => FinanceColors(
    income: income ?? this.income,
    expense: expense ?? this.expense,
    incomeContainer: incomeContainer ?? this.incomeContainer,
    expenseContainer: expenseContainer ?? this.expenseContainer,
  );

  @override
  FinanceColors lerp(FinanceColors? other, double t) {
    if (other == null) return this;
    return FinanceColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      incomeContainer: Color.lerp(incomeContainer, other.incomeContainer, t)!,
      expenseContainer: Color.lerp(expenseContainer, other.expenseContainer, t)!,
    );
  }
}
