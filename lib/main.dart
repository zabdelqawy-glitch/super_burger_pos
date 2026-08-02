import 'package:flutter/material.dart';

void main() {
  runApp(const SuperBurgerApp());
}

class SuperBurgerApp extends StatelessWidget {
  const SuperBurgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Burger POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const POSHomeScreen(),
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String icon;

  MenuItem({required this.id, required this.name, required this.price, required this.icon});
}

class OrderItem {
  final MenuItem item;
  int quantity;

  OrderItem({required this.item, this.quantity = 1});
}

class POSHomeScreen extends StatefulWidget {
  const POSHomeScreen({super.key});

  @override
  State<POSHomeScreen> createState() => _POSHomeScreenState();
}

class _POSHomeScreenState extends State<POSHomeScreen> {
  final List<MenuItem> menu = [
    MenuItem(id: '1', name: 'سينجل برجر لحم', price: 90.0, icon: '🍔'),
    MenuItem(id: '2', name: 'دبل تشيز برجر', price: 140.0, icon: '🍔'),
    MenuItem(id: '3', name: 'سوبر تشيكن برجر', price: 110.0, icon: '🍔'),
    MenuItem(id: '4', name: 'بطاطس مقرمشة', price: 40.0, icon: '🍟'),
    MenuItem(id: '5', name: 'حلقات بصل', price: 45.0, icon: '🧅'),
    MenuItem(id: '6', name: 'مشروب غازي', price: 25.0, icon: '🥤'),
    MenuItem(id: '7', name: 'ماء معدني', price: 10.0, icon: '💧'),
  ];

  final List<OrderItem> cart = [];

  void addToCart(MenuItem item) {
    setState(() {
      final index = cart.indexWhere((element) => element.item.id == item.id);
      if (index >= 0) {
        cart[index].quantity++;
      } else {
        cart.add(OrderItem(item: item));
      }
    });
  }

  void removeFromCart(MenuItem item) {
    setState(() {
      final index = cart.indexWhere((element) => element.item.id == item.id);
      if (index >= 0) {
        if (cart[index].quantity > 1) {
          cart[index].quantity--;
        } else {
          cart.removeAt(index);
        }
      }
    });
  }

  double calculateTotal() {
    return cart.fold(0, (sum, item) => sum + (item.item.price * item.quantity));
  }

  void clearCart() {
    setState(() {
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Super Burger POS 🍔',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: clearCart,
            tooltip: 'مسح السلة',
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  final item = menu[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Text(item.icon, style: const TextStyle(fontSize: 30)),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.price} ج.م'),
                      trailing: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => addToCart(item),
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey.shade100,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'تفاصيل الطلب الحالي',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: cart.isEmpty
                          ? const Center(child: Text('السلة فارغة، اضغط إضافة للبدء'))
                          : ListView.builder(
                              itemCount: cart.length,
                              itemBuilder: (context, index) {
                                final orderItem = cart[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(orderItem.item.name),
                                  subtitle: Text(
                                    '${orderItem.item.price} × ${orderItem.quantity} = ${orderItem.item.price * orderItem.quantity} ج.م',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        onPressed: () => removeFromCart(orderItem.item),
                                      ),
                                      Text('${orderItem.quantity}', style: const TextStyle(fontSize: 16)),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                        onPressed: () => addToCart(orderItem.item),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('الإجمالي النهائي:', style: TextStyle(color: Colors.grey)),
                              Text(
                                '${calculateTotal()} ج.م',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.horizontal(24, vertical: 12),
                            ),
                            onPressed: cart.isEmpty
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('تأكيد الطلب 🧾'),
                                        content: Text('تم إرسال الطلب بنجاح!\nالإجمالي: ${calculateTotal()} ج.م'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              clearCart();
                                            },
                                            child: const Text('طلب جديد'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                            child: const Text(
                              'تأكيد وحفظ الطلب',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
