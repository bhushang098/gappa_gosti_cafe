class Dish {
  String _name, _pic;
  int _price;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  get pic => _pic;

  int get price => _price;

  set price(int value) {
    _price = value;
  }

  set pic(value) {
    _pic = value;
  }
}
