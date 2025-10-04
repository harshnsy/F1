import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'db.dart';

class ExpenseService {
  static Future<Response> submitExpense(Request req) async {
    final body = jsonDecode(await req.readAsString());
    await DB.conn.query('''
      INSERT INTO expenses (user_id, amount, category, description, status)
      VALUES (@user, @amount, @cat, @desc, 'pending')
    ''', substitutionValues: {
      'user': body['user_id'],
      'amount': body['amount'],
      'cat': body['category'],
      'desc': body['description'],
    });
    return Response.ok(jsonEncode({'message': 'Expense submitted'}));
  }

  static Future<Response> getMyExpenses(Request req) async {
    final expenses = await DB.conn.mappedResultsQuery('SELECT * FROM expenses');
    return Response.ok(jsonEncode(expenses));
  }

  static Future<Response> approveExpense(Request req, String id) async {
    await DB.conn.query('UPDATE expenses SET status = \'approved\' WHERE id=@id', substitutionValues: {'id': int.parse(id)});
    return Response.ok(jsonEncode({'message': 'Approved'}));
  }

  static Future<Response> rejectExpense(Request req, String id) async {
    await DB.conn.query('UPDATE expenses SET status = \'rejected\' WHERE id=@id', substitutionValues: {'id': int.parse(id)});
    return Response.ok(jsonEncode({'message': 'Rejected'}));
  }
}