// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveData {

@JsonKey(name: 'type') String get type;@JsonKey(name: 'description') String get description;@JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime) DateTime get startDate;@JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime) DateTime get endDate;
/// Create a copy of LeaveData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveDataCopyWith<LeaveData> get copyWith => _$LeaveDataCopyWithImpl<LeaveData>(this as LeaveData, _$identity);

  /// Serializes this LeaveData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveData&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description,startDate,endDate);

@override
String toString() {
  return 'LeaveData(type: $type, description: $description, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $LeaveDataCopyWith<$Res>  {
  factory $LeaveDataCopyWith(LeaveData value, $Res Function(LeaveData) _then) = _$LeaveDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String type,@JsonKey(name: 'description') String description,@JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime) DateTime startDate,@JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime) DateTime endDate
});




}
/// @nodoc
class _$LeaveDataCopyWithImpl<$Res>
    implements $LeaveDataCopyWith<$Res> {
  _$LeaveDataCopyWithImpl(this._self, this._then);

  final LeaveData _self;
  final $Res Function(LeaveData) _then;

/// Create a copy of LeaveData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? description = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveData].
extension LeaveDataPatterns on LeaveData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveData value)  $default,){
final _that = this;
switch (_that) {
case _LeaveData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveData value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String type, @JsonKey(name: 'description')  String description, @JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime)  DateTime startDate, @JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime)  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveData() when $default != null:
return $default(_that.type,_that.description,_that.startDate,_that.endDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String type, @JsonKey(name: 'description')  String description, @JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime)  DateTime startDate, @JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime)  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _LeaveData():
return $default(_that.type,_that.description,_that.startDate,_that.endDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String type, @JsonKey(name: 'description')  String description, @JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime)  DateTime startDate, @JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime)  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _LeaveData() when $default != null:
return $default(_that.type,_that.description,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveData implements LeaveData {
  const _LeaveData({@JsonKey(name: 'type') required this.type, @JsonKey(name: 'description') required this.description, @JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime) required this.startDate, @JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime) required this.endDate});
  factory _LeaveData.fromJson(Map<String, dynamic> json) => _$LeaveDataFromJson(json);

@override@JsonKey(name: 'type') final  String type;
@override@JsonKey(name: 'description') final  String description;
@override@JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime) final  DateTime startDate;
@override@JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime) final  DateTime endDate;

/// Create a copy of LeaveData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveDataCopyWith<_LeaveData> get copyWith => __$LeaveDataCopyWithImpl<_LeaveData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveData&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description,startDate,endDate);

@override
String toString() {
  return 'LeaveData(type: $type, description: $description, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$LeaveDataCopyWith<$Res> implements $LeaveDataCopyWith<$Res> {
  factory _$LeaveDataCopyWith(_LeaveData value, $Res Function(_LeaveData) _then) = __$LeaveDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String type,@JsonKey(name: 'description') String description,@JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime) DateTime startDate,@JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime) DateTime endDate
});




}
/// @nodoc
class __$LeaveDataCopyWithImpl<$Res>
    implements _$LeaveDataCopyWith<$Res> {
  __$LeaveDataCopyWithImpl(this._self, this._then);

  final _LeaveData _self;
  final $Res Function(_LeaveData) _then;

/// Create a copy of LeaveData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? description = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_LeaveData(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$LeaveModel {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'data') LeaveData get data;@JsonKey(name: 'status') RequestStatus get status;@JsonKey(name: 'requester') UserData get requester;@JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson) UserData? get approver;@JsonKey(name: 'rejectReason') String? get rejectReason;
/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveModelCopyWith<LeaveModel> get copyWith => _$LeaveModelCopyWithImpl<LeaveModel>(this as LeaveModel, _$identity);

  /// Serializes this LeaveModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.data, data) || other.data == data)&&(identical(other.status, status) || other.status == status)&&(identical(other.requester, requester) || other.requester == requester)&&(identical(other.approver, approver) || other.approver == approver)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,data,status,requester,approver,rejectReason);

@override
String toString() {
  return 'LeaveModel(id: $id, data: $data, status: $status, requester: $requester, approver: $approver, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class $LeaveModelCopyWith<$Res>  {
  factory $LeaveModelCopyWith(LeaveModel value, $Res Function(LeaveModel) _then) = _$LeaveModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'data') LeaveData data,@JsonKey(name: 'status') RequestStatus status,@JsonKey(name: 'requester') UserData requester,@JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson) UserData? approver,@JsonKey(name: 'rejectReason') String? rejectReason
});


