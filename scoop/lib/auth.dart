import 'package:flutter/material.dart';

import 'login.dart';
import 'page_view.dart';

enum LoginState {
  loggedOut,
  loggedIn,
}

class Authentication extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Authentication({
    required this.loginState,
  });

  final LoginState loginState;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case LoginState.loggedOut:
        print("logged out");
        return LoginPage();
      case LoginState.loggedIn:
        print("logged in");
        return const Pages();
    }
  }
}
