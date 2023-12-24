import 'package:dev_socmed/core/utils/config/config_env.dart';
import 'package:mysql_client/mysql_client.dart';

/// creating a database connection with MySQL
class MySQLClient{
  /// Returns a singleton
  factory MySQLClient() {
    return _inst;
  }

  MySQLClient._internal() {
    _connect();
  }

  static final MySQLClient _inst = MySQLClient._internal();

  MySQLConnection? _connection;

  // initializes a connection to database
  Future<void> _connect() async {
    _connection = await MySQLConnection.createConnection(
      // "localhost" OR 127.0.0.1
      host: '${ConfigEnv.dbHost}',
      // Your MySQL port
      port: ConfigEnv.dbPort ?? 8000,
      // MySQL userName
      userName: '${ConfigEnv.dbUsername}',
      // MySQL Database password
      password: '${ConfigEnv.dbPassword}',
      // your database name
      databaseName: '${ConfigEnv.dbName}',
      // false - if your are not using SSL - otherwise it will through an error
      // secure: false,
    );
    await _connection?.connect();
  }

  /// execute a given query and checks for db connection
  Future<IResultSet?> execute(
    String query, {
    Map<String, dynamic>? params,
    bool iterable = false,
  }) async {
    if (_connection == null || _connection?.connected == false) {
      await _connect();
    }

    if (_connection?.connected == false) {
      throw Exception('Could not connect to the database');
    }
    return _connection?.execute(query, params, iterable);
  }
}
