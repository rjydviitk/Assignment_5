import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String image;
  final String name;
  final double price;

  Product({required this.image, required this.name, required this.price});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    for (var item in _items) {
      if (item.product == product) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product == product);
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        home: ProductListScreen(),
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(image: 'assets/images/1.jpg', name: 'Black T-shirt', price: 20.0),
    Product(
        image: 'assets/images/2.jpg', name: 'Off-White T-shirt', price: 25.0),
    Product(image: 'assets/images/1.jpg', name: 'Product 1', price: 20.0),
    Product(image: 'assets/images/2.jpg', name: 'Product 2', price: 25.0),
    Product(image: 'assets/images/1.jpg', name: 'Product 1', price: 20.0),
    Product(image: 'assets/images/2.jpg', name: 'Product 2', price: 25.0),
    Product(image: 'assets/images/1.jpg', name: 'Product 1', price: 20.0),
    Product(image: 'assets/images/2.jpg', name: 'Product 2', price: 25.0),
    Product(image: 'assets/images/1.jpg', name: 'Product 1', price: 20.0),
    Product(image: 'assets/images/2.jpg', name: 'Product 2', price: 25.0),
    Product(image: 'assets/images/1.jpg', name: 'Product 1', price: 20.0),
    Product(image: 'assets/images/2.jpg', name: 'Product 2', price: 25.0),
    Product(image: 'assets/images/1.jpg', name: 'Product 1', price: 20.0),
    Product(image: 'assets/images/2.jpg', name: 'Product 2', price: 25.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T Shirts'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductItem(product: products[index]);
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              product.image,
              height: 650,
              width: 569,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: TextStyle(fontSize: 18)),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cart.items.any((item) => item.product == product)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Added To Cart',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            cart.removeFromCart(product);
                          },
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        cart.addToCart(product);
                      },
                      child:
                          Text('Add to Cart', style: TextStyle(fontSize: 14)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                CartItem cartItem = cartItems[index];
                return ListTile(
                  leading: Image.asset(cartItem.product.image),
                  title: Text(
                    '${cartItem.product.name}\n\$${cartItem.product.price.toString()}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          cart.removeFromCart(cartItem.product);
                        },
                      ),
                      Text('${cartItem.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          cart.addToCart(cartItem.product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                    'Cart Total: \$${cart.getTotalPrice().toStringAsFixed(2)}'),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    cart.clearCart();
                  },
                  child: Text('Buy Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
