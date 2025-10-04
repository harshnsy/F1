import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

class DB {
  static late PostgreSQLConnection conn;

  static Future<void> init() async {
    var env = DotEnv(includePlatformEnvironment: true)..load();
    final url = env['DATABASE_URL'];

    if (url == null) throw Exception("DATABASE_URL not set");

    final uri = Uri.parse(url);
    conn = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':')[0],
      password: uri.userInfo.split(':')[1],
    );
    await conn.open();
    print('✅ Connected to Postgres');
  }
}