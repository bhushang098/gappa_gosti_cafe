import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder(
        future: getMyOrders(),
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
                      return Padding(
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
                                image: NetworkImage(
                                    snapShot.data[index].data['pic'])),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 10.0,
                                bottom: 10.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white.withOpacity(0.5),
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
                                              'Total :' +
                                                  snapShot
                                                      .data[index].data['total']
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                            BorderRadius.circular(10.0),
                                        color: Colors.white.withOpacity(0.5),
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
                                              "Qunatity  " +
                                                  snapShot.data[index]
                                                      .data['quantity']
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Icon(
                                              Icons.fastfood,
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
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.pinkAccent.withOpacity(0.8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 5.0,
                                        left: 10.0,
                                        right: 10.0),
                                    child: Text(
                                      snapShot.data[index].data['dish_name'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 26),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white.withOpacity(0.5),
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
                                          'Dish In Progress',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : CircularProgressIndicator();
          }
        },
      ),
    );
  }

  getMyOrders() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore
        .collection('orders')
        .where('user_id', isEqualTo: user.uid)
        .getDocuments();
    return qn.documents;
  }
}
