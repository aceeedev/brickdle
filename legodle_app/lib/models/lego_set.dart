class LegoSet {
  final String number;
  final String theme;
  final String subtheme;
  final String name;
  final int pieces;
  final double price;
  final int year;
  late String imageUrl;

  bool get hasSubtheme => subtheme != '';

  LegoSet(
      {required this.number,
      required this.theme,
      required this.subtheme,
      required this.name,
      required this.pieces,
      required this.price,
      required this.year}) {
    imageUrl = 'https://images.brickset.com/sets/images/$number.jpg';
  }

  factory LegoSet.fromList(List<dynamic> list) {
    return LegoSet(
        number: list[0].toString(),
        theme: list[1].toString(),
        subtheme: list[2].toString(),
        name: list[3].toString(),
        pieces: double.parse(list[4]) as int,
        price: double.parse(list[5]),
        year: int.parse(list[6]));
  }
}
