import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_english/page/login_page.dart';
import 'package:learn_english/page/main_page.dart';
import 'package:learn_english/page/splash_page.dart';

import 'common/MyColors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ///横竖屏
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown
//  ]);

  // runZoned(() {
  //   ErrorWidget.builder = (FlutterErrorDetails details) {
  //     Zone.current.handleUncaughtError(details.exception, details.stack);
  //
  //     ///出现异常时会进入下方页面（flutter原有的红屏），
  //     return ExceptionPageState(
  //             details.exception.toString(), details.stack.toString())
  //         .generateWidget();
  //   };
  // }, onError: (Object object, StackTrace trace) {
  //   ///你可以将下面日志上传到服务器，用于release后的错误处理
  //   debugPrint(object);
  //   debugPrint(trace.toString());
  // });
  runApp(MyApp());
  //状态栏置透明
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  static final _navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white,
        accentColor: MyColors.accentColor,
        primarySwatch: Colors.deepPurple,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        './main': (BuildContext context) => MainPage(),
        './login': (BuildContext context) => LoginPage(),
      },
    );
  }
}
