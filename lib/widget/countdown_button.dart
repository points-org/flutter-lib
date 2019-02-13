import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CountdownButton extends StatefulWidget {
  final Widget Function(Color focusStateColor) builder;
  final int duration; // in seconds
  final GestureTapCallback onTap;
  final bool startImmediately;

  CountdownButton(
      {@required this.builder,
      @required this.duration,
      @required this.onTap,
      this.startImmediately = false});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<CountdownButton> {
  bool _isCounting = false;
  String _countingText;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    if (widget.startImmediately) {
      _startCounting();
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
    final focusStateColor = IconTheme.of(context).color;

    return GestureDetector(
      child: _isCounting
          ? Text(
              _countingText,
              textAlign: TextAlign.end,
              style: TextStyle(color: focusStateColor),
            )
          : widget.builder(focusStateColor),
      onTap: () {
        if (!_isCounting) {
          widget.onTap();
          _startCounting();
        }
      },
    );
  }

  _startCounting() {
    setState(() {
      _isCounting = true;
      _countingText = '${widget.duration} s';
    });

    _subscription = Observable.periodic(
            Duration(seconds: 1), (i) => widget.duration - i - 1)
        .take(widget.duration)
        .doOnDone(() => setState(() => _isCounting = false))
        .listen((value) => setState(() => _countingText = '$value s'));
  }
}
