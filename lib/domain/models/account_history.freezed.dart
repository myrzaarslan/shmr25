// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountHistory {

 int get accountId; String get accountName; String get currency; String get currentBalance; List<AccountHistoryItem> get history;
/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountHistoryCopyWith<AccountHistory> get copyWith => _$AccountHistoryCopyWithImpl<AccountHistory>(this as AccountHistory, _$identity);

  /// Serializes this AccountHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountHistory&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountName,currency,currentBalance,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'AccountHistory(accountId: $accountId, accountName: $accountName, currency: $currency, currentBalance: $currentBalance, history: $history)';
}


}

/// @nodoc
abstract mixin class $AccountHistoryCopyWith<$Res>  {
  factory $AccountHistoryCopyWith(AccountHistory value, $Res Function(AccountHistory) _then) = _$AccountHistoryCopyWithImpl;
@useResult
$Res call({
 int accountId, String accountName, String currency, String currentBalance, List<AccountHistoryItem> history
});




}
/// @nodoc
class _$AccountHistoryCopyWithImpl<$Res>
    implements $AccountHistoryCopyWith<$Res> {
  _$AccountHistoryCopyWithImpl(this._self, this._then);

  final AccountHistory _self;
  final $Res Function(AccountHistory) _then;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? accountName = null,Object? currency = null,Object? currentBalance = null,Object? history = null,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<AccountHistoryItem>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AccountHistory implements AccountHistory {
  const _AccountHistory({required this.accountId, required this.accountName, required this.currency, required this.currentBalance, required final  List<AccountHistoryItem> history}): _history = history;
  factory _AccountHistory.fromJson(Map<String, dynamic> json) => _$AccountHistoryFromJson(json);

@override final  int accountId;
@override final  String accountName;
@override final  String currency;
@override final  String currentBalance;
 final  List<AccountHistoryItem> _history;
@override List<AccountHistoryItem> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountHistoryCopyWith<_AccountHistory> get copyWith => __$AccountHistoryCopyWithImpl<_AccountHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountHistory&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountName,currency,currentBalance,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'AccountHistory(accountId: $accountId, accountName: $accountName, currency: $currency, currentBalance: $currentBalance, history: $history)';
}


}

/// @nodoc
abstract mixin class _$AccountHistoryCopyWith<$Res> implements $AccountHistoryCopyWith<$Res> {
  factory _$AccountHistoryCopyWith(_AccountHistory value, $Res Function(_AccountHistory) _then) = __$AccountHistoryCopyWithImpl;
@override @useResult
$Res call({
 int accountId, String accountName, String currency, String currentBalance, List<AccountHistoryItem> history
});




}
/// @nodoc
class __$AccountHistoryCopyWithImpl<$Res>
    implements _$AccountHistoryCopyWith<$Res> {
  __$AccountHistoryCopyWithImpl(this._self, this._then);

  final _AccountHistory _self;
  final $Res Function(_AccountHistory) _then;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? accountName = null,Object? currency = null,Object? currentBalance = null,Object? history = null,}) {
  return _then(_AccountHistory(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<AccountHistoryItem>,
  ));
}


}


