/// Firebase generates a new key once the product is inserted into the database with `put`.
class LvProduct {
  final String name;
  final String serialNumber;
  final int quantity;
  LvProduct(this.name, {this.serialNumber = '-'}) : this.quantity = 1;

  LvProduct.fromJson(Map json)
      : this.name = json['name'],
        this.serialNumber = json['serialNumber'],
        this.quantity = json['quantity'];

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'serialNumber': this.serialNumber,
        'quantity': this.quantity
      };
}
