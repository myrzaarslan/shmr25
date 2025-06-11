import '../models/bank_account.dart';
import '../models/account_history.dart';

abstract class BankAccountRepository {
  Future<List<BankAccount>> getAllAccounts();
  Future<BankAccount> createAccount(CreateBankAccountRequest request);
  Future<BankAccountWithStats> getAccountById(int id);
  Future<BankAccount> updateAccount(int id, UpdateBankAccountRequest request);
  Future<AccountHistory> getAccountHistory(int id);
}
