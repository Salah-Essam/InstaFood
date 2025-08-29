import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/auth/data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  int _failedLoginAttempts = 0;
  String? _lastAttemptedEmail;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String dob,
    required String phone,
  }) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.signUp(
        fullName: fullName,
        email: email,
        password: password,
        dateOfBirth: dob,
        phone: phone,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        _failedLoginAttempts = 0; // Reset on successful login
        _lastAttemptedEmail = null;
        emit(Authenticated(user));
      } else {
        _failedLoginAttempts++;
        _lastAttemptedEmail = email;
        
        if (_failedLoginAttempts >= 3) {
          emit(AuthShouldShowPasswordReset(email));
        } else {
          emit(AuthError('Invalid email or password'));
        }
      }
    } catch (e) {
      _failedLoginAttempts++;
      _lastAttemptedEmail = email;
      
      if (_failedLoginAttempts >= 3) {
        emit(AuthShouldShowPasswordReset(email));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> setPassword(String newPassword) async {
    try {
      emit(AuthLoading());
      await _authRepository.setPassword(newPassword);
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void checkAuthStatus() {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // Method to change password by email (for forgot password)
  Future<void> changePasswordByEmail(String email, String newPassword) async {
    try {
      emit(AuthLoading());
      final success = await _authRepository.changePasswordByEmail(email, newPassword);
      if (success) {
        _failedLoginAttempts = 0; // Reset failed attempts
        _lastAttemptedEmail = null;
        emit(AuthError('Password updated successfully. Please login with your new password.'));
      } else {
        emit(AuthError('Failed to update password. User not found.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Check if user exists by email
  Future<bool> checkUserExistsByEmail(String email) async {
    return await _authRepository.userExistsByEmail(email);
  }

  // Reset failed login attempts
  void resetFailedAttempts() {
    _failedLoginAttempts = 0;
    _lastAttemptedEmail = null;
  }

  // Get the last attempted email
  String? get lastAttemptedEmail => _lastAttemptedEmail;
}
