import 'package:rxdart/rxdart.dart';

abstract class TokenStore {
  Observable<String> getToken();
}