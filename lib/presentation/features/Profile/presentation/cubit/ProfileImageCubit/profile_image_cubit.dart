import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_image_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  ProfileImageCubit() : super(ProfileImageInitial());

  final ImagePicker _piker = ImagePicker();

  // get image from sharedPrefs.
  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString("profile_image");
    if (path != null && File(path).existsSync()) {
      emit(ProfileImageLoaded(path));
    } else {
      emit(ProfileImageInitial());
    }
  }

  // select an image from phone files & store it in sharedPrefs
  Future<void> pickImage() async {
    try {
      emit(ProfileImageLoading());
      final pickedFile = await _piker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("profile_image", pickedFile.path);
        emit(ProfileImageLoaded(pickedFile.path));
      } else {
        emit(ProfileImageInitial());
      }
    } catch (e) {
      emit(ProfileImageError(e.toString()));
    }
  }
}
