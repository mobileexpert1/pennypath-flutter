import '../../../../../core/error/exceptions.dart';
import '../../../../../core/mock/mock_network.dart';
import '../../../../../core/storage/local_database.dart';
import '../../models/transaction_dto.dart';
import '../transaction_remote_data_source.dart';
import 'mock_seed.dart';

/// On-device fake server. Each user gets an isolated, persisted collection.
class TransactionMockDataSource implements TransactionRemoteDataSource {
  TransactionMockDataSource({
    required this._database,
    required this._network,
    required this._currentUserId,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final LocalDatabase _database;
  final MockNetwork _network;
  final Future<String?> Function() _currentUserId;
  final DateTime Function() _clock;

  @override
  Future<List<TransactionDto>> fetchAll() async {
    final server = await _serverCollection();
    return (await server.getAll()).map(TransactionDto.fromJson).toList();
  }

  @override
  Future<void> upsert(TransactionDto transaction) async =>
      (await _serverCollection()).put(transaction.id, transaction.toJson());

  @override
  Future<void> delete(String id) async => (await _serverCollection()).delete(id);

  Future<LocalCollection> _serverCollection() async {
    await _network.roundTrip();
    final userId = await _currentUserId();
    if (userId == null) throw const UnauthorizedException();

    final server = await _database.collection('mock_server_tx_$userId');
    final meta = await _database.collection('mock_server_meta');
    if (await meta.get(userId) == null) {
      for (final dto in buildMockSeed(_clock())) {
        await server.put(dto.id, dto.toJson());
      }
      await meta.put(userId, {'seeded': true});
    }
    return server;
  }
}
