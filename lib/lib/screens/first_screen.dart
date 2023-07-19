import 'package:flutter/material.dart';
import 'package:shopping_app/lib/screens/new_item.dart';

import '../data/dummy_items.dart';
import '../widgets/in_list_item.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  void _AddItemPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _AddItemPressed, icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) {
          return InListItem(item: groceryItems[index]);
        },
      ),
    );
  }
}