/// @nodoc
mixin _$AccountHistoryItem {

 int get id; int get accountId; String get changeType; BankAccount get previousState; BankAccount get newState; DateTime get changeTimestamp; DateTime get createdAt;
/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountHistoryItemCopyWith<AccountHistoryItem> get copyWith => _$AccountHistoryItemCopyWithImpl<AccountHistoryItem>(this as AccountHistoryItem, _$identity);

  /// Serializes this AccountHistoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.previousState, previousState) || other.previousState == previousState)&&(identical(other.newState, newState) || other.newState == newState)&&(identical(other.changeTimestamp, changeTimestamp) || other.changeTimestamp == changeTimestamp)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,changeType,previousState,newState,changeTimestamp,createdAt);

@override
String toString() {
  return 'AccountHistoryItem(id: $id, accountId: $accountId, changeType: $changeType, previousState: $previousState, newState: $newState, changeTimestamp: $changeTimestamp, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AccountHistoryItemCopyWith<$Res>  {
  factory $AccountHistoryItemCopyWith(AccountHistoryItem value, $Res Function(AccountHistoryItem) _then) = _$AccountHistoryItemCopyWithImpl;
@useResult
$Res call({
 int id, int accountId, String changeType, BankAccount previousState, BankAccount newState, DateTime changeTimestamp, DateTime createdAt
});


$BankAccountCopyWith<$Res> get previousState;$BankAccountCopyWith<$Res> get newState;

}
/// @nodoc
class _$AccountHistoryItemCopyWithImpl<$Res>
    implements $AccountHistoryItemCopyWith<$Res> {
  _$AccountHistoryItemCopyWithImpl(this._self, this._then);

  final AccountHistoryItem _self;
  final $Res Function(AccountHistoryItem) _then;

/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? changeType = null,Object? previousState = null,Object? newState = null,Object? changeTimestamp = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,previousState: null == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as BankAccount,newState: null == newState ? _self.newState : newState // ignore: cast_nullable_to_non_nullable
as BankAccount,changeTimestamp: null == changeTimestamp ? _self.changeTimestamp : changeTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankAccountCopyWith<$Res> get previousState {
  
  return $BankAccountCopyWith<$Res>(_self.previousState, (value) {
    return _then(_self.copyWith(previousState: value));
  });
}/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankAccountCopyWith<$Res> get newState {
  
  return $BankAccountCopyWith<$Res>(_self.newState, (value) {
    return _then(_self.copyWith(newState: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AccountHistoryItem implements AccountHistoryItem {
  const _AccountHistoryItem({required this.id, required this.accountId, required this.changeType, required this.previousState, required this.newState, required this.changeTimestamp, required this.createdAt});
  factory _AccountHistoryItem.fromJson(Map<String, dynamic> json) => _$AccountHistoryItemFromJson(json);

@override final  int id;
@override final  int accountId;
@override final  String changeType;
@override final  BankAccount previousState;
@override final  BankAccount newState;
@override final  DateTime changeTimestamp;
@override final  DateTime createdAt;

/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountHistoryItemCopyWith<_AccountHistoryItem> get copyWith => __$AccountHistoryItemCopyWithImpl<_AccountHistoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountHistoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.previousState, previousState) || other.previousState == previousState)&&(identical(other.newState, newState) || other.newState == newState)&&(identical(other.changeTimestamp, changeTimestamp) || other.changeTimestamp == changeTimestamp)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,changeType,previousState,newState,changeTimestamp,createdAt);

@override
String toString() {
  return 'AccountHistoryItem(id: $id, accountId: $accountId, changeType: $changeType, previousState: $previousState, newState: $newState, changeTimestamp: $changeTimestamp, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AccountHistoryItemCopyWith<$Res> implements $AccountHistoryItemCopyWith<$Res> {
  factory _$AccountHistoryItemCopyWith(_AccountHistoryItem value, $Res Function(_AccountHistoryItem) _then) = __$AccountHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int accountId, String changeType, BankAccount previousState, BankAccount newState, DateTime changeTimestamp, DateTime createdAt
});


@override $BankAccountCopyWith<$Res> get previousState;@override $BankAccountCopyWith<$Res> get newState;

}
/// @nodoc
class __$AccountHistoryItemCopyWithImpl<$Res>
    implements _$AccountHistoryItemCopyWith<$Res> {
  __$AccountHistoryItemCopyWithImpl(this._self, this._then);

  final _AccountHistoryItem _self;
  final $Res Function(_AccountHistoryItem) _then;

/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? changeType = null,Object? previousState = null,Object? newState = null,Object? changeTimestamp = null,Object? createdAt = null,}) {
  return _then(_AccountHistoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,previousState: null == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as BankAccount,newState: null == newState ? _self.newState : newState // ignore: cast_nullable_to_non_nullable
as BankAccount,changeTimestamp: null == changeTimestamp ? _self.changeTimestamp : changeTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankAccountCopyWith<$Res> get previousState {
  
  return $BankAccountCopyWith<$Res>(_self.previousState, (value) {
    return _then(_self.copyWith(previousState: value));
  });
}/// Create a copy of AccountHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankAccountCopyWith<$Res> get newState {
  
  return $BankAccountCopyWith<$Res>(_self.newState, (value) {
    return _then(_self.copyWith(newState: value));
  });
}
}

// dart format on
