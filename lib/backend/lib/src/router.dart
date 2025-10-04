import 'package:shelf_router/shelf_router.dart';
import 'auth_service.dart';
import 'expense_service.dart';

Router buildRouter() {
  final router = Router();

  // Auth
  router.post('/signup', AuthService.signup);
  router.post('/login', AuthService.login);

  // Expenses
  router.post('/expenses', ExpenseService.submitExpense);
  router.get('/expenses', ExpenseService.getMyExpenses);
  router.post('/expenses/<id|[0-9]+>/approve', ExpenseService.approveExpense);
  router.post('/expenses/<id|[0-9]+>/reject', ExpenseService.rejectExpense);

  return router;
}