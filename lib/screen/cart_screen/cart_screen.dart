import 'package:cart_sqflite_provider/modal/cart_model.dart';
import 'package:cart_sqflite_provider/provider_state_management/shopping_cart_provider.dart';
import 'package:cart_sqflite_provider/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ShoppingCartProvider>(context);
    // initialize db helper class
    DBHelper dbHelper = DBHelper.getInstance;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Product"),
        centerTitle: true,
        actions: [
          // badge
          Badge(
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
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<CartModel>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Image(
                                    height: 100,
                                    width: 100,
                                    image: NetworkImage(
                                        snapshot.data![index].image.toString()),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                snapshot
                                                    .data![index].productName
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            // DELETE BUTTON HERE
                                            IconButton(
                                                onPressed: () async {
                                                  cart.removeTotalPrice(
                                                      double.parse(snapshot
                                                          .data![index]
                                                          .productPrice
                                                          .toString()));
                                                  cart.removeCounter();
                                                  String productId = snapshot
                                                      .data![index].id!
                                                      .toString(); // Get the id of the product
                                                  await dbHelper.deleteCartItem(
                                                      productId); // Delete the cart item by id
                                                  // Optionally, refresh the UI or notify listeners to reflect the changes
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Color.fromARGB(
                                                      255, 237, 52, 38),
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              snapshot.data![index].unitTag
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "\$ ${snapshot.data![index].productPrice.toString()}",
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
                                        Container(
                                          height: 35,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.green,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  int quantity = snapshot
                                                      .data![index].quantity!;
                                                  int price = snapshot
                                                      .data![index]
                                                      .initialPrice!;
                                                  quantity--;
                                                  int? newPrice =
                                                      price * quantity;
                                                  if (quantity > 0) {
                                                    dbHelper
                                                        .updateCartItem(
                                                      CartModel(
                                                          id: snapshot
                                                              .data![index].id,
                                                          productId: snapshot
                                                              .data![index].id
                                                              .toString(),
                                                          productName: snapshot
                                                              .data![index]
                                                              .productName
                                                              .toString(),
                                                          initialPrice: snapshot
                                                              .data![index]
                                                              .initialPrice,
                                                          productPrice:
                                                              newPrice,
                                                          quantity: quantity,
                                                          unitTag: snapshot
                                                              .data![index]
                                                              .unitTag
                                                              .toString(),
                                                          image: snapshot
                                                              .data![index]
                                                              .image
                                                              .toString()),
                                                    )
                                                        .then((value) {
                                                      newPrice = 0;
                                                      quantity = 0;
                                                      cart.removeTotalPrice(
                                                          double.parse(snapshot
                                                              .data![index]
                                                              .initialPrice
                                                              .toString()));
                                                    }).onError(
                                                      (error, stackTrace) {
                                                        print(error.toString());
                                                      },
                                                    );
                                                  }
                                                },
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                iconSize: 32,
                                                icon: Icon(Icons.remove),
                                                color: Colors.white,
                                              ),

                                              // add button
                                              Text(
                                                snapshot.data![index].quantity
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  int quantity = snapshot
                                                      .data![index].quantity!;
                                                  int price = snapshot
                                                      .data![index]
                                                      .initialPrice!;
                                                  quantity++;
                                                  int? newPrice =
                                                      price * quantity;
                                                  dbHelper
                                                      .updateCartItem(
                                                    CartModel(
                                                        id: snapshot
                                                            .data![index].id,
                                                        productId: snapshot
                                                            .data![index].id
                                                            .toString(),
                                                        productName: snapshot
                                                            .data![index]
                                                            .productName
                                                            .toString(),
                                                        initialPrice: snapshot
                                                            .data![index]
                                                            .initialPrice,
                                                        productPrice: newPrice,
                                                        quantity: quantity,
                                                        unitTag: snapshot
                                                            .data![index]
                                                            .unitTag
                                                            .toString(),
                                                        image: snapshot
                                                            .data![index].image
                                                            .toString()),
                                                  )
                                                      .then((value) {
                                                    newPrice = 0;
                                                    quantity = 0;
                                                    cart.addTotalPrice(
                                                        double.parse(snapshot
                                                            .data![index]
                                                            .initialPrice
                                                            .toString()));
                                                  }).onError(
                                                    (error, stackTrace) {
                                                      print(error.toString());
                                                    },
                                                  );
                                                },
                                                alignment:
                                                    Alignment.centerRight,
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                iconSize: 32,
                                                icon: Icon(Icons.add),
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }

                return const SizedBox();
              }),
          // SHOW TOTAL VALUES
          Consumer<ShoppingCartProvider>(
              builder: (context, value, child) => Column(
                    children: [
                      ReUsableRow(
                          title: "Sub Total",
                          value:
                              '\$ ${value.getTotalPrice().toStringAsFixed(2)}')
                    ],
                  ))
        ],
      ),
    );
  }
}
///////////////////////////////////////

// RE USABLE ROW
class ReUsableRow extends StatelessWidget {
  final String title, value;
  const ReUsableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
