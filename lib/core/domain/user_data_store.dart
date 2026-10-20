/// Implemented by repositories that hold data belonging to the signed-in user.
abstract interface class UserDataStore {
  /// Best-effort upload of local changes before the data is wiped.
  Future<void> flush();

  Future<void> clearUserData();
}
