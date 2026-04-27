import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState.initial() = _Initial;
  const factory AccountState.loading() = _Loading;
  const factory AccountState.dataList(List<AccountModel> account) = _DataList;
  const factory AccountState.data(AccountModel account) = _Data;
  const factory AccountState.success(String message) = _Success;
  const factory AccountState.error(String message) = _Error;
}