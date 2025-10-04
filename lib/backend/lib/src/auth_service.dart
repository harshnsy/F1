import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:crypto/crypto.dart';
import 'db.dart';

/// Fetches company by name; creates it if it doesn't exist
Future<int> getOrCreateCompany(String name,
    {String country = 'Unknown', String currencyCode = 'USD'}) async {
  final selectResult = await DB.conn.query(
    'SELECT company_id FROM companies WHERE name = @name LIMIT 1',
    substitutionValues: {'name': name},
  );

  if (selectResult.isNotEmpty) {
    return selectResult.first[0] as int;
  }

  final insertResult = await DB.conn.query(
    '''
    INSERT INTO companies (name, country, currency_code)
    VALUES (@name, @country, @currency)
    RETURNING company_id
    ''',
    substitutionValues: {
      'name': name,
      'country': country,
      'currency': currencyCode,
    },
  );

  return insertResult.first[0] as int;
}

class AuthService {
  static Future<Response> signup(Request req) async {
    try {

      final body = await req.readAsString();
      final data = jsonDecode(body);

      final email = data['email'];
      final password = data['password'];
      final firstName = data['firstName'];
      final lastName = data['lastName'];
      final companyName = data['companyName'];
      final currency = data['currency'];

      if ([email, password, firstName, lastName, companyName, currency]
          .any((e) => e == null)) {
        return Response.badRequest(
            body: jsonEncode({'error': 'Missing required fields'}),
            headers: {'Content-Type': 'application/json'});
      }

      // Encrypt password
      final hashed = sha256.convert(utf8.encode(password)).toString();

      // Concatenate first and last name
      final name = '$firstName $lastName';

      // Get or create company and fetch ID
      final companyId =
          await getOrCreateCompany(companyName, currencyCode: currency);
      final roleRes = await DB.conn.query('''
        INSERT INTO user_roles (role_name)
        VALUES (@role)
        RETURNING user_id
      ''', substitutionValues: {'role': 'Admin'});

      final userId = roleRes.first[0] as int;

      // 2. Insert into users using that user_id
      await DB.conn.query('''
        INSERT INTO users (user_id, email, password_hash, name, company_id, manager_id)
        VALUES (@userId, @email, @password, @name, @companyId, NULL)
      ''', substitutionValues: {
        'userId': userId,
        'email': email,
        'password': hashed,
        'name': name,
        'companyId': companyId,
      });
      // Insert user with company_id
      await DB.conn.query('''
        INSERT INTO users (email, password_hash, name, company_id, role)
        VALUES (@email, @password_hash, @name, @company_id, 'admin')
        ON CONFLICT (email) DO NOTHING
      ''', substitutionValues: {
        'email': email,
        'password_hash': hashed,
        'name': name,
        'company_id': companyId,
      });

      return Response.ok(
          jsonEncode({'message': 'Signup successful', 'company_id': companyId}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': 'Signup failed', 'details': e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  }

  static Future<Response> login(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body);

      final email = data['email'];
      final password = data['password'];

      if (email == null || password == null) {
        return Response.badRequest(
            body: jsonEncode({'error': 'Missing email or password'}),
            headers: {'Content-Type': 'application/json'});
      }

      final hashed = sha256.convert(utf8.encode(password)).toString();

      final res = await DB.conn.query(
          'SELECT user_id, email, role FROM users WHERE email=@e AND password_hash=@p',
          substitutionValues: {'e': email, 'p': hashed});

      if (res.isEmpty) {
        return Response.forbidden(
            jsonEncode({'error': 'Invalid credentials'}),
            headers: {'Content-Type': 'application/json'});
      }

      final user = res.first.toColumnMap();

      return Response.ok(
          jsonEncode({
            'message': 'Login successful',
            'user': {'id': user['user_id'], 'email': user['email'], 'role': user['role']}
          }),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': 'Login failed', 'details': e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  }
}

Router buildRouter() {
  final router = Router();

  // Auth routes
  router.post('/signup', AuthService.signup);
  router.post('/login', AuthService.login);

  // TODO: Add expense routes here

  return router;
}
