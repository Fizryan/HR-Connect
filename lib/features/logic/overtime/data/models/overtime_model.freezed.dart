// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overtime_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OvertimeModel {

 String get uid; String get requestedById; String? get approvedById;@JsonKey(name: 'start_date') DateTime get startDate;@JsonKey(name: 'end_date') DateTime get endDate;@JsonKey(name: 'is_approved', defaultValue: false) bool get isApproved;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of OvertimeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OvertimeModelCopyWith<OvertimeModel> get copyWith => _$OvertimeModelCopyWithImpl<OvertimeModel>(this as OvertimeModel, _$identity);

  /// Serializes this OvertimeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OvertimeModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.requestedById, requestedById) || other.requestedById == requestedById)&&(identical(other.approvedById, approvedById) || other.approvedById == approvedById)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,requestedById,approvedById,startDate,endDate,isApproved,createdAt,updatedAt);

@override
String toString() {
  return 'OvertimeModel(uid: $uid, requestedById: $requestedById, approvedById: $approvedById, startDate: $startDate, endDate: $endDate, isApproved: $isApproved, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OvertimeModelCopyWith<$Res>  {
  factory $OvertimeModelCopyWith(OvertimeModel value, $Res Function(OvertimeModel) _then) = _$OvertimeModelCopyWithImpl;
@useResult
$Res call({
 String uid, String requestedById, String? approvedById,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate,@JsonKey(name: 'is_approved', defaultValue: false) bool isApproved,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$OvertimeModelCopyWithImpl<$Res>
    implements $OvertimeModelCopyWith<$Res> {
  _$OvertimeModelCopyWithImpl(this._self, this._then);

  final OvertimeModel _self;
  final $Res Function(OvertimeModel) _then;

/// Create a copy of OvertimeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? requestedById = null,Object? approvedById = freezed,Object? startDate = null,Object? endDate = null,Object? isApproved = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,requestedById: null == requestedById ? _self.requestedById : requestedById // ignore: cast_nullable_to_non_nullable
as String,approvedById: freezed == approvedById ? _self.approvedById : approvedById // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OvertimeModel].
extension OvertimeModelPatterns on OvertimeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OvertimeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OvertimeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OvertimeModel value)  $default,){
final _that = this;
switch (_that) {
case _OvertimeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OvertimeModel value)?  $default,){
final _that = this;
switch (_that) {
case _OvertimeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String requestedById,  String? approvedById, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(name: 'is_approved', defaultValue: false)  bool isApproved, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OvertimeModel() when $default != null:
return $default(_that.uid,_that.requestedById,_that.approvedById,_that.startDate,_that.endDate,_that.isApproved,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String requestedById,  String? approvedById, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(name: 'is_approved', defaultValue: false)  bool isApproved, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OvertimeModel():
return $default(_that.uid,_that.requestedById,_that.approvedById,_that.startDate,_that.endDate,_that.isApproved,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String requestedById,  String? approvedById, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(name: 'is_approved', defaultValue: false)  bool isApproved, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OvertimeModel() when $default != null:
return $default(_that.uid,_that.requestedById,_that.approvedById,_that.startDate,_that.endDate,_that.isApproved,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OvertimeModel implements OvertimeModel {
  const _OvertimeModel({required this.uid, required this.requestedById, this.approvedById, @JsonKey(name: 'start_date') required this.startDate, @JsonKey(name: 'end_date') required this.endDate, @JsonKey(name: 'is_approved', defaultValue: false) required this.isApproved, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _OvertimeModel.fromJson(Map<String, dynamic> json) => _$OvertimeModelFromJson(json);

@override final  String uid;
@override final  String requestedById;
@override final  String? approvedById;
@override@JsonKey(name: 'start_date') final  DateTime startDate;
@override@JsonKey(name: 'end_date') final  DateTime endDate;
@override@JsonKey(name: 'is_approved', defaultValue: false) final  bool isApproved;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of OvertimeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OvertimeModelCopyWith<_OvertimeModel> get copyWith => __$OvertimeModelCopyWithImpl<_OvertimeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OvertimeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OvertimeModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.requestedById, requestedById) || other.requestedById == requestedById)&&(identical(other.approvedById, approvedById) || other.approvedById == approvedById)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,requestedById,approvedById,startDate,endDate,isApproved,createdAt,updatedAt);

@override
String toString() {
  return 'OvertimeModel(uid: $uid, requestedById: $requestedById, approvedById: $approvedById, startDate: $startDate, endDate: $endDate, isApproved: $isApproved, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OvertimeModelCopyWith<$Res> implements $OvertimeModelCopyWith<$Res> {
  factory _$OvertimeModelCopyWith(_OvertimeModel value, $Res Function(_OvertimeModel) _then) = __$OvertimeModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String requestedById, String? approvedById,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate,@JsonKey(name: 'is_approved', defaultValue: false) bool isApproved,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$OvertimeModelCopyWithImpl<$Res>
    implements _$OvertimeModelCopyWith<$Res> {
  __$OvertimeModelCopyWithImpl(this._self, this._then);

  final _OvertimeModel _self;
  final $Res Function(_OvertimeModel) _then;

/// Create a copy of OvertimeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? requestedById = null,Object? approvedById = freezed,Object? startDate = null,Object? endDate = null,Object? isApproved = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_OvertimeModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,requestedById: null == requestedById ? _self.requestedById : requestedById // ignore: cast_nullable_to_non_nullable
as String,approvedById: freezed == approvedById ? _self.approvedById : approvedById // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
