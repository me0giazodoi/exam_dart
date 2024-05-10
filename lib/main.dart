import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Order {
  final String item;
  final String itemName;
  final double price;
  final String currency;
  final int quantity;

  Order({
    required this.item,
    required this.itemName,
    required this.price,
    required this.currency,
    required this.quantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      item: json['Item'],
      itemName: json['ItemName'],
      price: json['Price'].toDouble(),
      currency: json['Currency'],
      quantity: json['Quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Item': item,
      'ItemName': itemName,
      'Price': price,
      'Currency': currency,
      'Quantity': quantity,
    };
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrdersScreen(),
    );
  }
}

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  List<Order> filteredOrders = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Parse the JSON string and add orders to the list
    final jsonString = '[{"Item": "A1000","ItemName": "Iphone 15","Price": 1200,"Currency": "USD","Quantity":1},{"Item": "A1001","ItemName": "Iphone 16","Price": 1500,"Currency": "USD","Quantity":1}]';
    final List<dynamic> parsedJson = jsonDecode(jsonString);
    orders = parsedJson.map((json) => Order.fromJson(json)).toList();
    filteredOrders.addAll(orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        filterOrders(value);
                      },
                      decoration: InputDecoration(labelText: 'Search by Item Name'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      filterOrders(searchController.text);
                    },
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: itemController,
                decoration: InputDecoration(labelText: 'Item'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: currencyController,
                decoration: InputDecoration(labelText: 'Currency'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addOrder();
              },
              child: Text('Add to Cart'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 500, // Adjust the height as per your requirement
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return ListTile(
                    title: Text('${order.itemName} (${order.item})'),
                    subtitle: Text('Price: ${order.price}, Quantity: ${order.quantity}, Currency: ${order.currency}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteOrder(order);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addOrder() {
    setState(() {
      Order newOrder = Order(
        item: itemController.text,
        itemName: itemNameController.text,
        price: double.parse(priceController.text),
        currency: currencyController.text,
        quantity: int.parse(quantityController.text),
      );
      orders.add(newOrder);
      filterOrders(searchController.text); // Update filtered orders
      // Clear the input fields after adding order
      itemController.clear();
      itemNameController.clear();
      priceController.clear();
      quantityController.clear();
      currencyController.clear();
    });
  }

  void deleteOrder(Order order) {
    setState(() {
      orders.remove(order);
      filterOrders(searchController.text); // Update filtered orders
    });
  }

  void filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, show all orders
        filteredOrders = List.from(orders);
      } else {
        filteredOrders = orders.where((order) => order.itemName.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
}