import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gappa_gosti_cafe/Sacreens/dishDetails.dart';
import 'package:gappa_gosti_cafe/Sacreens/googleSignIn.dart';
import 'package:gappa_gosti_cafe/Sacreens/myOrdersPage.dart';
import 'package:gappa_gosti_cafe/Sacreens/splashScreen.dart';
import 'package:gappa_gosti_cafe/Sacreens/wrapper.dart';
import 'package:gappa_gosti_cafe/Services/outhService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: Auth().user,
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          '/Wrapper': (BuildContext context) => new Wrapper(),
          '/DishDetails': (BuildContext context) => new DishDetails(),
          '/MyOrders': (BuildContext context) => new MyOrders(),
          '/loginPage': (BuildContext context) => new LoginPage(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Gappa Goshti Cafe',
        color: Colors.pinkAccent,
        home: Splash(),
      ),
    );
  }
}
