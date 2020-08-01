import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gappa_gosti_cafe/Services/dishClass.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class MyMainPage extends StatefulWidget {
  MyMainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int counter = 0;
  FirebaseUser user;
  int loadcount = 0;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);

    if (loadcount < 1) {
      getorders();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 30.0, right: 25.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hi! ' + user.displayName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Welcome To",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Gappa Goshti Cafe",
                          style: TextStyle(color: Colors.pink),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/MyOrders');
                    setState(() {
                      //counter = 0;
                      loadcount = 0;
                    });
                  },
                  onLongPress: () {
                    //counter = 0;
                    loadcount = 0;
                    showAlertDialog(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          new IconButton(
                              icon: Icon(
                                Icons.fastfood,
                                color: Colors.pinkAccent,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/MyOrders');
                                setState(() {
                                  //counter = 0;
                                  loadcount = 0;
                                });
                              }),
                          counter != 0
                              ? new Positioned(
                                  right: 11,
                                  top: 11,
                                  child: new Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Text(
                                      '$counter',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : new Container()
                        ],
                      ),
                      Text(
                        'Your Orders',
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Divider(),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Our Food Offerings",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              child: FutureBuilder(
                future: getDished(),
                builder: (_, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    // ignore: missing_return
                    return Center(
                      child: Text('Loading ....'),
                    );
                  } else {
                    return snapShot.hasData
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapShot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    counter = 0;
                                    loadcount = 0;
                                  });
                                  Dish _dish = new Dish();
                                  _dish.name =
                                      snapShot.data[index].data['name'];
                                  _dish.pic = snapShot.data[index].data['pic'];
                                  _dish.price =
                                      snapShot.data[index].data['price'];
                                  Navigator.pushNamed(context, '/DishDetails',
                                      arguments: _dish);
                                },
                                hoverColor: Colors.pinkAccent,
                                splashColor: Colors.pinkAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    height: 180.0,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 20.0, // soften the shadow
                                          spreadRadius: 2.0, //extend the shadow
                                          offset: Offset(
                                            1.0, // Move to right 10  horizontally
                                            5.0, // Move to bottom 5 Vertically
                                          ),
                                        )
                                      ],
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(snapShot
                                              .data[index].data['pic'])),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 10.0,
                                          bottom: 10.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 5.0,
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'INR :' +
                                                            snapShot.data[index]
                                                                .data['price']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 3.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 5.0,
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "4.8",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 3.0,
                                                      ),
                                                      Icon(
                                                        Icons.star_border,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 15,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.pinkAccent
                                                  .withOpacity(0.8),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Text(
                                                snapShot
                                                    .data[index].data['name'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 26),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          right: 15,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    'More Info',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  getDished() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection('dishes').getDocuments();
    return qn.documents;
  }

  void getorders() {
    var snp = Firestore.instance.collection('users').document(user.uid).get();
    snp.then((onValue) {
      setState(() {
        counter = onValue.data['orders'].length;
        loadcount++;
      });
    });
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Sign Out");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/loginPage', (Route<dynamic> route) => false);
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Yes Conform"),
      onPressed: () {
        Navigator.of(context).pop();
        signOutGoogle();

        //Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Conformation"),
      content: Text('U Want To Log Out App'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
