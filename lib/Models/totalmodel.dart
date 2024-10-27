// class OrderItem {
//   final String title;
//   final String imagePath;
//   final int price;
//   int count;

//   OrderItem({
//     required this.title,
//     required this.imagePath,
//     required this.price,
//     this.count = 1,
//   });

//   int getTotalPrice() {
//     return price * count;
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'imagePath': imagePath,
//       'price': price,
//       'count': count,
//     };
//   }

//   factory OrderItem.fromMap(Map<String, dynamic> map) {
//     return OrderItem(
//       title: map['title'] ?? '', // Default to empty string if null
//       imagePath: map['imagePath'] ?? '', // Default to empty string if null
//       price: int.tryParse(map['price'].toString()) ?? 0, // Use tryParse for safety
//       count: int.tryParse(map['count'].toString()) ?? 1, // Default to 1 if null
//     );
//   }
// }
