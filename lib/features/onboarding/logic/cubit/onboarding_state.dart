part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  final int index;
  const OnboardingState({required this.index});

  OnboardingState copyWith({int? index}) => OnboardingState(index: index ?? this.index);

  @override
  List<Object?> get props => [index];
}
