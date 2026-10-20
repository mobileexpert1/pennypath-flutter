// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Pennypath';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get errorNetwork => 'Du bist offline. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get errorUnauthorized => 'Deine Sitzung ist abgelaufen. Bitte melde dich erneut an.';

  @override
  String get errorInvalidCredentials => 'E-Mail oder Passwort ist falsch.';

  @override
  String get errorEmailInUse => 'Mit dieser E-Mail gibt es bereits ein Konto.';

  @override
  String get errorNotFound => 'Dieser Eintrag wurde nicht gefunden.';

  @override
  String get errorServer => 'Bei uns ist etwas schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get errorStorage => 'Auf die Daten dieses Geräts konnte nicht zugegriffen werden.';

  @override
  String get errorUnexpected => 'Etwas Unerwartetes ist passiert.';

  @override
  String get errorValidation => 'Bitte korrigiere die markierten Felder.';

  @override
  String get nameRequired => 'Gib deinen Namen ein';

  @override
  String get emailRequired => 'Gib deine E-Mail ein';

  @override
  String get emailInvalid => 'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get passwordRequired => 'Gib dein Passwort ein';

  @override
  String passwordTooShort(int min) {
    return 'Mindestens $min Zeichen verwenden';
  }

  @override
  String get passwordTooWeak => 'Verwende Buchstaben und Zahlen';

  @override
  String get amountRequired => 'Gib einen Betrag ein';

  @override
  String get amountNotPositive => 'Der Betrag muss größer als null sein';

  @override
  String get amountTooLarge => 'Dieser Betrag ist zu hoch';

  @override
  String get titleRequired => 'Gib einen Titel ein';

  @override
  String titleTooLong(int max) {
    return 'Der Titel darf höchstens $max Zeichen haben';
  }

  @override
  String noteTooLong(int max) {
    return 'Die Notiz darf höchstens $max Zeichen haben';
  }

  @override
  String get dateInFuture => 'Das Datum darf nicht in der Zukunft liegen';

  @override
  String get categoryMismatch => 'Wähle eine passende Kategorie';

  @override
  String get authHeadline => 'Behalte dein Geld im Griff';

  @override
  String get authSignInSubtitle => 'Melde dich an, um fortzufahren';

  @override
  String get authSignUpSubtitle => 'Erstelle dein kostenloses Konto';

  @override
  String get authName => 'Vollständiger Name';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authSignUp => 'Konto erstellen';

  @override
  String get authSwitchToSignUp => 'Neu hier? Konto erstellen';

  @override
  String get authSwitchToSignIn => 'Schon ein Konto? Anmelden';

  @override
  String get authDemoTitle => 'Demo-Modus';

  @override
  String get authDemoBody =>
      'Läuft mit einem integrierten Mock-Server. Nutze das Demo-Konto oder erstelle ein eigenes.';

  @override
  String get authUseDemo => 'Demo-Konto verwenden';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get navOverview => 'Übersicht';

  @override
  String get navTransactions => 'Buchungen';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String dashboardGreeting(String name) {
    return 'Hallo, $name';
  }

  @override
  String get dashboardBalance => 'Gesamtsaldo';

  @override
  String get dashboardThisMonth => 'Dieser Monat';

  @override
  String get dashboardSpending => 'Ausgaben nach Kategorie';

  @override
  String get dashboardNoSpending => 'Diesen Monat noch keine Ausgaben';

  @override
  String get dashboardRecent => 'Letzte Aktivitäten';

  @override
  String get emptyTitle => 'Noch keine Buchungen';

  @override
  String get emptyBody =>
      'Füge deine erste Einnahme oder Ausgabe hinzu, um deine Übersicht zu sehen.';

  @override
  String get addTransaction => 'Buchung hinzufügen';

  @override
  String get searchHint => 'Buchungen durchsuchen';

  @override
  String get filterAll => 'Alle';

  @override
  String get typeIncome => 'Einnahmen';

  @override
  String get typeExpense => 'Ausgaben';

  @override
  String get noResultsTitle => 'Keine Treffer';

  @override
  String get noResultsBody => 'Versuche eine andere Suche oder einen anderen Filter.';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get transactionDeleted => 'Buchung gelöscht';

  @override
  String get transactionSaved => 'Buchung gespeichert';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get formNewTitle => 'Neue Buchung';

  @override
  String get formEditTitle => 'Buchung bearbeiten';

  @override
  String get formAmount => 'Betrag';

  @override
  String get formTitle => 'Titel';

  @override
  String get formTitleHint => 'z. B. Wocheneinkauf';

  @override
  String get formCategory => 'Kategorie';

  @override
  String get formDate => 'Datum';

  @override
  String get formNote => 'Notiz (optional)';

  @override
  String get deleteConfirmTitle => 'Diese Buchung löschen?';

  @override
  String get deleteConfirmBody => 'Sie wird von allen deinen Geräten entfernt.';

  @override
  String get categorySalary => 'Gehalt';

  @override
  String get categoryFreelance => 'Freiberuflich';

  @override
  String get categoryInvestment => 'Investitionen';

  @override
  String get categoryGift => 'Geschenke';

  @override
  String get categoryOtherIncome => 'Sonstige Einnahmen';

  @override
  String get categoryFood => 'Essen gehen';

  @override
  String get categoryGroceries => 'Lebensmittel';

  @override
  String get categoryTransport => 'Verkehr';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHousing => 'Wohnen';

  @override
  String get categoryUtilities => 'Rechnungen';

  @override
  String get categoryEntertainment => 'Freizeit';

  @override
  String get categoryHealth => 'Gesundheit';

  @override
  String get categoryTravel => 'Reisen';

  @override
  String get categoryOtherExpense => 'Sonstiges';

  @override
  String syncOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline · $count Änderungen werden später synchronisiert',
      one: 'Offline · 1 Änderung wird später synchronisiert',
      zero: 'Offline · gespeicherte Daten',
    );
    return '$_temp0';
  }

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsTheme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get settingsCurrency => 'Währung';

  @override
  String get settingsSecurity => 'Sicherheit';

  @override
  String get settingsAppLock => 'App-Sperre';

  @override
  String get settingsAppLockSubtitle => 'Face ID, Fingerabdruck oder Geräte-PIN verlangen';

  @override
  String get settingsAppLockUnavailable => 'Auf diesem Gerät nicht verfügbar';

  @override
  String get settingsDeveloper => 'Entwickler';

  @override
  String get settingsSimulateOffline => 'Offline simulieren';

  @override
  String get settingsSimulateOfflineSubtitle => 'Der Mock-Server antwortet nicht mehr';

  @override
  String get settingsSyncNow => 'Jetzt synchronisieren';

  @override
  String settingsLastSynced(String time) {
    return 'Zuletzt synchronisiert: $time';
  }

  @override
  String get settingsNeverSynced => 'Noch nicht synchronisiert';

  @override
  String get settingsAbout => 'Info';

  @override
  String get settingsBackend => 'Backend';

  @override
  String get settingsEnvironment => 'Umgebung';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutConfirmTitle => 'Abmelden?';

  @override
  String get signOutConfirmBody =>
      'Die Daten auf diesem Gerät werden entfernt. Nicht synchronisierte Änderungen werden vorher hochgeladen, wenn möglich.';

  @override
  String get lockTitle => 'Pennypath ist gesperrt';

  @override
  String get lockBody => 'Entsperre, um deine Finanzen zu sehen.';

  @override
  String get lockUnlock => 'Entsperren';

  @override
  String get lockReason => 'Pennypath entsperren';

  @override
  String get enableLockReason => 'Bestätige, um die App-Sperre zu aktivieren';
}
