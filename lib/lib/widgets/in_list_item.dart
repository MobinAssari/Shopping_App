import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/grocery_item.dart';

class InListItem extends StatelessWidget {
  const InListItem({super.key, required this.item});

  final GroceryItem item;

  @override
  Widget build(context) {
    return ListTile(
      leading: Container(
        height: 20,
        width: 20,
        color: item.category.color,
      ),
      title: Text(item.name),
      trailing: Text(
        item.quantity.toString(),
      ),
    );
  }
}
