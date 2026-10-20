import 'package:equatable/equatable.dart';

class SyncState extends Equatable {
  const SyncState({
    this.isSyncing = false,
    this.isOffline = false,
    this.pendingChanges = 0,
    this.lastSyncedAt,
  });

  final bool isSyncing;
  final bool isOffline;
  final int pendingChanges;
  final DateTime? lastSyncedAt;

  SyncState copyWith({
    bool? isSyncing,
    bool? isOffline,
    int? pendingChanges,
    DateTime? lastSyncedAt,
  }) => SyncState(
    isSyncing: isSyncing ?? this.isSyncing,
    isOffline: isOffline ?? this.isOffline,
    pendingChanges: pendingChanges ?? this.pendingChanges,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
  );

  @override
  List<Object?> get props => [isSyncing, isOffline, pendingChanges, lastSyncedAt];
}
