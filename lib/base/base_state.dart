import 'dart:async';

import 'package:pts_lib/base/bloc.dart';
import 'package:pts_lib/widget/dialogs.dart';
import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget, B extends Bloc>
    extends State<T> {
  final subscriptions = <StreamSubscription>[];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  B bloc;

  @override
  void initState() {
    super.initState();
    bloc = createBloc();
  }

  @override
  dispose() {
    for (var sub in subscriptions) {
      sub.cancel();
    }

    if (bloc != null) {
      bloc.dispose();
    }

    super.dispose();
  }

  B createBloc() {
    return null;
  }

  close() {
    Navigator.of(context).pop();
  }

  showProgressDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog();
        });
  }

  hideProgressDialog() {
    Navigator.of(context).pop();
  }

  showMessage(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
      message,
      textAlign: TextAlign.center,
    )));
  }

  Future<T> navigateTo<T>(Widget target) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }
}
