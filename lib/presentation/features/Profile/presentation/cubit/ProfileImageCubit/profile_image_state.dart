part of 'profile_image_cubit.dart';

abstract class ProfileImageState {}

class ProfileImageInitial extends ProfileImageState {}

class ProfileImageLoading extends ProfileImageState {}

class ProfileImageLoaded extends ProfileImageState {
  final String imagePath;
  ProfileImageLoaded(this.imagePath);
}

class ProfileImageError extends ProfileImageState {
  final String message;
  ProfileImageError(this.message);
}
