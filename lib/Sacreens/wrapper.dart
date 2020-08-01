import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gappa_gosti_cafe/Sacreens/googleSignIn.dart';
import 'package:gappa_gosti_cafe/Sacreens/mainPage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    return user == null ? LoginPage() : MyMainPage();
  }
}
