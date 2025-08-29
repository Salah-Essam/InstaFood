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
