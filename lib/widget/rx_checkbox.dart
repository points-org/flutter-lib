import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RxCheckbox extends StatefulWidget {
  final Key key;
  final BehaviorSubject<bool> stream;
  final bool tristate;
  final Color activeColor;
  final Color checkColor;
  final MaterialTapTargetSize materialTapTargetSize;

  RxCheckbox({
    this.key,
    @required this.stream,
    this.tristate = false,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<RxCheckbox> {
  bool _value = false;
  StreamSubscription<bool> _subscription;

  @override
  void initState() {
    _subscription = widget.stream.listen((value) {
      if (value != null && value != _value) {
        setState(() {
          _value = value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        key: widget.key,
        value: _value,
        onChanged: onChanged,
        tristate: widget.tristate,
        activeColor: widget.activeColor,
        checkColor: widget.checkColor,
        materialTapTargetSize: widget.materialTapTargetSize);
  }

  void onChanged(bool value) {
    if (widget.stream.value != value) {
      widget.stream.add(value);
    }
  }
}
