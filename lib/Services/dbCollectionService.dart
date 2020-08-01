import 'package:cloud_firestore/cloud_firestore.dart';

class DbCollection {
  final String uid;

  DbCollection(this.uid);

  final CollectionReference users = Firestore.instance.collection('users');
  final CollectionReference orders = Firestore.instance.collection('orders');

  Future pushUserdata() async {
    return await users.document(uid).setData({
      'orders': [],
    });
  }

  Future<String> getCoursePurchases() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var courseList = snapshot['courses_purchases'];
    if (courseList is String) {
      return courseList;
    } else {
      return 'empty';
    }
  }

  Future makeOrder(String name, String dishName, int quantity, int total,
      DateTime time, int price, String uuid, String pic) async {
    adduserorder(uuid);
    return await orders.document(uuid).setData({
      'dish_name': dishName,
      'name': name,
      'pic': pic,
      'price': price,
      'quantity': quantity,
      'time': time,
      'total': total,
      'user_id': uid,
      'order_id': uuid,
    });
  }

  Future adduserorder(String uuid) async {
    List<dynamic> oldorders = [];
    var snp = Firestore.instance.collection('users').document(uid).get();
    snp.then((onValue) {
      oldorders = onValue.data['orders'];
      oldorders.add(uuid);
      return users.document(uid).updateData({'orders': oldorders});
    });
  }
}