$LeaveDataCopyWith<$Res> get data;$UserDataCopyWith<$Res> get requester;$UserDataCopyWith<$Res>? get approver;

}
/// @nodoc
class _$LeaveModelCopyWithImpl<$Res>
    implements $LeaveModelCopyWith<$Res> {
  _$LeaveModelCopyWithImpl(this._self, this._then);

  final LeaveModel _self;
  final $Res Function(LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? data = null,Object? status = null,Object? requester = null,Object? approver = freezed,Object? rejectReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as LeaveData,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as UserData,approver: freezed == approver ? _self.approver : approver // ignore: cast_nullable_to_non_nullable
as UserData?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveDataCopyWith<$Res> get data {
  
  return $LeaveDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res> get requester {
  
  return $UserDataCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res>? get approver {
    if (_self.approver == null) {
    return null;
  }

  return $UserDataCopyWith<$Res>(_self.approver!, (value) {
    return _then(_self.copyWith(approver: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveModel].
extension LeaveModelPatterns on LeaveModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'data')  LeaveData data, @JsonKey(name: 'status')  RequestStatus status, @JsonKey(name: 'requester')  UserData requester, @JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson)  UserData? approver, @JsonKey(name: 'rejectReason')  String? rejectReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.data,_that.status,_that.requester,_that.approver,_that.rejectReason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'data')  LeaveData data, @JsonKey(name: 'status')  RequestStatus status, @JsonKey(name: 'requester')  UserData requester, @JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson)  UserData? approver, @JsonKey(name: 'rejectReason')  String? rejectReason)  $default,) {final _that = this;
switch (_that) {
case _LeaveModel():
return $default(_that.id,_that.data,_that.status,_that.requester,_that.approver,_that.rejectReason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'data')  LeaveData data, @JsonKey(name: 'status')  RequestStatus status, @JsonKey(name: 'requester')  UserData requester, @JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson)  UserData? approver, @JsonKey(name: 'rejectReason')  String? rejectReason)?  $default,) {final _that = this;
switch (_that) {
case _LeaveModel() when $default != null:
return $default(_that.id,_that.data,_that.status,_that.requester,_that.approver,_that.rejectReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveModel implements LeaveModel {
  const _LeaveModel({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'data') required this.data, @JsonKey(name: 'status') required this.status, @JsonKey(name: 'requester') required this.requester, @JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson) this.approver, @JsonKey(name: 'rejectReason') this.rejectReason});
  factory _LeaveModel.fromJson(Map<String, dynamic> json) => _$LeaveModelFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'data') final  LeaveData data;
@override@JsonKey(name: 'status') final  RequestStatus status;
@override@JsonKey(name: 'requester') final  UserData requester;
@override@JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson) final  UserData? approver;
@override@JsonKey(name: 'rejectReason') final  String? rejectReason;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveModelCopyWith<_LeaveModel> get copyWith => __$LeaveModelCopyWithImpl<_LeaveModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.data, data) || other.data == data)&&(identical(other.status, status) || other.status == status)&&(identical(other.requester, requester) || other.requester == requester)&&(identical(other.approver, approver) || other.approver == approver)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,data,status,requester,approver,rejectReason);

@override
String toString() {
  return 'LeaveModel(id: $id, data: $data, status: $status, requester: $requester, approver: $approver, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class _$LeaveModelCopyWith<$Res> implements $LeaveModelCopyWith<$Res> {
  factory _$LeaveModelCopyWith(_LeaveModel value, $Res Function(_LeaveModel) _then) = __$LeaveModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'data') LeaveData data,@JsonKey(name: 'status') RequestStatus status,@JsonKey(name: 'requester') UserData requester,@JsonKey(name: 'approver')@SafeModelParser<UserData>(UserData.fromJson) UserData? approver,@JsonKey(name: 'rejectReason') String? rejectReason
});


@override $LeaveDataCopyWith<$Res> get data;@override $UserDataCopyWith<$Res> get requester;@override $UserDataCopyWith<$Res>? get approver;

}
/// @nodoc
class __$LeaveModelCopyWithImpl<$Res>
    implements _$LeaveModelCopyWith<$Res> {
  __$LeaveModelCopyWithImpl(this._self, this._then);

  final _LeaveModel _self;
  final $Res Function(_LeaveModel) _then;

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? data = null,Object? status = null,Object? requester = null,Object? approver = freezed,Object? rejectReason = freezed,}) {
  return _then(_LeaveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as LeaveData,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as UserData,approver: freezed == approver ? _self.approver : approver // ignore: cast_nullable_to_non_nullable
as UserData?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveDataCopyWith<$Res> get data {
  
  return $LeaveDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res> get requester {
  
  return $UserDataCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}/// Create a copy of LeaveModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res>? get approver {
    if (_self.approver == null) {
    return null;
  }

  return $UserDataCopyWith<$Res>(_self.approver!, (value) {
    return _then(_self.copyWith(approver: value));
  });
}
}

// dart format on
