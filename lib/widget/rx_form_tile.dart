import 'dart:async';

import 'package:flutter/material.dart';

class RxFormTile<T> extends StatefulWidget {
  final Widget label;
  final Stream<T> stream;
  final String Function(T) toStringConverter;
  final GestureTapCallback onTap;

  RxFormTile(
      {@required this.label,
      this.stream,
      this.toStringConverter,
      @required this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _State<T>();
  }
}

class _State<T> extends State<RxFormTile<T>> {
  StreamSubscription<T> _subscription;
  String _valueString;
  bool _valid = false;
  Widget _labelWidget;

  @override
  void initState() {
    super.initState();
    _labelWidget = widget.label;

    if (widget.stream != null) {
      _subscription = widget.stream.listen((value) {
        setState(() {
          if (value != null) {
            _valueString = widget.toStringConverter != null
                ? widget.toStringConverter(value)
                : value.toString();
            _valid = true;
          } else {
            _valueString = null;
            _valid = false;
          }

          _labelWidget = AnimatedDefaultTextStyle(
            style: value == null
                ? TextStyle(fontSize: 16, color: Theme.of(context).hintColor)
                : TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
            duration: kThemeChangeDuration,
            child: widget.label,
          );
        });
      });
    }
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Expanded(
              child: _valueString != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _labelWidget,
                        AnimatedDefaultTextStyle(
                          style: Theme.of(context).textTheme.subhead,
                          duration: kThemeChangeDuration,
                          child: Text(_valueString),
                        ),
                      ],
                    )
                  : _labelWidget,
            ),
            widget.stream != null
                ? _valid
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.error, color: Colors.red)
                : Container(),
            Icon(
              Icons.arrow_forward_ios,
              size: 12.0,
              color: Theme.of(context).disabledColor,
            )
          ],
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
