import 'package:flutter/material.dart';
import 'package:ukk_cafe/Cashier/riwayat.dart'; // Ensure this is the correct path to RiwayatPesananScreen
import 'package:ukk_cafe/Models/order_model.dart';
import 'package:ukk_cafe/service/servicetotal.dart';

class PesananPage extends StatefulWidget {
  final List<OrderItem> cartItems;

  PesananPage({required this.cartItems});

  @override
  _PesananPageState createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  final OrderService orderService = OrderService();
  String? selectedTable;
  List<String> availableTables = ["01", "02", "04", "06", "07"];

  @override
  void initState() {
    super.initState();
    for (var item in widget.cartItems) {
      orderService.addItemToCart(item);
    }
  }

  int totalPrice() {
    return widget.cartItems.fold(0, (total, item) => total + item.getTotalPrice());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E9D3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: Color(0xFF8B5D57),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Table selection dropdown placed above the order items
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: selectedTable,
              items: availableTables
                  .map((table) => DropdownMenuItem(
                        value: table,
                        child: Text('Table $table'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTable = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Table Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Display each added menu item
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return _buildOrderItem(item);
              },
            ),
          ),
          // Total Price and Done Button aligned to the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Divider(color: Color(0xFF8B5D57), thickness: 2),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total: Rp. ${totalPrice()}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: Color(0xFF8B5D57),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      final newOrder = {
                        'date': DateTime.now().toIso8601String().split('T').first,
                        'time': DateTime.now().toIso8601String().split('T').last.split('.').first,
                        'items': widget.cartItems.map((item) => {'title': item.title, 'count': item.count}).toList(),
                        'total': totalPrice(),
                        'customer': 'Customer Name', // Replace with actual customer name if available
                        'status': true, // Assuming the order is successful
                      };

                      // Save the order to Firestore
                      await orderService.saveOrderToFirebase(newOrder);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RiwayatPesananScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Display item image
            Image.asset(
              item.imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            // Display item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp. ${item.price} x ${item.count} = Rp. ${item.getTotalPrice()}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            // Increment and Decrement Buttons
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Color(0xFF8B5D57)),
                  onPressed: () {
                    setState(() {
                      if (item.count > 1) {
                        item.count--;
                      }
                    });
                  },
                ),
                Text(
                  item.count.toString(),
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Color(0xFF8B5D57)),
                  onPressed: () {
                    setState(() {
                      item.count++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}