import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/pages/auth_page.dart';
import 'package:shop_ui_udemy/pages/main_page.dart';
import 'package:shop_ui_udemy/pages/manage_product_page.dart';
import 'package:shop_ui_udemy/pages/order_page.dart';
import 'package:shop_ui_udemy/provider/auth_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Drawer(
        semanticLabel: "Semantic",
        child: Column(
          children: [
            topBgImgWithAvata(context),
            _buildListTile(
                'Home Page', Icons.home_max_outlined, Colors.amber.withOpacity(.6),
                () {
              Navigator.of(context).pushReplacementNamed(MyMainPage.nameRoute);
            }),
            const Divider(
              indent: 12.0,
              endIndent: 12.0,
              thickness: 1,
            ),
            _buildListTile('Manage Products', Icons.manage_search_rounded,
                Colors.amber.withOpacity(.6), () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageProductPage.nameRoute);
            }),
            const Divider(
              indent: 12.0,
              endIndent: 12.0,
              thickness: 1,
            ),
            _buildListTile(
              'My Order',
              Icons.shopping_bag_outlined,
              Colors.amber.withOpacity(.6),
              () {
                Navigator.of(context).pushReplacementNamed(OrderPage.nameRoute);
              },
            ),
            const Divider(
              indent: 12.0,
              endIndent: 12.0,
              thickness: 1,
            ),
            _buildListTile(
                'Log out', Icons.logout_rounded, Colors.amber.withOpacity(.6),
                () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logOut();
            }),
          ],
        ),
      ),
    );
  }

  Container topBgImgWithAvata(BuildContext context) {
    return Container(
      height: 140,
      width: 240,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffFFCF67), Color(0xffF8B55B)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 34.0,
          ),
          const CircleAvatar(
            radius: 32,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            'Truong Nguyen',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      String title, IconData icon, Color splashColor, Function() onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: splashColor,
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(
                width: 16.0,
              ),
              FittedBox(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
