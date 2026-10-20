typedef JsonMap = Map<String, dynamic>;

/// A document collection. Implementations can be Hive, Drift, Isar, etc.
abstract interface class LocalCollection {
  Future<JsonMap?> get(String id);
  Future<List<JsonMap>> getAll();
  Future<void> put(String id, JsonMap value);
  Future<void> delete(String id);
  Future<void> clear();

  /// Emits whenever the collection changes.
  Stream<void> watch();
}

abstract interface class LocalDatabase {
  Future<LocalCollection> collection(String name);
}
