import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/export/datasource_export.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/testing/shared/user_data.dart';

class AccountDummyRemote implements AccountRemote {
  final List<AccountModel> _dummyAccounts = UserData.dummyAccounts.values
      .toList();

  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<List<AccountModel>> getAllAccounts() async {
    await _simulatedNetworkDelay();
    return List.unmodifiable(_dummyAccounts);
  }

  @override
  Future<AccountModel> getAccountById(String uid) async {
    await _simulatedNetworkDelay();
    try {
      return _dummyAccounts.firstWhere((account) => account.uid == uid);
    } catch (e) {
      throw const ServerFailure('Account not found');
    }
  }

  @override
  Future<AccountModel> createAccount(AccountModel account) async {
    await _simulatedNetworkDelay();
    try {
      final newUid =
          'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      final newAccount = account.copyWith(uid: newUid);
      _dummyAccounts.add(newAccount);

      return newAccount;
    } catch (e) {
      throw const ServerFailure('Failed to create account');
    }
  }

  @override
  Future<AccountModel> updateAccount(
    String uid,
    Map<String, dynamic> account,
  ) async {
    await _simulatedNetworkDelay();
    
    final accountIndex = _dummyAccounts.indexWhere((account) => account.uid == uid);

    if (accountIndex == -1) {
      throw const ServerFailure('Account not found');
    }

    try {
      final oldAccount = _dummyAccounts[accountIndex];
      final Map<String, dynamic> updatedJson = {
        ...oldAccount.toJson(),
        ...account,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final updateAccount = AccountModel.fromJson(updatedJson);
      _dummyAccounts[accountIndex] = updateAccount;

      return updateAccount;
    } catch (e) {
      throw const ServerFailure('Failed to update account');
    }
  }

  @override
  Future<void> deleteAccount(String uid) async {
    await _simulatedNetworkDelay();

    final initialLength = _dummyAccounts.length;
    _dummyAccounts.removeWhere((account) => account.uid == uid);
    
    if (_dummyAccounts.length == initialLength) {
      throw const ServerFailure('Account not found');
    }
  }
}
