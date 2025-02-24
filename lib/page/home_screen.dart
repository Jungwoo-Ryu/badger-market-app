import 'package:badger_market/DTO/product.dart';
import 'package:badger_market/page/post_product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../DTO/product_tile.dart';
import '../components/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String searchString;
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    searchString = '';
    super.initState();
    fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('cret_wk_dtm', descending: true)
          .get();
      setState(() {
        products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void setSearchString(String value) => setState(() {
        searchString = value;
      });

  void _postProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostProductScreen()),
    );
    fetchProducts(); // Refresh the products when returning from the PostProductScreen
  }

  @override
  Widget build(BuildContext context) {
    var listViewPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8); // Adjusted padding
    List<Widget> searchResultTiles = [];
    if (searchString.isNotEmpty) {
      searchResultTiles = products
          .where(
              (p) => p.title.toLowerCase().contains(searchString.toLowerCase()))
          .map(
            (p) => ProductTile(product: p),
          )
          .toList();
    } else {
      searchResultTiles = products.map((p) => ProductTile(product: p)).toList();
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
          // CartAppBarAction(),
        ],
        backgroundColor: const Color.fromRGBO(161, 32, 43, 1),
        iconTheme: IconThemeData(color: Colors.white), // Set hamburger button color to white
      ),
      drawer: const MyDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchProducts,
              child: searchResultTiles.isNotEmpty
                  ? Padding(
                      padding: listViewPadding,
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8, // Adjusted spacing
                        crossAxisSpacing: 8, // Adjusted spacing
                        childAspectRatio: .7,
                        children: searchResultTiles,
                      ),
                    )
                  : Center(
                      child: Text(
                        'No products found',
                        // style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _postProduct,
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(161, 32, 43, 1),
        foregroundColor: Colors.white, // Set "+" button color to white
      ),
    );
  }
}