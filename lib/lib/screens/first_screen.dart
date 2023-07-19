import 'package:flutter/material.dart';
import 'package:shopping_app/lib/models/grocery_item.dart';
import 'package:shopping_app/lib/screens/new_item.dart';

import '../widgets/in_list_item.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final List<GroceryItem> _groceryItemsList = [];

  void _AddItemPressed() async {
    var newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) return;
    setState(() {
      _groceryItemsList.add(newItem);
    });
  }

  var mainContent;

  Widget build(context) {
    if (_groceryItemsList.isEmpty) {
      mainContent = const Center(
        child: Text('No item added yet!'),
      );
    } else {
      mainContent = ListView.builder(
        itemCount: _groceryItemsList.length,
        itemBuilder: (ctx, index) => Dismissible(

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
            _groceryItemsList.remove(_groceryItemsList[index]);},
        ),
      );
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
