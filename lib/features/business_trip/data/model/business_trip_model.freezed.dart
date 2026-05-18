// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessTripModel {

 String get id; String get requestId; BusinessTripType get businessTripType; String? get description; String? get approverId; RequestStatus get status; DateTime get startDate; DateTime get endDate; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of BusinessTripModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessTripModelCopyWith<BusinessTripModel> get copyWith => _$BusinessTripModelCopyWithImpl<BusinessTripModel>(this as BusinessTripModel, _$identity);

  /// Serializes this BusinessTripModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessTripModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.businessTripType, businessTripType) || other.businessTripType == businessTripType)&&(identical(other.description, description) || other.description == description)&&(identical(other.approverId, approverId) || other.approverId == approverId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,businessTripType,description,approverId,status,startDate,endDate,createdAt,updatedAt);

@override
String toString() {
  return 'BusinessTripModel(id: $id, requestId: $requestId, businessTripType: $businessTripType, description: $description, approverId: $approverId, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BusinessTripModelCopyWith<$Res>  {
  factory $BusinessTripModelCopyWith(BusinessTripModel value, $Res Function(BusinessTripModel) _then) = _$BusinessTripModelCopyWithImpl;
@useResult
$Res call({
 String id, String requestId, BusinessTripType businessTripType, String? description, String? approverId, RequestStatus status, DateTime startDate, DateTime endDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BusinessTripModelCopyWithImpl<$Res>
    implements $BusinessTripModelCopyWith<$Res> {
  _$BusinessTripModelCopyWithImpl(this._self, this._then);

  final BusinessTripModel _self;
  final $Res Function(BusinessTripModel) _then;

/// Create a copy of BusinessTripModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? businessTripType = null,Object? description = freezed,Object? approverId = freezed,Object? status = null,Object? startDate = null,Object? endDate = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,businessTripType: null == businessTripType ? _self.businessTripType : businessTripType // ignore: cast_nullable_to_non_nullable
as BusinessTripType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,approverId: freezed == approverId ? _self.approverId : approverId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessTripModel].
extension BusinessTripModelPatterns on BusinessTripModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessTripModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessTripModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessTripModel value)  $default,){
final _that = this;
switch (_that) {
case _BusinessTripModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessTripModel value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessTripModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestId,  BusinessTripType businessTripType,  String? description,  String? approverId,  RequestStatus status,  DateTime startDate,  DateTime endDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessTripModel() when $default != null:
return $default(_that.id,_that.requestId,_that.businessTripType,_that.description,_that.approverId,_that.status,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestId,  BusinessTripType businessTripType,  String? description,  String? approverId,  RequestStatus status,  DateTime startDate,  DateTime endDate,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BusinessTripModel():
return $default(_that.id,_that.requestId,_that.businessTripType,_that.description,_that.approverId,_that.status,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestId,  BusinessTripType businessTripType,  String? description,  String? approverId,  RequestStatus status,  DateTime startDate,  DateTime endDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BusinessTripModel() when $default != null:
return $default(_that.id,_that.requestId,_that.businessTripType,_that.description,_that.approverId,_that.status,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessTripModel extends BusinessTripModel {
  const _BusinessTripModel({required this.id, required this.requestId, required this.businessTripType, this.description, this.approverId, this.status = RequestStatus.pending, required this.startDate, required this.endDate, this.createdAt, this.updatedAt}): super._();
  factory _BusinessTripModel.fromJson(Map<String, dynamic> json) => _$BusinessTripModelFromJson(json);

@override final  String id;
@override final  String requestId;
@override final  BusinessTripType businessTripType;
@override final  String? description;
@override final  String? approverId;
@override@JsonKey() final  RequestStatus status;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of BusinessTripModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessTripModelCopyWith<_BusinessTripModel> get copyWith => __$BusinessTripModelCopyWithImpl<_BusinessTripModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessTripModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessTripModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.businessTripType, businessTripType) || other.businessTripType == businessTripType)&&(identical(other.description, description) || other.description == description)&&(identical(other.approverId, approverId) || other.approverId == approverId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,businessTripType,description,approverId,status,startDate,endDate,createdAt,updatedAt);

@override
String toString() {
  return 'BusinessTripModel(id: $id, requestId: $requestId, businessTripType: $businessTripType, description: $description, approverId: $approverId, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BusinessTripModelCopyWith<$Res> implements $BusinessTripModelCopyWith<$Res> {
  factory _$BusinessTripModelCopyWith(_BusinessTripModel value, $Res Function(_BusinessTripModel) _then) = __$BusinessTripModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestId, BusinessTripType businessTripType, String? description, String? approverId, RequestStatus status, DateTime startDate, DateTime endDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BusinessTripModelCopyWithImpl<$Res>
    implements _$BusinessTripModelCopyWith<$Res> {
  __$BusinessTripModelCopyWithImpl(this._self, this._then);

  final _BusinessTripModel _self;
  final $Res Function(_BusinessTripModel) _then;

/// Create a copy of BusinessTripModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? businessTripType = null,Object? description = freezed,Object? approverId = freezed,Object? status = null,Object? startDate = null,Object? endDate = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BusinessTripModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,businessTripType: null == businessTripType ? _self.businessTripType : businessTripType // ignore: cast_nullable_to_non_nullable
as BusinessTripType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,approverId: freezed == approverId ? _self.approverId : approverId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
