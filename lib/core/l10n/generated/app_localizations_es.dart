// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Pennypath';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get undo => 'Deshacer';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get errorNetwork => 'Estás sin conexión. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get errorUnauthorized => 'Tu sesión ha caducado. Inicia sesión de nuevo.';

  @override
  String get errorInvalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get errorEmailInUse => 'Ya existe una cuenta con este correo.';

  @override
  String get errorNotFound => 'No encontramos ese elemento.';

  @override
  String get errorServer => 'Algo salió mal por nuestra parte. Inténtalo de nuevo.';

  @override
  String get errorStorage => 'No se pudo acceder a los datos de este dispositivo.';

  @override
  String get errorUnexpected => 'Ocurrió un error inesperado.';

  @override
  String get errorValidation => 'Corrige los campos marcados.';

  @override
  String get nameRequired => 'Introduce tu nombre';

  @override
  String get emailRequired => 'Introduce tu correo';

  @override
  String get emailInvalid => 'Introduce un correo válido';

  @override
  String get passwordRequired => 'Introduce tu contraseña';

  @override
  String passwordTooShort(int min) {
    return 'Usa al menos $min caracteres';
  }

  @override
  String get passwordTooWeak => 'Usa letras y números';

  @override
  String get amountRequired => 'Introduce un importe';

  @override
  String get amountNotPositive => 'El importe debe ser mayor que cero';

  @override
  String get amountTooLarge => 'Ese importe es demasiado alto';

  @override
  String get titleRequired => 'Introduce un título';

  @override
  String titleTooLong(int max) {
    return 'El título debe tener menos de $max caracteres';
  }

  @override
  String noteTooLong(int max) {
    return 'La nota debe tener menos de $max caracteres';
  }

  @override
  String get dateInFuture => 'La fecha no puede ser futura';

  @override
  String get categoryMismatch => 'Elige una categoría acorde al tipo';

  @override
  String get authHeadline => 'Toma el control de tu dinero';

  @override
  String get authSignInSubtitle => 'Inicia sesión para continuar';

  @override
  String get authSignUpSubtitle => 'Crea tu cuenta gratuita';

  @override
  String get authName => 'Nombre completo';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSignUp => 'Crear cuenta';

  @override
  String get authSwitchToSignUp => '¿Eres nuevo? Crea una cuenta';

  @override
  String get authSwitchToSignIn => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authDemoTitle => 'Modo demo';

  @override
  String get authDemoBody =>
      'Funciona con un servidor simulado integrado. Usa la cuenta demo o crea la tuya.';

  @override
  String get authUseDemo => 'Usar cuenta demo';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get navOverview => 'Resumen';

  @override
  String get navTransactions => 'Movimientos';

  @override
  String get navSettings => 'Ajustes';

  @override
  String dashboardGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get dashboardBalance => 'Saldo total';

  @override
  String get dashboardThisMonth => 'Este mes';

  @override
  String get dashboardSpending => 'Gastos por categoría';

  @override
  String get dashboardNoSpending => 'Aún no hay gastos este mes';

  @override
  String get dashboardRecent => 'Actividad reciente';

  @override
  String get emptyTitle => 'Aún no hay movimientos';

  @override
  String get emptyBody => 'Añade tu primer ingreso o gasto para ver tu resumen.';

  @override
  String get addTransaction => 'Añadir movimiento';

  @override
  String get searchHint => 'Buscar movimientos';

  @override
  String get filterAll => 'Todos';

  @override
  String get typeIncome => 'Ingresos';

  @override
  String get typeExpense => 'Gastos';

  @override
  String get noResultsTitle => 'Sin resultados';

  @override
  String get noResultsBody => 'Prueba otra búsqueda o filtro.';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get transactionDeleted => 'Movimiento eliminado';

  @override
  String get transactionSaved => 'Movimiento guardado';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get formNewTitle => 'Nuevo movimiento';

  @override
  String get formEditTitle => 'Editar movimiento';

  @override
  String get formAmount => 'Importe';

  @override
  String get formTitle => 'Título';

  @override
  String get formTitleHint => 'p. ej. Compra semanal';

  @override
  String get formCategory => 'Categoría';

  @override
  String get formDate => 'Fecha';

  @override
  String get formNote => 'Nota (opcional)';

  @override
  String get deleteConfirmTitle => '¿Eliminar este movimiento?';

  @override
  String get deleteConfirmBody => 'Se eliminará de todos tus dispositivos.';

  @override
  String get categorySalary => 'Salario';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get categoryInvestment => 'Inversiones';

  @override
  String get categoryGift => 'Regalos';

  @override
  String get categoryOtherIncome => 'Otros ingresos';

  @override
  String get categoryFood => 'Restaurantes';

  @override
  String get categoryGroceries => 'Supermercado';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryHousing => 'Vivienda';

  @override
  String get categoryUtilities => 'Facturas';

  @override
  String get categoryEntertainment => 'Ocio';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryTravel => 'Viajes';

  @override
  String get categoryOtherExpense => 'Otros';

  @override
  String syncOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sin conexión · $count cambios se sincronizarán',
      one: 'Sin conexión · 1 cambio se sincronizará',
      zero: 'Sin conexión · mostrando datos guardados',
    );
    return '$_temp0';
  }

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get settingsSecurity => 'Seguridad';

  @override
  String get settingsAppLock => 'Bloqueo de la app';

  @override
  String get settingsAppLockSubtitle => 'Pide Face ID, huella o PIN del dispositivo';

  @override
  String get settingsAppLockUnavailable => 'No disponible en este dispositivo';

  @override
  String get settingsDeveloper => 'Desarrollador';

  @override
  String get settingsSimulateOffline => 'Simular sin conexión';

  @override
  String get settingsSimulateOfflineSubtitle => 'El servidor simulado deja de responder';

  @override
  String get settingsSyncNow => 'Sincronizar ahora';

  @override
  String settingsLastSynced(String time) {
    return 'Última sincronización: $time';
  }

  @override
  String get settingsNeverSynced => 'Aún no sincronizado';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsBackend => 'Backend';

  @override
  String get settingsEnvironment => 'Entorno';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signOutConfirmTitle => '¿Cerrar sesión?';

  @override
  String get signOutConfirmBody =>
      'Se eliminarán los datos de este dispositivo. Los cambios pendientes se subirán antes si es posible.';

  @override
  String get lockTitle => 'Pennypath está bloqueada';

  @override
  String get lockBody => 'Desbloquea para ver tus finanzas.';

  @override
  String get lockUnlock => 'Desbloquear';

  @override
  String get lockReason => 'Desbloquear Pennypath';

  @override
  String get enableLockReason => 'Confirma para activar el bloqueo';
}
