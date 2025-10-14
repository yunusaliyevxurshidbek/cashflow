class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database error']);

  @override
  String toString() => 'DatabaseException: $message';
}

