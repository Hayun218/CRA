import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'page_view_state.dart';
import 'auth.dart';
import 'login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => BottomAppBarProvider()),
      ],
      builder: (context, _) => const Scoop(),
    ),
  );
}

class LoginProvider extends ChangeNotifier {
  // LoginProvider: user 상태가 바뀌면 화면을 바꿔주는 State Class
  // home.dart => Login Page || Item Page
  FirebaseAuth auth = FirebaseAuth.instance;

  LoginProvider() {
    init();
  }

  Future<void> init() async {
    auth.userChanges().listen((User? user) {
      if (user == null) {
        _loginState = LoginState.loggedOut;
      } else {
        _loginState = LoginState.loggedIn;
      }
      notifyListeners();
    });
  }

  // 기본 상태는 LoggedOut
  LoginState _loginState = LoginState.loggedOut;
  LoginState get loginState => _loginState;
}

class BottomAppBarProvider extends ChangeNotifier {
  void pageFlow(int index) {
    switch (index) {
      case 0:
        _pageState = PageState.dashboard;
        break;
      case 1:
        _pageState = PageState.student;
        break;
      case 2:
        _pageState = PageState.photos;
        break;
      case 3:
        _pageState = PageState.notice;
    }
    notifyListeners();
  }

  void signOut() {
    _pageState = PageState.dashboard;
    print("signout");
    notifyListeners();
  }

  PageState _pageState = PageState.dashboard;
  PageState get pageState => _pageState;
}
