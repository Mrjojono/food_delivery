import 'package:flutter/material.dart';
import 'package:food_delivery/components/my_current_location.dart';
import 'package:food_delivery/components/my_description_box.dart';
import 'package:food_delivery/components/my_drawer.dart';
import 'package:food_delivery/components/my_food_tile.dart';
import 'package:food_delivery/components/my_sliver_app_bar.dart';
import 'package:food_delivery/components/my_tab_bar.dart';
import 'package:food_delivery/models/food.dart';
import 'package:food_delivery/pages/food_page.dart';
import 'package:provider/provider.dart';

import '../models/restaurant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabsController;

  @override
  void initState() {
    super.initState();
    _tabsController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  //return list of foods in this category
  List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return MyFoodTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodPage(food: food),
                  ),
                );
              },
              food: food);
        },
        itemCount: categoryMenu.length,
      );
    }).toList();
  }

  @override
  void dispose() {
    _tabsController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(
            title: MyTabBar(tabsController: _tabsController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),

                // my curent location
                const MyCurrentLocation(),

                // description box
                const MyDescriptionBox(),
              ],
            ),
          ),
        ],
        body: Consumer<Restaurant>(
          builder: (context, restaurant, child) => TabBarView(
            controller: _tabsController,
            children: getFoodInThisCategory(restaurant.menu),
          ),
        ),
      ),
    );
  }
}
