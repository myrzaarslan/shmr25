// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BankAccount {

 int get id; int get userId; String get name; String get balance; String get currency; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of BankAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankAccountCopyWith<BankAccount> get copyWith => _$BankAccountCopyWithImpl<BankAccount>(this as BankAccount, _$identity);

  /// Serializes this BankAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,balance,currency,createdAt,updatedAt);

@override
String toString() {
  return 'BankAccount(id: $id, userId: $userId, name: $name, balance: $balance, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BankAccountCopyWith<$Res>  {
  factory $BankAccountCopyWith(BankAccount value, $Res Function(BankAccount) _then) = _$BankAccountCopyWithImpl;
@useResult
$Res call({
 int id, int userId, String name, String balance, String currency, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$BankAccountCopyWithImpl<$Res>
    implements $BankAccountCopyWith<$Res> {
  _$BankAccountCopyWithImpl(this._self, this._then);

  final BankAccount _self;
  final $Res Function(BankAccount) _then;

/// Create a copy of BankAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? balance = null,Object? currency = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BankAccount implements BankAccount {
  const _BankAccount({required this.id, required this.userId, required this.name, required this.balance, required this.currency, required this.createdAt, required this.updatedAt});
  factory _BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);

@override final  int id;
@override final  int userId;
@override final  String name;
@override final  String balance;
@override final  String currency;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of BankAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankAccountCopyWith<_BankAccount> get copyWith => __$BankAccountCopyWithImpl<_BankAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,balance,currency,createdAt,updatedAt);

@override
String toString() {
  return 'BankAccount(id: $id, userId: $userId, name: $name, balance: $balance, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BankAccountCopyWith<$Res> implements $BankAccountCopyWith<$Res> {
  factory _$BankAccountCopyWith(_BankAccount value, $Res Function(_BankAccount) _then) = __$BankAccountCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, String name, String balance, String currency, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$BankAccountCopyWithImpl<$Res>
    implements _$BankAccountCopyWith<$Res> {
  __$BankAccountCopyWithImpl(this._self, this._then);

  final _BankAccount _self;
  final $Res Function(_BankAccount) _then;

/// Create a copy of BankAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? balance = null,Object? currency = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_BankAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BankAccountWithStats {

 int get id; String get name; String get balance; String get currency; List<CategoryStats> get incomeStats; List<CategoryStats> get expenseStats; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of BankAccountWithStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankAccountWithStatsCopyWith<BankAccountWithStats> get copyWith => _$BankAccountWithStatsCopyWithImpl<BankAccountWithStats>(this as BankAccountWithStats, _$identity);

  /// Serializes this BankAccountWithStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankAccountWithStats&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.incomeStats, incomeStats)&&const DeepCollectionEquality().equals(other.expenseStats, expenseStats)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,currency,const DeepCollectionEquality().hash(incomeStats),const DeepCollectionEquality().hash(expenseStats),createdAt,updatedAt);

@override
String toString() {
  return 'BankAccountWithStats(id: $id, name: $name, balance: $balance, currency: $currency, incomeStats: $incomeStats, expenseStats: $expenseStats, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BankAccountWithStatsCopyWith<$Res>  {
  factory $BankAccountWithStatsCopyWith(BankAccountWithStats value, $Res Function(BankAccountWithStats) _then) = _$BankAccountWithStatsCopyWithImpl;
@useResult
$Res call({
 int id, String name, String balance, String currency, List<CategoryStats> incomeStats, List<CategoryStats> expenseStats, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$BankAccountWithStatsCopyWithImpl<$Res>
    implements $BankAccountWithStatsCopyWith<$Res> {
  _$BankAccountWithStatsCopyWithImpl(this._self, this._then);

  final BankAccountWithStats _self;
  final $Res Function(BankAccountWithStats) _then;

/// Create a copy of BankAccountWithStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? currency = null,Object? incomeStats = null,Object? expenseStats = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,incomeStats: null == incomeStats ? _self.incomeStats : incomeStats // ignore: cast_nullable_to_non_nullable
as List<CategoryStats>,expenseStats: null == expenseStats ? _self.expenseStats : expenseStats // ignore: cast_nullable_to_non_nullable
as List<CategoryStats>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BankAccountWithStats implements BankAccountWithStats {
  const _BankAccountWithStats({required this.id, required this.name, required this.balance, required this.currency, required final  List<CategoryStats> incomeStats, required final  List<CategoryStats> expenseStats, required this.createdAt, required this.updatedAt}): _incomeStats = incomeStats,_expenseStats = expenseStats;
  factory _BankAccountWithStats.fromJson(Map<String, dynamic> json) => _$BankAccountWithStatsFromJson(json);

@override final  int id;
@override final  String name;
@override final  String balance;
@override final  String currency;
 final  List<CategoryStats> _incomeStats;
@override List<CategoryStats> get incomeStats {
  if (_incomeStats is EqualUnmodifiableListView) return _incomeStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomeStats);
}

 final  List<CategoryStats> _expenseStats;
@override List<CategoryStats> get expenseStats {
  if (_expenseStats is EqualUnmodifiableListView) return _expenseStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenseStats);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of BankAccountWithStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankAccountWithStatsCopyWith<_BankAccountWithStats> get copyWith => __$BankAccountWithStatsCopyWithImpl<_BankAccountWithStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankAccountWithStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankAccountWithStats&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other._incomeStats, _incomeStats)&&const DeepCollectionEquality().equals(other._expenseStats, _expenseStats)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,currency,const DeepCollectionEquality().hash(_incomeStats),const DeepCollectionEquality().hash(_expenseStats),createdAt,updatedAt);

@override
String toString() {
  return 'BankAccountWithStats(id: $id, name: $name, balance: $balance, currency: $currency, incomeStats: $incomeStats, expenseStats: $expenseStats, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BankAccountWithStatsCopyWith<$Res> implements $BankAccountWithStatsCopyWith<$Res> {
  factory _$BankAccountWithStatsCopyWith(_BankAccountWithStats value, $Res Function(_BankAccountWithStats) _then) = __$BankAccountWithStatsCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String balance, String currency, List<CategoryStats> incomeStats, List<CategoryStats> expenseStats, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$BankAccountWithStatsCopyWithImpl<$Res>
    implements _$BankAccountWithStatsCopyWith<$Res> {
  __$BankAccountWithStatsCopyWithImpl(this._self, this._then);

  final _BankAccountWithStats _self;
  final $Res Function(_BankAccountWithStats) _then;

/// Create a copy of BankAccountWithStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? currency = null,Object? incomeStats = null,Object? expenseStats = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_BankAccountWithStats(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,incomeStats: null == incomeStats ? _self._incomeStats : incomeStats // ignore: cast_nullable_to_non_nullable
as List<CategoryStats>,expenseStats: null == expenseStats ? _self._expenseStats : expenseStats // ignore: cast_nullable_to_non_nullable
as List<CategoryStats>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CategoryStats {

 int get categoryId; String get categoryName; String get emoji; String get amount;
/// Create a copy of CategoryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryStatsCopyWith<CategoryStats> get copyWith => _$CategoryStatsCopyWithImpl<CategoryStats>(this as CategoryStats, _$identity);

  /// Serializes this CategoryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryStats&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,emoji,amount);

@override
String toString() {
  return 'CategoryStats(categoryId: $categoryId, categoryName: $categoryName, emoji: $emoji, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $CategoryStatsCopyWith<$Res>  {
  factory $CategoryStatsCopyWith(CategoryStats value, $Res Function(CategoryStats) _then) = _$CategoryStatsCopyWithImpl;
@useResult
$Res call({
 int categoryId, String categoryName, String emoji, String amount
});




}
/// @nodoc
class _$CategoryStatsCopyWithImpl<$Res>
    implements $CategoryStatsCopyWith<$Res> {
  _$CategoryStatsCopyWithImpl(this._self, this._then);

  final CategoryStats _self;
  final $Res Function(CategoryStats) _then;

/// Create a copy of CategoryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,Object? emoji = null,Object? amount = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CategoryStats implements CategoryStats {
  const _CategoryStats({required this.categoryId, required this.categoryName, required this.emoji, required this.amount});
  factory _CategoryStats.fromJson(Map<String, dynamic> json) => _$CategoryStatsFromJson(json);

@override final  int categoryId;
@override final  String categoryName;
@override final  String emoji;
@override final  String amount;

/// Create a copy of CategoryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryStatsCopyWith<_CategoryStats> get copyWith => __$CategoryStatsCopyWithImpl<_CategoryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryStats&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,emoji,amount);

@override
String toString() {
  return 'CategoryStats(categoryId: $categoryId, categoryName: $categoryName, emoji: $emoji, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$CategoryStatsCopyWith<$Res> implements $CategoryStatsCopyWith<$Res> {
  factory _$CategoryStatsCopyWith(_CategoryStats value, $Res Function(_CategoryStats) _then) = __$CategoryStatsCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, String categoryName, String emoji, String amount
});




}
/// @nodoc
class __$CategoryStatsCopyWithImpl<$Res>
    implements _$CategoryStatsCopyWith<$Res> {
  __$CategoryStatsCopyWithImpl(this._self, this._then);

  final _CategoryStats _self;
  final $Res Function(_CategoryStats) _then;

/// Create a copy of CategoryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,Object? emoji = null,Object? amount = null,}) {
  return _then(_CategoryStats(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateBankAccountRequest {

 String get name; String get balance; String get currency;
/// Create a copy of CreateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateBankAccountRequestCopyWith<CreateBankAccountRequest> get copyWith => _$CreateBankAccountRequestCopyWithImpl<CreateBankAccountRequest>(this as CreateBankAccountRequest, _$identity);

  /// Serializes this CreateBankAccountRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateBankAccountRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'CreateBankAccountRequest(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $CreateBankAccountRequestCopyWith<$Res>  {
  factory $CreateBankAccountRequestCopyWith(CreateBankAccountRequest value, $Res Function(CreateBankAccountRequest) _then) = _$CreateBankAccountRequestCopyWithImpl;
@useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class _$CreateBankAccountRequestCopyWithImpl<$Res>
    implements $CreateBankAccountRequestCopyWith<$Res> {
  _$CreateBankAccountRequestCopyWithImpl(this._self, this._then);

  final CreateBankAccountRequest _self;
  final $Res Function(CreateBankAccountRequest) _then;

/// Create a copy of CreateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? balance = null,Object? currency = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CreateBankAccountRequest implements CreateBankAccountRequest {
  const _CreateBankAccountRequest({required this.name, required this.balance, required this.currency});
  factory _CreateBankAccountRequest.fromJson(Map<String, dynamic> json) => _$CreateBankAccountRequestFromJson(json);

@override final  String name;
@override final  String balance;
@override final  String currency;

/// Create a copy of CreateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateBankAccountRequestCopyWith<_CreateBankAccountRequest> get copyWith => __$CreateBankAccountRequestCopyWithImpl<_CreateBankAccountRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateBankAccountRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateBankAccountRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'CreateBankAccountRequest(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$CreateBankAccountRequestCopyWith<$Res> implements $CreateBankAccountRequestCopyWith<$Res> {
  factory _$CreateBankAccountRequestCopyWith(_CreateBankAccountRequest value, $Res Function(_CreateBankAccountRequest) _then) = __$CreateBankAccountRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class __$CreateBankAccountRequestCopyWithImpl<$Res>
    implements _$CreateBankAccountRequestCopyWith<$Res> {
  __$CreateBankAccountRequestCopyWithImpl(this._self, this._then);

  final _CreateBankAccountRequest _self;
  final $Res Function(_CreateBankAccountRequest) _then;

/// Create a copy of CreateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? balance = null,Object? currency = null,}) {
  return _then(_CreateBankAccountRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateBankAccountRequest {

 String get name; String get balance; String get currency;
/// Create a copy of UpdateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateBankAccountRequestCopyWith<UpdateBankAccountRequest> get copyWith => _$UpdateBankAccountRequestCopyWithImpl<UpdateBankAccountRequest>(this as UpdateBankAccountRequest, _$identity);

  /// Serializes this UpdateBankAccountRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateBankAccountRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'UpdateBankAccountRequest(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $UpdateBankAccountRequestCopyWith<$Res>  {
  factory $UpdateBankAccountRequestCopyWith(UpdateBankAccountRequest value, $Res Function(UpdateBankAccountRequest) _then) = _$UpdateBankAccountRequestCopyWithImpl;
@useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class _$UpdateBankAccountRequestCopyWithImpl<$Res>
    implements $UpdateBankAccountRequestCopyWith<$Res> {
  _$UpdateBankAccountRequestCopyWithImpl(this._self, this._then);

  final UpdateBankAccountRequest _self;
  final $Res Function(UpdateBankAccountRequest) _then;

/// Create a copy of UpdateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? balance = null,Object? currency = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UpdateBankAccountRequest implements UpdateBankAccountRequest {
  const _UpdateBankAccountRequest({required this.name, required this.balance, required this.currency});
  factory _UpdateBankAccountRequest.fromJson(Map<String, dynamic> json) => _$UpdateBankAccountRequestFromJson(json);

@override final  String name;
@override final  String balance;
@override final  String currency;

/// Create a copy of UpdateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateBankAccountRequestCopyWith<_UpdateBankAccountRequest> get copyWith => __$UpdateBankAccountRequestCopyWithImpl<_UpdateBankAccountRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateBankAccountRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateBankAccountRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'UpdateBankAccountRequest(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$UpdateBankAccountRequestCopyWith<$Res> implements $UpdateBankAccountRequestCopyWith<$Res> {
  factory _$UpdateBankAccountRequestCopyWith(_UpdateBankAccountRequest value, $Res Function(_UpdateBankAccountRequest) _then) = __$UpdateBankAccountRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class __$UpdateBankAccountRequestCopyWithImpl<$Res>
    implements _$UpdateBankAccountRequestCopyWith<$Res> {
  __$UpdateBankAccountRequestCopyWithImpl(this._self, this._then);

  final _UpdateBankAccountRequest _self;
  final $Res Function(_UpdateBankAccountRequest) _then;

/// Create a copy of UpdateBankAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? balance = null,Object? currency = null,}) {
  return _then(_UpdateBankAccountRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
