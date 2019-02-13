import 'dart:async';

import 'package:flutter/material.dart';

Future<T> showBottomMenu<T>(
    BuildContext context, Iterable<BottomMenuItem<T>> items) {
  final tiles = items.map((item) => ListTile(
        title: Text(
          item.title,
          textAlign: TextAlign.center,
        ),
        onTap: () {
          Navigator.pop(context, item.value);
        },
      ));

  return showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return ListView(
          primary: false,
          shrinkWrap: true,
          children: ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList(),
        );
      });
}

class BottomMenuItem<T> {
  final String title;
  final T value;

  BottomMenuItem(this.title, this.value);
}
