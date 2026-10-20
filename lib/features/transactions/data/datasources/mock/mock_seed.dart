import 'dart:math';

import '../../../domain/entities/transaction_category.dart';
import '../../models/transaction_dto.dart';

/// Three months of realistic, deterministic demo data relative to [now].
List<TransactionDto> buildMockSeed(DateTime now) {
  final random = Random(42);
  final items = <TransactionDto>[];

  void add(
    DateTime date,
    TransactionCategory category,
    String title,
    int amountMinor, {
    String? note,
  }) {
    if (date.isAfter(now)) return;
    items.add(
      TransactionDto(
        id: 'seed-${items.length}',
        type: category.type.name,
        amountMinor: amountMinor,
        title: title,
        category: category.name,
        date: date,
        updatedAt: now.toUtc(),
        note: note,
      ),
    );
  }

  int around(int minor, double spread) =>
      (minor * (1 - spread + random.nextDouble() * spread * 2)).round();

  const groceries = ['Whole Foods', 'Trader Joe\'s', 'Farmers market'];
  const food = ['Blue Bottle Coffee', 'Sushi place', 'Pizza night', 'Lunch with team'];
  const fun = ['Cinema', 'Spotify', 'Concert tickets', 'Bookstore'];

  for (var m = 2; m >= 0; m--) {
    final month = DateTime(now.year, now.month - m);
    DateTime day(int d) => DateTime(month.year, month.month, d, 9 + random.nextInt(10));

    add(day(1), TransactionCategory.salary, 'Monthly salary', 520000);
    add(day(3), TransactionCategory.housing, 'Rent', 185000);
    add(day(5), TransactionCategory.utilities, 'Electricity & water', around(9500, 0.2));
    add(day(6), TransactionCategory.utilities, 'Internet', 4999);
    add(day(12), TransactionCategory.health, 'Gym membership', 3900);
    if (m != 1) {
      add(
        day(15),
        TransactionCategory.freelance,
        'Design project',
        around(85000, 0.3),
        note: 'Invoice #${1040 + m}',
      );
    }
    if (m == 1) add(day(20), TransactionCategory.travel, 'Weekend in Lisbon', 62000);
    if (m == 0) add(day(8), TransactionCategory.investment, 'ETF dividend', 3150);

    for (var week = 0; week < 4; week++) {
      add(
        day(2 + week * 7),
        TransactionCategory.groceries,
        groceries[random.nextInt(groceries.length)],
        around(8200, 0.35),
      );
      add(
        day(4 + week * 7),
        TransactionCategory.food,
        food[random.nextInt(food.length)],
        around(2600, 0.5),
      );
      add(day(6 + week * 7), TransactionCategory.transport, 'Metro card top-up', 3000);
    }
    add(
      day(10),
      TransactionCategory.entertainment,
      fun[random.nextInt(fun.length)],
      around(3500, 0.5),
    );
    add(day(18), TransactionCategory.shopping, 'New running shoes', around(11900, 0.2));
    add(day(25), TransactionCategory.food, 'Dinner with friends', around(6800, 0.3));
  }
  return items;
}
