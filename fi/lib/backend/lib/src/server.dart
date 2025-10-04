import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'db.dart';
import 'router.dart';
import 'cors.dart'; // import your corsHeaders middleware

class ExpenseServer {
  Future<void> start(int port) async {
    await DB.init();

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(corsHeaders()) // <- CORS added
        .addHandler(buildRouter());

    final server = await serve(handler, InternetAddress.anyIPv4, port);
    print('🚀 Server running on http://${server.address.host}:${server.port}');
  }
}
