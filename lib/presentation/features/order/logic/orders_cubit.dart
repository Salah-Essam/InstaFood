import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/order/data/models/order_model.dart';
import 'package:insta_food/presentation/features/order/data/repos/orders_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository repo;
  final AuthCubit auth;

  StreamSubscription<List<OrderModel>>? _subActive;
  StreamSubscription<List<OrderModel>>? _subCompleted;
  StreamSubscription<List<OrderModel>>? _subCancelled;
  StreamSubscription<AuthState>? _authSub;

  OrdersCubit({required this.repo, required this.auth}) : super(OrdersState.initial());

  void init() {
    // Always attach auth listener (once)
    _authSub ??= auth.stream.listen(_handleAuthChange);
    // Immediately handle the current auth state
    _handleAuthChange(auth.state);
  }

  void _handleAuthChange(AuthState authState) {
    if (authState is Authenticated && (authState.user.id ?? '').isNotEmpty) {
      _startOrderStreams(authState.user.id!);
    } else if (authState is Unauthenticated) {
      _stopOrderStreams(reset: true);
    }
  }

  void _startOrderStreams(String uid) {
    // restart streams for provided uid
    _stopOrderStreams(reset: false);
    _subActive = repo.watchByStatus(uid, 'active').listen((data) {
      emit(state.copyWith(active: data));
      _maybeScheduleAutoComplete(uid, data);
    });
    _subCompleted = repo.watchByStatus(uid, 'completed').listen((data) {
      emit(state.copyWith(completed: data));
    });
    _subCancelled = repo.watchByStatus(uid, 'cancelled').listen((data) {
      emit(state.copyWith(cancelled: data));
    });
  }

  void _stopOrderStreams({required bool reset}) {
    _subActive?.cancel();
    _subCompleted?.cancel();
    _subCancelled?.cancel();
    _subActive = null;
    _subCompleted = null;
    _subCancelled = null;
    if (reset) emit(OrdersState.initial());
  }

  Future<void> cancel(String orderId, {String? reason}) async {
    final a = auth.state;
    if (a is! Authenticated || (a.user.id ?? '').isEmpty) return;
    await repo.cancel(a.user.id!, orderId, reason: reason);
  }

  @override
  Future<void> close() {
    _subActive?.cancel();
    _subCompleted?.cancel();
    _subCancelled?.cancel();
    _authSub?.cancel();
    return super.close();
  }

  void _maybeScheduleAutoComplete(String uid, List<OrderModel> active) {
    for (final o in active) {
      final created = o.createdAt ?? DateTime.now();
      final now = DateTime.now();
      final diff = now.difference(created).inMinutes;
  final remaining = 5 - diff; // ~5 minutes simulation per requirements
      if (remaining <= 0) {
        _completeIfActive(uid, o.id);
      } else {
        Future.delayed(Duration(minutes: remaining), () => _completeIfActive(uid, o.id));
      }
    }
  }

  Future<void> _completeIfActive(String uid, String orderId) async {
    // Re-check status using repository stream state to avoid write churn
    final current = state.active.where((e) => e.id == orderId).toList();
    if (current.isEmpty) return;
    // Mark as completed via Firestore Field update
    try {
      // Direct write using Firebase since repository lacks complete() API for brevity
      await (repo as OrdersRepositoryFs).db
          .collection('users').doc(uid)
          .collection('orders').doc(orderId)
          .update({
        'status': 'completed',
        'payment.status': 'paid',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }
}
