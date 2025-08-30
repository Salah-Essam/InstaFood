import 'package:equatable/equatable.dart';
import 'package:insta_food/presentation/features/auth/data/model/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthShouldShowPasswordReset extends AuthState {
  final String email;
  AuthShouldShowPasswordReset(this.email);

  @override
  List<Object?> get props => [email];
}

// Emitted when a password reset email has been successfully sent.
class PasswordResetEmailSent extends AuthState {
  final String email;
  PasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

// Emitted when sending a password reset email failed.
class PasswordResetEmailFailed extends AuthState {
  final String message;
  PasswordResetEmailFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthInvalidCredentials extends AuthState {
  final String message;
  AuthInvalidCredentials([this.message = 'Invalid email or password']);
  @override
  List<Object?> get props => [message];
}

class PasswordChangeSuccess extends AuthState {
  final String message;
  PasswordChangeSuccess([this.message = 'Password changed successfully']);
  @override
  List<Object?> get props => [message];
}

class AuthFormValidationFailed extends AuthState {
  final String message;
  AuthFormValidationFailed(this.message);
  @override
  List<Object?> get props => [message];
}
