// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardModel {

@JsonKey(name: 'attendanceRate') int get attendanceRate;@JsonKey(name: 'pendingLeave') int get pendingLeave;@JsonKey(name: 'pendingTrip') int get pendingTrip;@JsonKey(name: 'totalUser') int? get totalUser;
/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardModelCopyWith<DashboardModel> get copyWith => _$DashboardModelCopyWithImpl<DashboardModel>(this as DashboardModel, _$identity);

  /// Serializes this DashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardModel&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate)&&(identical(other.pendingLeave, pendingLeave) || other.pendingLeave == pendingLeave)&&(identical(other.pendingTrip, pendingTrip) || other.pendingTrip == pendingTrip)&&(identical(other.totalUser, totalUser) || other.totalUser == totalUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attendanceRate,pendingLeave,pendingTrip,totalUser);

@override
String toString() {
  return 'DashboardModel(attendanceRate: $attendanceRate, pendingLeave: $pendingLeave, pendingTrip: $pendingTrip, totalUser: $totalUser)';
}


}

/// @nodoc
abstract mixin class $DashboardModelCopyWith<$Res>  {
  factory $DashboardModelCopyWith(DashboardModel value, $Res Function(DashboardModel) _then) = _$DashboardModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'attendanceRate') int attendanceRate,@JsonKey(name: 'pendingLeave') int pendingLeave,@JsonKey(name: 'pendingTrip') int pendingTrip,@JsonKey(name: 'totalUser') int? totalUser
});




}
/// @nodoc
class _$DashboardModelCopyWithImpl<$Res>
    implements $DashboardModelCopyWith<$Res> {
  _$DashboardModelCopyWithImpl(this._self, this._then);

  final DashboardModel _self;
  final $Res Function(DashboardModel) _then;

/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attendanceRate = null,Object? pendingLeave = null,Object? pendingTrip = null,Object? totalUser = freezed,}) {
  return _then(_self.copyWith(
attendanceRate: null == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as int,pendingLeave: null == pendingLeave ? _self.pendingLeave : pendingLeave // ignore: cast_nullable_to_non_nullable
as int,pendingTrip: null == pendingTrip ? _self.pendingTrip : pendingTrip // ignore: cast_nullable_to_non_nullable
as int,totalUser: freezed == totalUser ? _self.totalUser : totalUser // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardModel].
extension DashboardModelPatterns on DashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'attendanceRate')  int attendanceRate, @JsonKey(name: 'pendingLeave')  int pendingLeave, @JsonKey(name: 'pendingTrip')  int pendingTrip, @JsonKey(name: 'totalUser')  int? totalUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
return $default(_that.attendanceRate,_that.pendingLeave,_that.pendingTrip,_that.totalUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'attendanceRate')  int attendanceRate, @JsonKey(name: 'pendingLeave')  int pendingLeave, @JsonKey(name: 'pendingTrip')  int pendingTrip, @JsonKey(name: 'totalUser')  int? totalUser)  $default,) {final _that = this;
switch (_that) {
case _DashboardModel():
return $default(_that.attendanceRate,_that.pendingLeave,_that.pendingTrip,_that.totalUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'attendanceRate')  int attendanceRate, @JsonKey(name: 'pendingLeave')  int pendingLeave, @JsonKey(name: 'pendingTrip')  int pendingTrip, @JsonKey(name: 'totalUser')  int? totalUser)?  $default,) {final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
return $default(_that.attendanceRate,_that.pendingLeave,_that.pendingTrip,_that.totalUser);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardModel implements DashboardModel {
  const _DashboardModel({@JsonKey(name: 'attendanceRate') required this.attendanceRate, @JsonKey(name: 'pendingLeave') required this.pendingLeave, @JsonKey(name: 'pendingTrip') required this.pendingTrip, @JsonKey(name: 'totalUser') this.totalUser});
  factory _DashboardModel.fromJson(Map<String, dynamic> json) => _$DashboardModelFromJson(json);

@override@JsonKey(name: 'attendanceRate') final  int attendanceRate;
@override@JsonKey(name: 'pendingLeave') final  int pendingLeave;
@override@JsonKey(name: 'pendingTrip') final  int pendingTrip;
@override@JsonKey(name: 'totalUser') final  int? totalUser;

/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardModelCopyWith<_DashboardModel> get copyWith => __$DashboardModelCopyWithImpl<_DashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardModel&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate)&&(identical(other.pendingLeave, pendingLeave) || other.pendingLeave == pendingLeave)&&(identical(other.pendingTrip, pendingTrip) || other.pendingTrip == pendingTrip)&&(identical(other.totalUser, totalUser) || other.totalUser == totalUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attendanceRate,pendingLeave,pendingTrip,totalUser);

@override
String toString() {
  return 'DashboardModel(attendanceRate: $attendanceRate, pendingLeave: $pendingLeave, pendingTrip: $pendingTrip, totalUser: $totalUser)';
}


}

/// @nodoc
abstract mixin class _$DashboardModelCopyWith<$Res> implements $DashboardModelCopyWith<$Res> {
  factory _$DashboardModelCopyWith(_DashboardModel value, $Res Function(_DashboardModel) _then) = __$DashboardModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'attendanceRate') int attendanceRate,@JsonKey(name: 'pendingLeave') int pendingLeave,@JsonKey(name: 'pendingTrip') int pendingTrip,@JsonKey(name: 'totalUser') int? totalUser
});




}
/// @nodoc
class __$DashboardModelCopyWithImpl<$Res>
    implements _$DashboardModelCopyWith<$Res> {
  __$DashboardModelCopyWithImpl(this._self, this._then);

  final _DashboardModel _self;
  final $Res Function(_DashboardModel) _then;

/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attendanceRate = null,Object? pendingLeave = null,Object? pendingTrip = null,Object? totalUser = freezed,}) {
  return _then(_DashboardModel(
attendanceRate: null == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as int,pendingLeave: null == pendingLeave ? _self.pendingLeave : pendingLeave // ignore: cast_nullable_to_non_nullable
as int,pendingTrip: null == pendingTrip ? _self.pendingTrip : pendingTrip // ignore: cast_nullable_to_non_nullable
as int,totalUser: freezed == totalUser ? _self.totalUser : totalUser // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
