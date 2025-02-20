import 'package:badger_market/page/post_product_screen.dart';
import 'package:flutter/material.dart';

import '../DTO/product_tile.dart';
import '../DTO/products.dart';
import '../cart/cart_app_bar_action.dart';
import '../components/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String searchString;
  @override
  void initState() {
    searchString = '';
    super.initState();
  }

  void setSearchString(String value) => setState(() {
        searchString = value;
      });

  void _postProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostProductScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listViewPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8); // Adjusted padding
    List<Widget> searchResultTiles = [];
    if (searchString.isNotEmpty) {
      searchResultTiles = products
          .where(
              (p) => p.name.toLowerCase().contains(searchString.toLowerCase()))
          .map(
            (p) => ProductTile(product: p),
          )
          .toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
          height: MediaQuery.of(context).size.height * 0.05, // Adjust the height as needed 
          child: SearchBar(
            onChanged: setSearchString,
          ),
        ),
        actions: const [
          CartAppBarAction(),
        ],
        backgroundColor: Colors.red,
      ),
      drawer: const MyDrawer(),
      body: searchString.isNotEmpty
          ? Padding(
              padding: listViewPadding,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8, // Adjusted spacing
                      crossAxisSpacing: 8, // Adjusted spacing
                      childAspectRatio: .7,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: searchResultTiles,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Text(
                'No products found',
                // style: Theme.of(context).textTheme.headline6,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _postProduct,
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}