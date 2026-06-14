// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppInfoModel {

 String get appName; String get packageName; String get version; String get buildNumber;
/// Create a copy of AppInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppInfoModelCopyWith<AppInfoModel> get copyWith => _$AppInfoModelCopyWithImpl<AppInfoModel>(this as AppInfoModel, _$identity);

  /// Serializes this AppInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInfoModel&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.version, version) || other.version == version)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,packageName,version,buildNumber);

@override
String toString() {
  return 'AppInfoModel(appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber)';
}


}

/// @nodoc
abstract mixin class $AppInfoModelCopyWith<$Res>  {
  factory $AppInfoModelCopyWith(AppInfoModel value, $Res Function(AppInfoModel) _then) = _$AppInfoModelCopyWithImpl;
@useResult
$Res call({
 String appName, String packageName, String version, String buildNumber
});




}
/// @nodoc
class _$AppInfoModelCopyWithImpl<$Res>
    implements $AppInfoModelCopyWith<$Res> {
  _$AppInfoModelCopyWithImpl(this._self, this._then);

  final AppInfoModel _self;
  final $Res Function(AppInfoModel) _then;

/// Create a copy of AppInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = null,Object? packageName = null,Object? version = null,Object? buildNumber = null,}) {
  return _then(_self.copyWith(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppInfoModel].
extension AppInfoModelPatterns on AppInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _AppInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appName,  String packageName,  String version,  String buildNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppInfoModel() when $default != null:
return $default(_that.appName,_that.packageName,_that.version,_that.buildNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appName,  String packageName,  String version,  String buildNumber)  $default,) {final _that = this;
switch (_that) {
case _AppInfoModel():
return $default(_that.appName,_that.packageName,_that.version,_that.buildNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appName,  String packageName,  String version,  String buildNumber)?  $default,) {final _that = this;
switch (_that) {
case _AppInfoModel() when $default != null:
return $default(_that.appName,_that.packageName,_that.version,_that.buildNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppInfoModel implements AppInfoModel {
  const _AppInfoModel({this.appName = '', this.packageName = '', this.version = '', this.buildNumber = ''});
  factory _AppInfoModel.fromJson(Map<String, dynamic> json) => _$AppInfoModelFromJson(json);

@override@JsonKey() final  String appName;
@override@JsonKey() final  String packageName;
@override@JsonKey() final  String version;
@override@JsonKey() final  String buildNumber;

/// Create a copy of AppInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppInfoModelCopyWith<_AppInfoModel> get copyWith => __$AppInfoModelCopyWithImpl<_AppInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppInfoModel&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.version, version) || other.version == version)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,packageName,version,buildNumber);

@override
String toString() {
  return 'AppInfoModel(appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber)';
}


}

/// @nodoc
abstract mixin class _$AppInfoModelCopyWith<$Res> implements $AppInfoModelCopyWith<$Res> {
  factory _$AppInfoModelCopyWith(_AppInfoModel value, $Res Function(_AppInfoModel) _then) = __$AppInfoModelCopyWithImpl;
@override @useResult
$Res call({
 String appName, String packageName, String version, String buildNumber
});




}
/// @nodoc
class __$AppInfoModelCopyWithImpl<$Res>
    implements _$AppInfoModelCopyWith<$Res> {
  __$AppInfoModelCopyWithImpl(this._self, this._then);

  final _AppInfoModel _self;
  final $Res Function(_AppInfoModel) _then;

/// Create a copy of AppInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = null,Object? packageName = null,Object? version = null,Object? buildNumber = null,}) {
  return _then(_AppInfoModel(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
