import 'package:flutter/material.dart';

import '../data/dummy_items.dart';
import '../widgets/in_list_item.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
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
