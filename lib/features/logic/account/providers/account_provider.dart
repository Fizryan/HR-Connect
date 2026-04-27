import 'package:flutter/material.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/logic/account/data/repositories/account_repository.dart';
import 'package:hr_connect/features/logic/account/providers/account_state.dart';

class AccountProvider extends ValueNotifier<AccountState> {
  final AccountRepository repository;

  AccountProvider({required this.repository}) : super(const AccountState.initial());

  Future<void> fetchAllAccounts() async {
    value = const AccountState.loading();
    final result = await repository.getAllAccounts();
    result.fold(
      (failure) => value = AccountState.error(failure.message),
      (accounts) => value = AccountState.dataList(accounts),
    );
  }

  Future<void> getAccountByUid(String uid) async {
    value = const AccountState.loading();
    final result = await repository.getAccountById(uid);
    result.fold(
      (failure) => value = AccountState.error(failure.message),
      (account) => value = AccountState.data(account),
    );
  }

  Future<void> createAccount(AccountModel account) async {
    value = const AccountState.loading();
    final result = await repository.createAccount(account);
    result.fold(
      (failure) => value = AccountState.error(failure.message),
      (account) => value = const AccountState.success('Account created successfully'),
    );
  }

  Future<void> updateAccount(AccountModel account) async {
    value = const AccountState.loading();
    final result = await repository.updateAccount(account);
    result.fold(
      (failure) => value = AccountState.error(failure.message),
      (account) => value = const AccountState.success('Account updated successfully'),
    );
  }

  Future<void> deleteAccount(String uid) async {
    value = const AccountState.loading();
    final result = await repository.deleteAccount(uid);
    result.fold(
      (failure) => value = AccountState.error(failure.message),
      (_) => value = const AccountState.success('Account deleted successfully'),
    );
  }
}