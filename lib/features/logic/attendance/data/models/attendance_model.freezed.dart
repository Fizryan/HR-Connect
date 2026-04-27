// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceModel {

 String get uid; String get requestedById;@JsonKey(name: 'start_time') DateTime? get loginTme;@JsonKey(name: 'end_time') DateTime? get logoutTime;@JsonKey(name: 'date_created') DateTime? get dateCreated;
/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceModelCopyWith<AttendanceModel> get copyWith => _$AttendanceModelCopyWithImpl<AttendanceModel>(this as AttendanceModel, _$identity);

  /// Serializes this AttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.requestedById, requestedById) || other.requestedById == requestedById)&&(identical(other.loginTme, loginTme) || other.loginTme == loginTme)&&(identical(other.logoutTime, logoutTime) || other.logoutTime == logoutTime)&&(identical(other.dateCreated, dateCreated) || other.dateCreated == dateCreated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,requestedById,loginTme,logoutTime,dateCreated);

@override
String toString() {
  return 'AttendanceModel(uid: $uid, requestedById: $requestedById, loginTme: $loginTme, logoutTime: $logoutTime, dateCreated: $dateCreated)';
}


}

/// @nodoc
abstract mixin class $AttendanceModelCopyWith<$Res>  {
  factory $AttendanceModelCopyWith(AttendanceModel value, $Res Function(AttendanceModel) _then) = _$AttendanceModelCopyWithImpl;
@useResult
$Res call({
 String uid, String requestedById,@JsonKey(name: 'start_time') DateTime? loginTme,@JsonKey(name: 'end_time') DateTime? logoutTime,@JsonKey(name: 'date_created') DateTime? dateCreated
});




}
/// @nodoc
class _$AttendanceModelCopyWithImpl<$Res>
    implements $AttendanceModelCopyWith<$Res> {
  _$AttendanceModelCopyWithImpl(this._self, this._then);

  final AttendanceModel _self;
  final $Res Function(AttendanceModel) _then;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? requestedById = null,Object? loginTme = freezed,Object? logoutTime = freezed,Object? dateCreated = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,requestedById: null == requestedById ? _self.requestedById : requestedById // ignore: cast_nullable_to_non_nullable
as String,loginTme: freezed == loginTme ? _self.loginTme : loginTme // ignore: cast_nullable_to_non_nullable
as DateTime?,logoutTime: freezed == logoutTime ? _self.logoutTime : logoutTime // ignore: cast_nullable_to_non_nullable
as DateTime?,dateCreated: freezed == dateCreated ? _self.dateCreated : dateCreated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceModel].
extension AttendanceModelPatterns on AttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String requestedById, @JsonKey(name: 'start_time')  DateTime? loginTme, @JsonKey(name: 'end_time')  DateTime? logoutTime, @JsonKey(name: 'date_created')  DateTime? dateCreated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.uid,_that.requestedById,_that.loginTme,_that.logoutTime,_that.dateCreated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String requestedById, @JsonKey(name: 'start_time')  DateTime? loginTme, @JsonKey(name: 'end_time')  DateTime? logoutTime, @JsonKey(name: 'date_created')  DateTime? dateCreated)  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel():
return $default(_that.uid,_that.requestedById,_that.loginTme,_that.logoutTime,_that.dateCreated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String requestedById, @JsonKey(name: 'start_time')  DateTime? loginTme, @JsonKey(name: 'end_time')  DateTime? logoutTime, @JsonKey(name: 'date_created')  DateTime? dateCreated)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.uid,_that.requestedById,_that.loginTme,_that.logoutTime,_that.dateCreated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceModel implements AttendanceModel {
  const _AttendanceModel({required this.uid, required this.requestedById, @JsonKey(name: 'start_time') this.loginTme, @JsonKey(name: 'end_time') this.logoutTime, @JsonKey(name: 'date_created') this.dateCreated});
  factory _AttendanceModel.fromJson(Map<String, dynamic> json) => _$AttendanceModelFromJson(json);

@override final  String uid;
@override final  String requestedById;
@override@JsonKey(name: 'start_time') final  DateTime? loginTme;
@override@JsonKey(name: 'end_time') final  DateTime? logoutTime;
@override@JsonKey(name: 'date_created') final  DateTime? dateCreated;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceModelCopyWith<_AttendanceModel> get copyWith => __$AttendanceModelCopyWithImpl<_AttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.requestedById, requestedById) || other.requestedById == requestedById)&&(identical(other.loginTme, loginTme) || other.loginTme == loginTme)&&(identical(other.logoutTime, logoutTime) || other.logoutTime == logoutTime)&&(identical(other.dateCreated, dateCreated) || other.dateCreated == dateCreated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,requestedById,loginTme,logoutTime,dateCreated);

@override
String toString() {
  return 'AttendanceModel(uid: $uid, requestedById: $requestedById, loginTme: $loginTme, logoutTime: $logoutTime, dateCreated: $dateCreated)';
}


}

/// @nodoc
abstract mixin class _$AttendanceModelCopyWith<$Res> implements $AttendanceModelCopyWith<$Res> {
  factory _$AttendanceModelCopyWith(_AttendanceModel value, $Res Function(_AttendanceModel) _then) = __$AttendanceModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String requestedById,@JsonKey(name: 'start_time') DateTime? loginTme,@JsonKey(name: 'end_time') DateTime? logoutTime,@JsonKey(name: 'date_created') DateTime? dateCreated
});




}
/// @nodoc
class __$AttendanceModelCopyWithImpl<$Res>
    implements _$AttendanceModelCopyWith<$Res> {
  __$AttendanceModelCopyWithImpl(this._self, this._then);

  final _AttendanceModel _self;
  final $Res Function(_AttendanceModel) _then;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? requestedById = null,Object? loginTme = freezed,Object? logoutTime = freezed,Object? dateCreated = freezed,}) {
  return _then(_AttendanceModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,requestedById: null == requestedById ? _self.requestedById : requestedById // ignore: cast_nullable_to_non_nullable
as String,loginTme: freezed == loginTme ? _self.loginTme : loginTme // ignore: cast_nullable_to_non_nullable
as DateTime?,logoutTime: freezed == logoutTime ? _self.logoutTime : logoutTime // ignore: cast_nullable_to_non_nullable
as DateTime?,dateCreated: freezed == dateCreated ? _self.dateCreated : dateCreated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
