import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/lib/data/categories.dart';
import 'package:shopping_app/lib/models/Categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  void _saveButton() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-shop-http-e7735-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json');
      http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _itemTitle,
            'quantity': _itemQuantity,
            'category': _itemCategory.title
          },
        ),
      );
    }
  }

  var _itemTitle = '';
  var _itemQuantity = 1;
  var _itemCategory = categories[Categories.vegetables]!;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Error';
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemTitle = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: (value) {
                        if (value == null || int.tryParse(value)! <= 0) {
                          return "Input should be a valid positive number";
                        }
                        return null;
                      },
                      initialValue: '1',
                      onSaved: (value) => _itemQuantity = int.parse(value!),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _itemCategory,
                        onSaved: (value) => _itemCategory = value!,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 8),
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(category.value.title)
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _itemCategory = value!;
                          });
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: Text('Reset')),
                  ElevatedButton(
                      onPressed: _saveButton, child: Text('Add Item'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
