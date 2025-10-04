import 'package:dotenv/dotenv.dart';
import 'package:expense_manager/src/server.dart';

void main(List<String> args) async {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  final port = int.parse(env['PORT'] ?? '8080');

  final server = ExpenseServer();
  await server.start(port);
}