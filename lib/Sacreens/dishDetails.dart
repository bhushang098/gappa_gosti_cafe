import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gappa_gosti_cafe/Services/dbCollectionService.dart';
import 'package:gappa_gosti_cafe/Services/dishClass.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DishDetails extends StatefulWidget {
  @override
  _DishDetailsState createState() => _DishDetailsState();
}

class _DishDetailsState extends State<DishDetails> {
  Dish _dish;
  int _quantity;
  int _total = 0;
  FirebaseUser user;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _dish = new Dish();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dish = ModalRoute.of(context).settings.arguments;
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(_dish.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3,
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
                      fit: BoxFit.fill, image: NetworkImage(_dish.pic)),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 10.0,
                      bottom: 10.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "4.8",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              Icon(
                                Icons.star,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Price    ',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text('INR : ' + _dish.price.toString(),
                              style: TextStyle(
                                  color: Colors.green[300],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Quantity          ',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          DropdownButton(
                              value: _quantity,
                              items: [
                                DropdownMenuItem(
                                  child: Text("One"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Two"),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                    child: Text("Three"), value: 3),
                                DropdownMenuItem(child: Text("Four"), value: 4),
                                DropdownMenuItem(child: Text("Five"), value: 5),
                                DropdownMenuItem(child: Text("Six"), value: 6)
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _quantity = value;
                                  _total = value * _dish.price;
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Total Amount    ',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(_total.toString() + '  Rs'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _isLoading ? CircularProgressIndicator() : Container(),
              Text('Note : You Can Not Cancel or Change Order Once its Made'),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (_quantity == null) {
                        print('select Quantity');
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        new DbCollection(user.uid)
                            .makeOrder(
                                user.displayName,
                                _dish.name,
                                _quantity,
                                _total,
                                DateTime.now(),
                                _dish.price,
                                new Uuid().v1(),
                                _dish.pic)
                            .then((onValue) {
                          _showDialog(context);
                        });
                      }
                    },
                    child: Card(
                      elevation: 4,
                      color: Colors.pinkAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Make Order',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    // Create button
    setState(() {
      _isLoading = false;
    });
    Widget okButton = FlatButton(
      child: Text("Return Back"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        //navTouHome();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order Successful !!"),
      content:
          Text("You have Ordered  " + _quantity.toString() + ' ' + _dish.name),
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
