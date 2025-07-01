class AccountState {
  final String accountName;

  AccountState({required this.accountName});

  AccountState copyWith({String? accountName}) {
    return AccountState(accountName: accountName ?? this.accountName);
  }
}
