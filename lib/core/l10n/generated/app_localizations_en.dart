// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Pennypath';

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get seeAll => 'See all';

  @override
  String get errorNetwork => 'You\'re offline. Check your connection and try again.';

  @override
  String get errorUnauthorized => 'Your session has expired. Please sign in again.';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorEmailInUse => 'An account with this email already exists.';

  @override
  String get errorNotFound => 'We couldn\'t find that item.';

  @override
  String get errorServer => 'Something went wrong on our side. Please try again.';

  @override
  String get errorStorage => 'Couldn\'t access data on this device.';

  @override
  String get errorUnexpected => 'Something unexpected happened.';

  @override
  String get errorValidation => 'Please fix the highlighted fields.';

  @override
  String get nameRequired => 'Enter your name';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String passwordTooShort(int min) {
    return 'Use at least $min characters';
  }

  @override
  String get passwordTooWeak => 'Use both letters and numbers';

  @override
  String get amountRequired => 'Enter an amount';

  @override
  String get amountNotPositive => 'Amount must be greater than zero';

  @override
  String get amountTooLarge => 'That amount is too large';

  @override
  String get titleRequired => 'Enter a title';

  @override
  String titleTooLong(int max) {
    return 'Keep the title under $max characters';
  }

  @override
  String noteTooLong(int max) {
    return 'Keep the note under $max characters';
  }

  @override
  String get dateInFuture => 'Date can\'t be in the future';

  @override
  String get categoryMismatch => 'Choose a category that matches the type';

  @override
  String get authHeadline => 'Take control of your money';

  @override
  String get authSignInSubtitle => 'Sign in to continue';

  @override
  String get authSignUpSubtitle => 'Create your free account';

  @override
  String get authName => 'Full name';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUp => 'Create account';

  @override
  String get authSwitchToSignUp => 'New here? Create an account';

  @override
  String get authSwitchToSignIn => 'Already have an account? Sign in';

  @override
  String get authDemoTitle => 'Demo mode';

  @override
  String get authDemoBody =>
      'Runs on a built-in mock server. Use the demo account or create your own.';

  @override
  String get authUseDemo => 'Use demo account';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get navOverview => 'Overview';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navSettings => 'Settings';

  @override
  String dashboardGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get dashboardBalance => 'Total balance';

  @override
  String get dashboardThisMonth => 'This month';

  @override
  String get dashboardSpending => 'Spending by category';

  @override
  String get dashboardNoSpending => 'No spending this month yet';

  @override
  String get dashboardRecent => 'Recent activity';

  @override
  String get emptyTitle => 'No transactions yet';

  @override
  String get emptyBody => 'Add your first income or expense to see your overview.';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get searchHint => 'Search transactions';

  @override
  String get filterAll => 'All';

  @override
  String get typeIncome => 'Income';

  @override
  String get typeExpense => 'Expenses';

  @override
  String get noResultsTitle => 'No matches';

  @override
  String get noResultsBody => 'Try a different search or filter.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionSaved => 'Transaction saved';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get formNewTitle => 'New transaction';

  @override
  String get formEditTitle => 'Edit transaction';

  @override
  String get formAmount => 'Amount';

  @override
  String get formTitle => 'Title';

  @override
  String get formTitleHint => 'e.g. Weekly groceries';

  @override
  String get formCategory => 'Category';

  @override
  String get formDate => 'Date';

  @override
  String get formNote => 'Note (optional)';

  @override
  String get deleteConfirmTitle => 'Delete this transaction?';

  @override
  String get deleteConfirmBody => 'It will be removed from all your devices.';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get categoryInvestment => 'Investments';

  @override
  String get categoryGift => 'Gifts';

  @override
  String get categoryOtherIncome => 'Other income';

  @override
  String get categoryFood => 'Eating out';

  @override
  String get categoryGroceries => 'Groceries';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categoryUtilities => 'Bills & utilities';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get categoryOtherExpense => 'Other';

  @override
  String syncOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline · $count changes will sync later',
      one: 'Offline · 1 change will sync later',
      zero: 'Offline · showing saved data',
    );
    return '$_temp0';
  }

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsAppLock => 'App lock';

  @override
  String get settingsAppLockSubtitle => 'Require Face ID, fingerprint or device PIN';

  @override
  String get settingsAppLockUnavailable => 'Not available on this device';

  @override
  String get settingsDeveloper => 'Developer';

  @override
  String get settingsSimulateOffline => 'Simulate offline';

  @override
  String get settingsSimulateOfflineSubtitle => 'The mock server stops responding';

  @override
  String get settingsSyncNow => 'Sync now';

  @override
  String settingsLastSynced(String time) {
    return 'Last synced $time';
  }

  @override
  String get settingsNeverSynced => 'Not synced yet';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsBackend => 'Backend';

  @override
  String get settingsEnvironment => 'Environment';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmBody =>
      'Data on this device will be removed. Unsynced changes are uploaded first when possible.';

  @override
  String get lockTitle => 'Pennypath is locked';

  @override
  String get lockBody => 'Unlock to view your finances.';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get lockReason => 'Unlock Pennypath';

  @override
  String get enableLockReason => 'Confirm to turn on app lock';
}
