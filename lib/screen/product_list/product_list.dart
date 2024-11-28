import 'package:cart_sqflite_provider/modal/cart_model.dart';
import 'package:cart_sqflite_provider/provider_state_management/shopping_cart_provider.dart';
import 'package:cart_sqflite_provider/screen/cart_screen/cart_screen.dart';
import 'package:cart_sqflite_provider/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    // INITIALIZE DBHelper
    DBHelper dbHelper = DBHelper.getInstance;
    // INITIALIZE PROVIDER CLASS HERE
    // with the help of this we will be able to access all
    // the functions created in shoppingCartProvider class
    final cart = Provider.of<ShoppingCartProvider>(context);

    // lists
    List<String> productName = [
      'Mango',
      'Orange',
      'Grapes',
      'Banana',
      'Chery',
      'Peach',
      'Mixed Fruit Basket',
    ];
    List<String> productUnit = [
      'KG',
      'Dozen',
      'KG',
      'Dozen',
      'KG',
      'KG',
      'KG',
    ];
    List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
    List<String> productImage = [
      'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
      'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
      'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
      'https://cdn.pixabay.com/photo/2018/09/24/20/12/bananas-3700718_1280.jpg',
      'https://media.istockphoto.com/id/1693717637/photo/cherry-isolated-on-white-background.webp?s=2048x2048&w=is&k=20&c=oJ2bE_O51umgpMUpkDap815U4RK_t0ww_-2CySLPiE0=',
      'https://media.istockphoto.com/id/1393599686/photo/peach-fruit-one-cut-in-half-with-green-leaf.jpg?s=612x612&w=0&k=20&c=v542XUut1k4hkyAWVFcBrjo1Gr0O9Iu431J4ff8LO58=',
      'https://media.istockphoto.com/id/1398154625/photo/bowl-of-fruit-salad.jpg?s=612x612&w=0&k=20&c=GLGZx7U1oEAzmZ3e775fzDl7f1dXM0wq0ZQDMVNoR4Y=',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        centerTitle: true,
        actions: [
          // badge
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Badge(
              alignment: Alignment.topLeft,

              label: Consumer<ShoppingCartProvider>(
                builder: (context, value, child) =>
                    Text(value.getCounter().toString()),
              ),
              // cart icon
              child: const Icon(
                Icons.card_travel,
                size: 40,
              ),
              //  SizedBox(width: 10,)
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Image(
                              height: 100,
                              width: 100,
                              image:
                                  NetworkImage(productImage[index].toString())),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName[index].toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      productUnit[index].toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "\$ ${productPrice[index]}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 40,
                                    width: 120,
                                    // ADD TO CART BUTTON STARTS HERE
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 5),
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(05))),
                                        onPressed: () {
                                          dbHelper
                                              .insert(CartModel(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName:
                                                      productName[index]
                                                          .toString(),
                                                  initialPrice:
                                                      productPrice[index],
                                                  productPrice:
                                                      productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index]
                                                      .toString(),
                                                  image: productImage[index]
                                                      .toString()))
                                              .then((value) {
                                            print(
                                                "Product added to cart Successfully");
                                            cart.addTotalPrice(double.parse(
                                                productPrice[index]
                                                    .toString()));
                                            cart.addCounter();
                                          }).onError(
                                            (error, stackTrace) {
                                              print(error.toString());
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Add to cart",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
