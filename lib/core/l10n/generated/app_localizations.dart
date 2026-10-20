import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en'), Locale('es')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Pennypath'**
  String get appName;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get errorEmailInUse;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that item.'**
  String get errorNotFound;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again.'**
  String get errorServer;

  /// No description provided for @errorStorage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t access data on this device.'**
  String get errorStorage;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened.'**
  String get errorUnexpected;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted fields.'**
  String get errorValidation;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least {min} characters'**
  String passwordTooShort(int min);

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'Use both letters and numbers'**
  String get passwordTooWeak;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get amountRequired;

  /// No description provided for @amountNotPositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get amountNotPositive;

  /// No description provided for @amountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That amount is too large'**
  String get amountTooLarge;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get titleRequired;

  /// No description provided for @titleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Keep the title under {max} characters'**
  String titleTooLong(int max);

  /// No description provided for @noteTooLong.
  ///
  /// In en, this message translates to:
  /// **'Keep the note under {max} characters'**
  String noteTooLong(int max);

  /// No description provided for @dateInFuture.
  ///
  /// In en, this message translates to:
  /// **'Date can\'t be in the future'**
  String get dateInFuture;

  /// No description provided for @categoryMismatch.
  ///
  /// In en, this message translates to:
  /// **'Choose a category that matches the type'**
  String get categoryMismatch;

  /// No description provided for @authHeadline.
  ///
  /// In en, this message translates to:
  /// **'Take control of your money'**
  String get authHeadline;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInSubtitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your free account'**
  String get authSignUpSubtitle;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authName;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignUp;

  /// No description provided for @authSwitchToSignUp.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get authSwitchToSignUp;

  /// No description provided for @authSwitchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authSwitchToSignIn;

  /// No description provided for @authDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get authDemoTitle;

  /// No description provided for @authDemoBody.
  ///
  /// In en, this message translates to:
  /// **'Runs on a built-in mock server. Use the demo account or create your own.'**
  String get authDemoBody;

  /// No description provided for @authUseDemo.
  ///
  /// In en, this message translates to:
  /// **'Use demo account'**
  String get authUseDemo;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get dashboardBalance;

  /// No description provided for @dashboardThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dashboardThisMonth;

  /// No description provided for @dashboardSpending.
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get dashboardSpending;

  /// No description provided for @dashboardNoSpending.
  ///
  /// In en, this message translates to:
  /// **'No spending this month yet'**
  String get dashboardNoSpending;

  /// No description provided for @dashboardRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashboardRecent;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first income or expense to see your overview.'**
  String get emptyBody;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @typeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get typeIncome;

  /// No description provided for @typeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get typeExpense;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noResultsTitle;

  /// No description provided for @noResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter.'**
  String get noResultsBody;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved'**
  String get transactionSaved;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @formNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get formNewTitle;

  /// No description provided for @formEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get formEditTitle;

  /// No description provided for @formAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get formAmount;

  /// No description provided for @formTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get formTitle;

  /// No description provided for @formTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekly groceries'**
  String get formTitleHint;

  /// No description provided for @formCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get formCategory;

  /// No description provided for @formDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get formDate;

  /// No description provided for @formNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get formNote;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from all your devices.'**
  String get deleteConfirmBody;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @categoryInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get categoryInvestment;

  /// No description provided for @categoryGift.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryGift;

  /// No description provided for @categoryOtherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other income'**
  String get categoryOtherIncome;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Eating out'**
  String get categoryFood;

  /// No description provided for @categoryGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get categoryGroceries;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get categoryHousing;

  /// No description provided for @categoryUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & utilities'**
  String get categoryUtilities;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryOtherExpense.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOtherExpense;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Offline · showing saved data} =1{Offline · 1 change will sync later} other{Offline · {count} changes will sync later}}'**
  String syncOffline(int count);

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get settingsAppLock;

  /// No description provided for @settingsAppLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require Face ID, fingerprint or device PIN'**
  String get settingsAppLockSubtitle;

  /// No description provided for @settingsAppLockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get settingsAppLockUnavailable;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsDeveloper;

  /// No description provided for @settingsSimulateOffline.
  ///
  /// In en, this message translates to:
  /// **'Simulate offline'**
  String get settingsSimulateOffline;

  /// No description provided for @settingsSimulateOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The mock server stops responding'**
  String get settingsSimulateOfflineSubtitle;

  /// No description provided for @settingsSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get settingsSyncNow;

  /// No description provided for @settingsLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String settingsLastSynced(String time);

  /// No description provided for @settingsNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get settingsNeverSynced;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsBackend.
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get settingsBackend;

  /// No description provided for @settingsEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get settingsEnvironment;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Data on this device will be removed. Unsynced changes are uploaded first when possible.'**
  String get signOutConfirmBody;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Pennypath is locked'**
  String get lockTitle;

  /// No description provided for @lockBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock to view your finances.'**
  String get lockBody;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// No description provided for @lockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pennypath'**
  String get lockReason;

  /// No description provided for @enableLockReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to turn on app lock'**
  String get enableLockReason;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
