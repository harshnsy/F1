import 'package:expense_manager/src/db.dart';

class ApprovalService {
  /// Create approvers for a new expense based on default workflow
  static Future<void> createApprovers(int expenseId, List<int> approverIds) async {
    int step = 1;
    for (final userId in approverIds) {
      await DB.conn.query('''
        INSERT INTO expense_approvers (expense_id, approver_user_id, step)
        VALUES (@expenseId, @userId, @step)
      ''', substitutionValues: {
        'expenseId': expenseId,
        'userId': userId,
        'step': step
      });
      step++;
    }
  }

  /// Approve an expense
  static Future<bool> approve(int approverId, int expenseApproverId, {String? comment}) async {
    // Check ownership
    final rows = await DB.conn.query('''
      SELECT expense_id, status, step
      FROM expense_approvers
      WHERE id = @id AND approver_user_id = @userId
    ''', substitutionValues: {'id': expenseApproverId, 'userId': approverId});

    if (rows.isEmpty) return false;

    final expenseId = rows.first[0] as int;

    // Update approver status
    await DB.conn.query('''
      UPDATE expense_approvers
      SET status = 'approved', acted_by=@userId, acted_at=NOW()
      WHERE id=@id
    ''', substitutionValues: {'userId': approverId, 'id': expenseApproverId});

    // Add approval action history
    await DB.conn.query('''
      INSERT INTO approvals (expense_approver_id, approver_id, action, comment)
      VALUES (@expenseApproverId, @approverId, 'approved', @comment)
    ''', substitutionValues: {
      'expenseApproverId': expenseApproverId,
      'approverId': approverId,
      'comment': comment
    });

    // Evaluate conditional rules & move to next step
    await _evaluateNextStep(expenseId);

    return true;
  }

  /// Reject an expense
  static Future<bool> reject(int approverId, int expenseApproverId, {String? comment}) async {
    // Similar to approve but mark expense rejected immediately
    final rows = await DB.conn.query('''
      SELECT expense_id FROM expense_approvers
      WHERE id = @id AND approver_user_id = @userId
    ''', substitutionValues: {'id': expenseApproverId, 'userId': approverId});

    if (rows.isEmpty) return false;

    final expenseId = rows.first[0] as int;

    await DB.conn.query('''
      UPDATE expense_approvers
      SET status = 'rejected', acted_by=@userId, acted_at=NOW()
      WHERE id=@id
    ''', substitutionValues: {'userId': approverId, 'id': expenseApproverId});

    await DB.conn.query('''
      INSERT INTO approvals (expense_approver_id, approver_id, action, comment)
      VALUES (@expenseApproverId, @approverId, 'rejected', @comment)
    ''', substitutionValues: {
      'expenseApproverId': expenseApproverId,
      'approverId': approverId,
      'comment': comment
    });

    // Mark expense rejected
    await DB.conn.query('UPDATE expenses SET status=\'rejected\' WHERE id=@id', substitutionValues: {'id': expenseId});

    return true;
  }

  /// Evaluate the expense rules and advance to next approver
  static Future<void> _evaluateNextStep(int expenseId) async {
    // Fetch all approvers and their statuses
    final approvers = await DB.conn.mappedResultsQuery('''
      SELECT id, step, status, approver_user_id
      FROM expense_approvers
      WHERE expense_id=@id
      ORDER BY step
    ''', substitutionValues: {'id': expenseId});

    // Check for any 'rejected'
    if (approvers.any((row) => row['expense_approvers']!['status'] == 'rejected')) {
      await DB.conn.query('UPDATE expenses SET status=\'rejected\' WHERE id=@id', substitutionValues: {'id': expenseId});
      return;
    }

    // Get pending approver with lowest step
    final pending = approvers.cast<Map<String, Map<String, dynamic>>?>().firstWhere(
      (row) => row != null && row['expense_approvers']!['status'] == 'pending',
      orElse: () => null,
    );

    if (pending == null) {
      // All approved
      await DB.conn.query('UPDATE expenses SET status=\'approved\' WHERE id=@id', substitutionValues: {'id': expenseId});
      return;
    }

    // Optional: evaluate conditional rules from approval_rules table
    // Example: if specific approver approved or percentage satisfied
    // TODO: implement percentage/specific rules logic here
  }
}