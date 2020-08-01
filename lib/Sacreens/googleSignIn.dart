import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gappa_gosti_cafe/Sacreens/wrapper.dart';
import 'package:gappa_gosti_cafe/Services/dbCollectionService.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _showprogress = false;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/food_login.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            left: 20,
            right: 20,
            child: Column(
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome !!! \n ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 38,
                        ),
                      ),
                      TextSpan(
                        text: "Login ",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      TextSpan(
                        text: " To Continue With Us",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      )
                    ],
                  ),
                ),
                _showprogress ? CircularProgressIndicator() : Container(),
                SizedBox(
                  height: 20,
                ),
                _signInButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signInButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _showprogress = true;
        });
        try {
          signInWithGoogle().whenComplete(() {
            _auth.currentUser().then((onValue) {
              new DbCollection(onValue.uid).pushUserdata();
            });
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Wrapper', (Route<dynamic> route) => false);
          });
        } catch (e) {
          setState(() {
            _showprogress = false;
          });
          print(e.toString());
          showDialog(
              context: context,
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Something Went Wrong'),
                ),
              ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("images/google_logo.jpg"), height: 35.0),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
