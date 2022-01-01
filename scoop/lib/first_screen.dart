import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'auth.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // main.dart
    return Consumer<LoginProvider>(
      // auth.dart
      builder: (context, appState, _) => Authentication(
        loginState: appState.loginState,
      ),
    );
  }
}
