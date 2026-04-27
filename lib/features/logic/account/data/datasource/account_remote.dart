import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';

abstract class AccountRemote {
  Future<List<AccountModel>> getAllAccounts();
  Future<AccountModel> getAccountById(String uid);
  Future<AccountModel> createAccount(AccountModel account);
  Future<AccountModel> updateAccount(String uid, Map<String, dynamic> account);
  Future<void> deleteAccount(String uid);
}

class AccountRemoteImpl implements AccountRemote {
  final ApiClient apiClient;

  AccountRemoteImpl({required this.apiClient});

  @override
  Future<List<AccountModel>> getAllAccounts() async {
    try {
      final response = await apiClient.get('/accounts');
      final List accountData = response['data'];
      return accountData.map((json) => AccountModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<AccountModel> getAccountById(String uid) async {
    try {
      final response = await apiClient.get('/accounts/$uid');
      return AccountModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<AccountModel> createAccount(AccountModel account) async {
    try {
      final response = await apiClient.post(
        '/accounts',
        data: account.toJson(),
      );
      return AccountModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<AccountModel> updateAccount(
    String uid,
    Map<String, dynamic> account,
  ) async {
    try {
      final response = await apiClient.put(
        '/accounts/$uid',
        data: account,
      );
      return AccountModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<void> deleteAccount(String uid) async {
    try {
      await apiClient.delete('/accounts/$uid');
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
