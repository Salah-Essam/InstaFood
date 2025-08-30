import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';

class AuthMessageBanner extends StatelessWidget {
  const AuthMessageBanner({super.key});

  Color _color(AuthState state) {
    if (state is AuthError || state is PasswordResetEmailFailed) return AppColors.error;
    if (state is PasswordResetEmailSent) return Colors.green;
    if (state is AuthShouldShowPasswordReset) return Colors.orange;
    return Colors.transparent;
  }

  String? _text(AuthState state) {
    if (state is AuthError) return state.message;
    if (state is PasswordResetEmailSent) return 'Password reset email sent to ${state.email}';
    if (state is PasswordResetEmailFailed) return state.message;
    if (state is AuthShouldShowPasswordReset) return 'Too many failed attempts. Reset your password?';
    return null;
  }

  IconData? _icon(AuthState state) {
    if (state is AuthError || state is PasswordResetEmailFailed) return Icons.error_outline;
    if (state is PasswordResetEmailSent) return Icons.check_circle_outline;
    if (state is AuthShouldShowPasswordReset) return Icons.info_outline;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev != curr,
      builder: (context, state) {
        final message = _text(state);
        if (message == null) return const SizedBox.shrink();
        final color = _color(state);
        final icon = _icon(state);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (state is AuthShouldShowPasswordReset)
                TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().changePasswordByEmail(state.email);
                  },
                  child: const Text('RESET'),
                ),
            ],
          ),
        );
      },
    );
  }
}
