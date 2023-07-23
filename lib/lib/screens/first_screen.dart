import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_app/lib/data/categories.dart';
import 'package:shopping_app/lib/models/grocery_item.dart';
import 'package:shopping_app/lib/screens/new_item.dart';
import 'package:http/http.dart' as http;
import '../widgets/in_list_item.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<GroceryItem> _groceryItemsList = [];
  var _isLoading = true;
  String? _errorText;


  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-shop-http-e7735-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);
    if(response.statusCode>=400){
      setState(() {
        _errorText = 'failed to connect to Database, try again';
      });
    }

    if(response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> listData = json.decode(
        response.body);
    final List<GroceryItem> _loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value;
      _loadedItems.add(GroceryItem(id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category ),);
    }
    setState(() {
      _groceryItemsList = _loadedItems;
      _isLoading = false;
    });
  }



  void _AddItemPressed() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    _loadItems();
  }

  var mainContent;

  Widget build(context) {


    if (_groceryItemsList.isEmpty) {
      mainContent = const Center(
        child: Text('No item added yet!'),
      );
    }
    if(_isLoading){
        mainContent = const Center(child: CircularProgressIndicator(),);
      }
    if(_groceryItemsList.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: _groceryItemsList.length,
        itemBuilder: (ctx, index) =>
            Dismissible(

              key: ValueKey(_groceryItemsList[index]),
              child: InListItem(item: _groceryItemsList[index]),
              onDismissed: (direction) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 3),
                    content: Text('Item Deleted!'),

                  ),
                );
                final url = Uri.https(
                    'flutter-shop-http-e7735-default-rtdb.europe-west1.firebasedatabase.app',
                    'shopping-list/${_groceryItemsList[index].id}.json');
                setState(() {
                  http.delete(url);
                  _groceryItemsList.remove(_groceryItemsList[index]);
                });

              },
            ),
      );
    }
    if(_errorText != null){
      mainContent = Center(child: Text(_errorText!),);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _AddItemPressed, icon: const Icon(Icons.add))
        ],
      ),
      body: mainContent,
    );
  }
}
