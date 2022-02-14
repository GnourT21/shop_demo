import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/provider/order_provider.dart';
import 'package:shop_ui_udemy/widgets/my_app_drawer.dart';
import 'package:shop_ui_udemy/widgets/my_button.dart';
import 'package:shop_ui_udemy/widgets/order_item.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);
  static const nameRoute = '/order-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Your Order'),
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(
          context,
          listen: false,
        ).fetchOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<OrderProvider>(
              builder: (ctx, order, child) {
                return order.listOrder.isEmpty
                    ? const Center(
                        child: Text('You have no order!'),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return order.listOrder.isEmpty
                              ? const Center(
                                  child: Text('No Items'),
                                )
                              : Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 6.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        totalWithButton(context, order, index),
                                        OrderItem(
                                            order: order.listOrder[index]),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 8.0),
                                          child: Text(
                                            DateFormat.yMMMd().add_jm().format(
                                                order
                                                    .listOrder[index].datetime),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                        itemCount: order.listOrder.length,
                      );
              },
            );
          }
        },
      ),
    );
  }

  Widget totalWithButton(
      BuildContext context, OrderProvider orderProvider, int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16.0,
          ),
          Text(
            'Total: ',
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
          ),
          Text(
            '\$${orderProvider.listOrder[index].amountTotal.toStringAsFixed(2)}',
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
          ),
          const SizedBox(
            width: 16.0,
          ),
          MyButton(
            width: 100,
            child: const Text(
              'Pay Order',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressHandle: () {},
            borderRardius: 6.0,
          ),
          const SizedBox(
            width: 8.0,
          ),
          MyButton(
            color: Colors.redAccent.shade100,
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressHandle: () {
              orderProvider.deleteOrder(orderProvider.listOrder[index]);
            },
            borderRardius: 6.0,
          ),
        ],
      ),
    );
  }
}
