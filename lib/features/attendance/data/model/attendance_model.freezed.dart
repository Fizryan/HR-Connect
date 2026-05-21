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

 String get scannedAt;
/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceModelCopyWith<AttendanceModel> get copyWith => _$AttendanceModelCopyWithImpl<AttendanceModel>(this as AttendanceModel, _$identity);

  /// Serializes this AttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceModel&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scannedAt);

@override
String toString() {
  return 'AttendanceModel(scannedAt: $scannedAt)';
}


}

/// @nodoc
abstract mixin class $AttendanceModelCopyWith<$Res>  {
  factory $AttendanceModelCopyWith(AttendanceModel value, $Res Function(AttendanceModel) _then) = _$AttendanceModelCopyWithImpl;
@useResult
$Res call({
 String scannedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? scannedAt = null,}) {
  return _then(_self.copyWith(
scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String scannedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.scannedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String scannedAt)  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel():
return $default(_that.scannedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String scannedAt)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.scannedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceModel implements AttendanceModel {
  const _AttendanceModel({required this.scannedAt});
  factory _AttendanceModel.fromJson(Map<String, dynamic> json) => _$AttendanceModelFromJson(json);

@override final  String scannedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceModel&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scannedAt);

@override
String toString() {
  return 'AttendanceModel(scannedAt: $scannedAt)';
}


}

/// @nodoc
abstract mixin class _$AttendanceModelCopyWith<$Res> implements $AttendanceModelCopyWith<$Res> {
  factory _$AttendanceModelCopyWith(_AttendanceModel value, $Res Function(_AttendanceModel) _then) = __$AttendanceModelCopyWithImpl;
@override @useResult
$Res call({
 String scannedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? scannedAt = null,}) {
  return _then(_AttendanceModel(
scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UserAttendanceModel {

 String get userId; List<AttendanceModel> get attendance;
/// Create a copy of UserAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAttendanceModelCopyWith<UserAttendanceModel> get copyWith => _$UserAttendanceModelCopyWithImpl<UserAttendanceModel>(this as UserAttendanceModel, _$identity);

  /// Serializes this UserAttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAttendanceModel&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.attendance, attendance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(attendance));

@override
String toString() {
  return 'UserAttendanceModel(userId: $userId, attendance: $attendance)';
}


}

/// @nodoc
abstract mixin class $UserAttendanceModelCopyWith<$Res>  {
  factory $UserAttendanceModelCopyWith(UserAttendanceModel value, $Res Function(UserAttendanceModel) _then) = _$UserAttendanceModelCopyWithImpl;
@useResult
$Res call({
 String userId, List<AttendanceModel> attendance
});




}
/// @nodoc
class _$UserAttendanceModelCopyWithImpl<$Res>
    implements $UserAttendanceModelCopyWith<$Res> {
  _$UserAttendanceModelCopyWithImpl(this._self, this._then);

  final UserAttendanceModel _self;
  final $Res Function(UserAttendanceModel) _then;

/// Create a copy of UserAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? attendance = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAttendanceModel].
extension UserAttendanceModelPatterns on UserAttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _UserAttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserAttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  List<AttendanceModel> attendance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAttendanceModel() when $default != null:
return $default(_that.userId,_that.attendance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  List<AttendanceModel> attendance)  $default,) {final _that = this;
switch (_that) {
case _UserAttendanceModel():
return $default(_that.userId,_that.attendance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  List<AttendanceModel> attendance)?  $default,) {final _that = this;
switch (_that) {
case _UserAttendanceModel() when $default != null:
return $default(_that.userId,_that.attendance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAttendanceModel implements UserAttendanceModel {
  const _UserAttendanceModel({required this.userId, final  List<AttendanceModel> attendance = const []}): _attendance = attendance;
  factory _UserAttendanceModel.fromJson(Map<String, dynamic> json) => _$UserAttendanceModelFromJson(json);

@override final  String userId;
 final  List<AttendanceModel> _attendance;
@override@JsonKey() List<AttendanceModel> get attendance {
  if (_attendance is EqualUnmodifiableListView) return _attendance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attendance);
}


/// Create a copy of UserAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAttendanceModelCopyWith<_UserAttendanceModel> get copyWith => __$UserAttendanceModelCopyWithImpl<_UserAttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAttendanceModel&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._attendance, _attendance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(_attendance));

@override
String toString() {
  return 'UserAttendanceModel(userId: $userId, attendance: $attendance)';
}


}

/// @nodoc
abstract mixin class _$UserAttendanceModelCopyWith<$Res> implements $UserAttendanceModelCopyWith<$Res> {
  factory _$UserAttendanceModelCopyWith(_UserAttendanceModel value, $Res Function(_UserAttendanceModel) _then) = __$UserAttendanceModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, List<AttendanceModel> attendance
});




}
/// @nodoc
class __$UserAttendanceModelCopyWithImpl<$Res>
    implements _$UserAttendanceModelCopyWith<$Res> {
  __$UserAttendanceModelCopyWithImpl(this._self, this._then);

  final _UserAttendanceModel _self;
  final $Res Function(_UserAttendanceModel) _then;

/// Create a copy of UserAttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? attendance = null,}) {
  return _then(_UserAttendanceModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,attendance: null == attendance ? _self._attendance : attendance // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>,
  ));
}


}


/// @nodoc
mixin _$AttendanceGenerateModel {

 String get png; String get url;
/// Create a copy of AttendanceGenerateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceGenerateModelCopyWith<AttendanceGenerateModel> get copyWith => _$AttendanceGenerateModelCopyWithImpl<AttendanceGenerateModel>(this as AttendanceGenerateModel, _$identity);

  /// Serializes this AttendanceGenerateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceGenerateModel&&(identical(other.png, png) || other.png == png)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,png,url);

@override
String toString() {
  return 'AttendanceGenerateModel(png: $png, url: $url)';
}


}

/// @nodoc
abstract mixin class $AttendanceGenerateModelCopyWith<$Res>  {
  factory $AttendanceGenerateModelCopyWith(AttendanceGenerateModel value, $Res Function(AttendanceGenerateModel) _then) = _$AttendanceGenerateModelCopyWithImpl;
@useResult
$Res call({
 String png, String url
});




}
/// @nodoc
class _$AttendanceGenerateModelCopyWithImpl<$Res>
    implements $AttendanceGenerateModelCopyWith<$Res> {
  _$AttendanceGenerateModelCopyWithImpl(this._self, this._then);

  final AttendanceGenerateModel _self;
  final $Res Function(AttendanceGenerateModel) _then;

/// Create a copy of AttendanceGenerateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? png = null,Object? url = null,}) {
  return _then(_self.copyWith(
png: null == png ? _self.png : png // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceGenerateModel].
extension AttendanceGenerateModelPatterns on AttendanceGenerateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceGenerateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceGenerateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceGenerateModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceGenerateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceGenerateModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceGenerateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String png,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceGenerateModel() when $default != null:
return $default(_that.png,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String png,  String url)  $default,) {final _that = this;
switch (_that) {
case _AttendanceGenerateModel():
return $default(_that.png,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String png,  String url)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceGenerateModel() when $default != null:
return $default(_that.png,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceGenerateModel implements AttendanceGenerateModel {
  const _AttendanceGenerateModel({required this.png, required this.url});
  factory _AttendanceGenerateModel.fromJson(Map<String, dynamic> json) => _$AttendanceGenerateModelFromJson(json);

@override final  String png;
@override final  String url;

/// Create a copy of AttendanceGenerateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceGenerateModelCopyWith<_AttendanceGenerateModel> get copyWith => __$AttendanceGenerateModelCopyWithImpl<_AttendanceGenerateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceGenerateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceGenerateModel&&(identical(other.png, png) || other.png == png)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,png,url);

@override
String toString() {
  return 'AttendanceGenerateModel(png: $png, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AttendanceGenerateModelCopyWith<$Res> implements $AttendanceGenerateModelCopyWith<$Res> {
  factory _$AttendanceGenerateModelCopyWith(_AttendanceGenerateModel value, $Res Function(_AttendanceGenerateModel) _then) = __$AttendanceGenerateModelCopyWithImpl;
@override @useResult
$Res call({
 String png, String url
});




}
/// @nodoc
class __$AttendanceGenerateModelCopyWithImpl<$Res>
    implements _$AttendanceGenerateModelCopyWith<$Res> {
  __$AttendanceGenerateModelCopyWithImpl(this._self, this._then);

  final _AttendanceGenerateModel _self;
  final $Res Function(_AttendanceGenerateModel) _then;

/// Create a copy of AttendanceGenerateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? png = null,Object? url = null,}) {
  return _then(_AttendanceGenerateModel(
png: null == png ? _self.png : png // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
