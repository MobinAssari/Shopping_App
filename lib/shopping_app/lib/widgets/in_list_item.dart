import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';

class InListItem extends StatelessWidget {
  const InListItem({super.key, required this.item});

  final GroceryItem item;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: Container(
          height: 25,
          width: 15,
          color: item.category.color,
        ),
        title: Text(item.name),
        trailing: Text(
          item.quantity.toString(),
        ),
      ),
    );
  }
}
