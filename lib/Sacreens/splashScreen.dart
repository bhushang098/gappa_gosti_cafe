import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void navigationToNextPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Wrapper', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/food_vertical.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: 20,
                  right: 20,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Welcome ! \n ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 38,
                          ),
                        ),
                        TextSpan(
                          text: " Stay Safe ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        TextSpan(
                          text: " Eat Healthy",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Gappa Goshti ",
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        TextSpan(
                          text: "  Cafe & Restro",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: GestureDetector(
                      onTap: () {
                        navigationToNextPage();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25),
                        padding:
                            EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.pinkAccent,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Get Started",
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: Colors.white,
                                      ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 17,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
