import 'package:isar_community/isar.dart';

abstract class BaseMinLocalDBService<TRemote, TLocal> {
  BaseMinLocalDBService({
    required Isar prfDBInstance,
  }) {
    _prfDBInstance = prfDBInstance;
  }

  late final Isar _prfDBInstance;

  // Access to the database instance
  Isar get dbInstance => _prfDBInstance;

  /// Convert remote model to local model
  TLocal remoteToLocal(TRemote remote);

  /// Get the Isar collection for this entity type
  IsarCollection<TLocal> get collection;

  // Common database operations

  /// Persist a list of remote entities to local database
  Future<void> persistEntities(List<TRemote> remoteEntities) async {
    await dbInstance.writeTxn(() async {
      final localEntities = remoteEntities.map(remoteToLocal).toList();
      await collection.putAll(localEntities);
    });
  }

  /// Persist a single remote entity to local database
  Future<void> persistEntity(TRemote remoteEntity) async {
    await dbInstance.writeTxn(() async {
      final localEntity = remoteToLocal(remoteEntity);
      await collection.put(localEntity);
    });
  }

  /// Delete entity by primary key - Example implementation.
  /// You should override this in your subclass with the correct entity query.
  /// Example:
  /// ```dart
  /// @override
  /// Future<void> deleteByKey(String key) async {
  ///   await dbInstance.writeTxn(() async {
  ///     await collection.where().ulidEqualTo(key).deleteFirst(); // Replace with your actual field
  ///   });
  /// }
  /// ```
  Future<void> deleteByKey(String key) async {
    throw UnimplementedError(
      'deleteByKey must be implemented in subclasses',
    );
  }
}
