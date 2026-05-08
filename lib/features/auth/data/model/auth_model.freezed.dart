// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AuthModel _$AuthModelFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'success':
          return _AuthSuccess.fromJson(
            json
          );
                case 'error':
          return _AuthError.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'AuthModel',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$AuthModel {



  /// Serializes this AuthModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthModel);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthModel()';
}


}

/// @nodoc
class $AuthModelCopyWith<$Res>  {
$AuthModelCopyWith(AuthModel _, $Res Function(AuthModel) __);
}


/// Adds pattern-matching-related methods to [AuthModel].
extension AuthModelPatterns on AuthModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AuthSuccess value)?  success,TResult Function( _AuthError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSuccess() when success != null:
return success(_that);case _AuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AuthSuccess value)  success,required TResult Function( _AuthError value)  error,}){
final _that = this;
switch (_that) {
case _AuthSuccess():
return success(_that);case _AuthError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AuthSuccess value)?  success,TResult? Function( _AuthError value)?  error,}){
final _that = this;
switch (_that) {
case _AuthSuccess() when success != null:
return success(_that);case _AuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@JsonKey(name: 'accessToken')  String accessToken, @JsonKey(name: 'expTime')  String expTime, @JsonKey(name: 'refreshToken')  String refreshToken)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSuccess() when success != null:
return success(_that.accessToken,_that.expTime,_that.refreshToken);case _AuthError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@JsonKey(name: 'accessToken')  String accessToken, @JsonKey(name: 'expTime')  String expTime, @JsonKey(name: 'refreshToken')  String refreshToken)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _AuthSuccess():
return success(_that.accessToken,_that.expTime,_that.refreshToken);case _AuthError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@JsonKey(name: 'accessToken')  String accessToken, @JsonKey(name: 'expTime')  String expTime, @JsonKey(name: 'refreshToken')  String refreshToken)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _AuthSuccess() when success != null:
return success(_that.accessToken,_that.expTime,_that.refreshToken);case _AuthError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthSuccess implements AuthModel {
  const _AuthSuccess({@JsonKey(name: 'accessToken') required this.accessToken, @JsonKey(name: 'expTime') required this.expTime, @JsonKey(name: 'refreshToken') required this.refreshToken, final  String? $type}): $type = $type ?? 'success';
  factory _AuthSuccess.fromJson(Map<String, dynamic> json) => _$AuthSuccessFromJson(json);

@JsonKey(name: 'accessToken') final  String accessToken;
@JsonKey(name: 'expTime') final  String expTime;
@JsonKey(name: 'refreshToken') final  String refreshToken;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSuccessCopyWith<_AuthSuccess> get copyWith => __$AuthSuccessCopyWithImpl<_AuthSuccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthSuccessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSuccess&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.expTime, expTime) || other.expTime == expTime)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,expTime,refreshToken);

@override
String toString() {
  return 'AuthModel.success(accessToken: $accessToken, expTime: $expTime, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$AuthSuccessCopyWith<$Res> implements $AuthModelCopyWith<$Res> {
  factory _$AuthSuccessCopyWith(_AuthSuccess value, $Res Function(_AuthSuccess) _then) = __$AuthSuccessCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'accessToken') String accessToken,@JsonKey(name: 'expTime') String expTime,@JsonKey(name: 'refreshToken') String refreshToken
});




}
/// @nodoc
class __$AuthSuccessCopyWithImpl<$Res>
    implements _$AuthSuccessCopyWith<$Res> {
  __$AuthSuccessCopyWithImpl(this._self, this._then);

  final _AuthSuccess _self;
  final $Res Function(_AuthSuccess) _then;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? expTime = null,Object? refreshToken = null,}) {
  return _then(_AuthSuccess(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expTime: null == expTime ? _self.expTime : expTime // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _AuthError implements AuthModel {
  const _AuthError({required this.message, final  String? $type}): $type = $type ?? 'error';
  factory _AuthError.fromJson(Map<String, dynamic> json) => _$AuthErrorFromJson(json);

 final  String message;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthErrorCopyWith<_AuthError> get copyWith => __$AuthErrorCopyWithImpl<_AuthError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthError&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthModel.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AuthErrorCopyWith<$Res> implements $AuthModelCopyWith<$Res> {
  factory _$AuthErrorCopyWith(_AuthError value, $Res Function(_AuthError) _then) = __$AuthErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AuthErrorCopyWithImpl<$Res>
    implements _$AuthErrorCopyWith<$Res> {
  __$AuthErrorCopyWithImpl(this._self, this._then);

  final _AuthError _self;
  final $Res Function(_AuthError) _then;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AuthError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
