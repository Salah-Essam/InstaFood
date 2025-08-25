import 'package:flutter/material.dart';

class ImageError {
  static imageErrorLoader() {
    return (BuildContext context, Object error, StackTrace? stackTrace) {
      return SizedBox.expand(
        child: Container(
          color: Colors.grey[300],
          child: Icon(Icons.error_outline, color: Colors.grey[500]),
        ),
      );
    };
  }
}
