// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForgotPasswordState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForgotPasswordState()';
}


}

/// @nodoc
class $ForgotPasswordStateCopyWith<$Res>  {
$ForgotPasswordStateCopyWith(ForgotPasswordState _, $Res Function(ForgotPasswordState) __);
}


/// Adds pattern-matching-related methods to [ForgotPasswordState].
extension ForgotPasswordStatePatterns on ForgotPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _SentOtpSuccess value)?  sentOtpSuccess,TResult Function( _VerifyOtpSuccess value)?  verifyOtpSuccess,TResult Function( _ResetPasswordSuccess value)?  resetPasswordSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _SentOtpSuccess() when sentOtpSuccess != null:
return sentOtpSuccess(_that);case _VerifyOtpSuccess() when verifyOtpSuccess != null:
return verifyOtpSuccess(_that);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _SentOtpSuccess value)  sentOtpSuccess,required TResult Function( _VerifyOtpSuccess value)  verifyOtpSuccess,required TResult Function( _ResetPasswordSuccess value)  resetPasswordSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _SentOtpSuccess():
return sentOtpSuccess(_that);case _VerifyOtpSuccess():
return verifyOtpSuccess(_that);case _ResetPasswordSuccess():
return resetPasswordSuccess(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _SentOtpSuccess value)?  sentOtpSuccess,TResult? Function( _VerifyOtpSuccess value)?  verifyOtpSuccess,TResult? Function( _ResetPasswordSuccess value)?  resetPasswordSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _SentOtpSuccess() when sentOtpSuccess != null:
return sentOtpSuccess(_that);case _VerifyOtpSuccess() when verifyOtpSuccess != null:
return verifyOtpSuccess(_that);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String phone,  String message)?  sentOtpSuccess,TResult Function( String message)?  verifyOtpSuccess,TResult Function( String message)?  resetPasswordSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _SentOtpSuccess() when sentOtpSuccess != null:
return sentOtpSuccess(_that.phone,_that.message);case _VerifyOtpSuccess() when verifyOtpSuccess != null:
return verifyOtpSuccess(_that.message);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that.message);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String phone,  String message)  sentOtpSuccess,required TResult Function( String message)  verifyOtpSuccess,required TResult Function( String message)  resetPasswordSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _SentOtpSuccess():
return sentOtpSuccess(_that.phone,_that.message);case _VerifyOtpSuccess():
return verifyOtpSuccess(_that.message);case _ResetPasswordSuccess():
return resetPasswordSuccess(_that.message);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String phone,  String message)?  sentOtpSuccess,TResult? Function( String message)?  verifyOtpSuccess,TResult? Function( String message)?  resetPasswordSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _SentOtpSuccess() when sentOtpSuccess != null:
return sentOtpSuccess(_that.phone,_that.message);case _VerifyOtpSuccess() when verifyOtpSuccess != null:
return verifyOtpSuccess(_that.message);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ForgotPasswordState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForgotPasswordState.initial()';
}


}




/// @nodoc


class _Loading implements ForgotPasswordState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForgotPasswordState.loading()';
}


}




/// @nodoc


class _SentOtpSuccess implements ForgotPasswordState {
  const _SentOtpSuccess(this.phone, this.message);
  

 final  String phone;
 final  String message;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentOtpSuccessCopyWith<_SentOtpSuccess> get copyWith => __$SentOtpSuccessCopyWithImpl<_SentOtpSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentOtpSuccess&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,phone,message);

@override
String toString() {
  return 'ForgotPasswordState.sentOtpSuccess(phone: $phone, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SentOtpSuccessCopyWith<$Res> implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$SentOtpSuccessCopyWith(_SentOtpSuccess value, $Res Function(_SentOtpSuccess) _then) = __$SentOtpSuccessCopyWithImpl;
@useResult
$Res call({
 String phone, String message
});




}
/// @nodoc
class __$SentOtpSuccessCopyWithImpl<$Res>
    implements _$SentOtpSuccessCopyWith<$Res> {
  __$SentOtpSuccessCopyWithImpl(this._self, this._then);

  final _SentOtpSuccess _self;
  final $Res Function(_SentOtpSuccess) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? message = null,}) {
  return _then(_SentOtpSuccess(
null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _VerifyOtpSuccess implements ForgotPasswordState {
  const _VerifyOtpSuccess(this.message);
  

 final  String message;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpSuccessCopyWith<_VerifyOtpSuccess> get copyWith => __$VerifyOtpSuccessCopyWithImpl<_VerifyOtpSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtpSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ForgotPasswordState.verifyOtpSuccess(message: $message)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpSuccessCopyWith<$Res> implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$VerifyOtpSuccessCopyWith(_VerifyOtpSuccess value, $Res Function(_VerifyOtpSuccess) _then) = __$VerifyOtpSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$VerifyOtpSuccessCopyWithImpl<$Res>
    implements _$VerifyOtpSuccessCopyWith<$Res> {
  __$VerifyOtpSuccessCopyWithImpl(this._self, this._then);

  final _VerifyOtpSuccess _self;
  final $Res Function(_VerifyOtpSuccess) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_VerifyOtpSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ResetPasswordSuccess implements ForgotPasswordState {
  const _ResetPasswordSuccess(this.message);
  

 final  String message;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetPasswordSuccessCopyWith<_ResetPasswordSuccess> get copyWith => __$ResetPasswordSuccessCopyWithImpl<_ResetPasswordSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ForgotPasswordState.resetPasswordSuccess(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ResetPasswordSuccessCopyWith<$Res> implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$ResetPasswordSuccessCopyWith(_ResetPasswordSuccess value, $Res Function(_ResetPasswordSuccess) _then) = __$ResetPasswordSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ResetPasswordSuccessCopyWithImpl<$Res>
    implements _$ResetPasswordSuccessCopyWith<$Res> {
  __$ResetPasswordSuccessCopyWithImpl(this._self, this._then);

  final _ResetPasswordSuccess _self;
  final $Res Function(_ResetPasswordSuccess) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ResetPasswordSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements ForgotPasswordState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ForgotPasswordState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
