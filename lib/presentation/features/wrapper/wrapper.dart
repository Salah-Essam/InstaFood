import 'package:flutter/material.dart';
import 'package:insta_food/presentation/features/home/presentation/home.dart';

class Warpper extends StatelessWidget {
  const Warpper({super.key});

  @override
  Widget build(BuildContext context) {
    return Home();
    //This code skips Login if User is still logged in
    //TODO : uncomment when FireAuth is set

    //return _auth.isLoggedIn ? HomeScreen() : LogIn();

    //or

    //   return StreamBuilder(
    //     stream: _auth.authStateChanges,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Container(child: CircularProgressIndicator());
    //       } else if (snapshot.data != null) {
    //         return HomeScreen();
    //       }
    //       return LogIn();
    //     },
    //   );
    // }
  }
}
