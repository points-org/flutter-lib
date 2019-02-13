import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

typedef RxFormFieldValidator<T> = bool Function(T value);

class RxTextFormField extends StatefulWidget {
  final Key key;
  final BehaviorSubject<String> stream;
  final String initialValue;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextStyle style;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool autovalidate;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldSetter<String> onSaved;
  final RxFormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;

  RxTextFormField({
    this.key,
    @required this.stream,
    this.initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.autovalidate = false,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<RxTextFormField> {
  final _controller = TextEditingController();
  StreamSubscription _subscription;
  bool _valid = false;
  final Widget _validIcon = Icon(
    Icons.check_circle,
    color: Colors.green,
  );
  final Widget _invalidIcon = Icon(Icons.error, color: Colors.red);

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.text != widget.stream.value) {
        widget.stream.add(_controller.text);
        if (widget.validator != null) {
          setState(() {
            _valid = widget.validator(_controller.text);
          });
        }
      }
    });

    _subscription = widget.stream.listen((value) {
      if (value != _controller.text) {
        final offset = value.length;
        _controller.value = _controller.value.copyWith(
            text: value,
            selection: TextSelection.collapsed(offset: offset),
            composing: TextRange.empty);
        if (widget.validator != null) {
          setState(() {
            _valid = widget.validator(value);
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      controller: _controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      decoration: widget.validator != null
          ? widget.decoration
              .copyWith(suffixIcon: _valid ? _validIcon : _invalidIcon)
          : widget.decoration,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      style: widget.style,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      autovalidate: widget.autovalidate,
      maxLengthEnforced: widget.maxLengthEnforced,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
    );
  }
}
