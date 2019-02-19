import 'dart:async';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:pts_lib/util/token_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cognito implements TokenStore {
  final _sharedPrefs = SharedPreferences.getInstance();
  final CognitoUserPool _userPool;
  final _isSignedIn = BehaviorSubject<bool>();

  CognitoUser _currentUser;

  Cognito(String userPoolId, String clientId)
      : _userPool = CognitoUserPool(userPoolId, clientId, storage: _Storage());

  _setUsername(String username) async {
    final prefs = await _sharedPrefs;
    return await prefs.setString('username', username);
  }

  Future<CognitoUser> _getCurrentUser() {
    if (_currentUser != null) {
      return Future.value(_currentUser);
    } else {
      return _userPool.getCurrentUser().then((user) {
        _currentUser = user;
        return user;
      });
    }
  }

  Future<String> _getUsername() {
    return _sharedPrefs.then((prefs) => prefs.get('username'));
  }

  Observable<CognitoUserProperties> getUserProperties() {
    return Observable.zip2(Observable.fromFuture(_getCurrentUser()),
        Observable.fromFuture(_getUsername()), (user, username) {
      return CognitoUserProperties(user.username, username);
    });
  }

  BehaviorSubject<bool> isSignedIn() {
    if (_isSignedIn.value == null) {
      _getUsername().then((username) => _isSignedIn.add(username != null));
    }

    return _isSignedIn;
  }

  Observable<void> signIn(String username, String password) {
    final user = CognitoUser(username, _userPool, storage: _userPool.storage);
    final authenticationDetails =
        AuthenticationDetails(username: username, password: password);
    return Observable.fromFuture(user.authenticateUser(authenticationDetails))
        .doOnData((_) {
      _setUsername(username);
      _isSignedIn.add(true);
    });
  }

  @override
  Observable<String> getToken() {
    return Observable.fromFuture(_getCurrentUser()).flatMap((user) {
      if (user == null) {
        return Observable.just(null);
      } else {
        return Observable.fromFuture(user.getSession())
            .map((session) => session.idToken.jwtToken);
      }
    });
  }

  Observable<void> signUp(String username, String password,
      {List<AttributeArg> attributes}) {
    return Observable<void>.fromFuture(
            _userPool.signUp(username, password, userAttributes: attributes))
        .onErrorResume((error) {
      if (error is CognitoClientException &&
          error.code == 'UsernameExistsException') {
        return resendConfirmationCode(username);
      } else {
        return Observable.error(error);
      }
    });
  }

  Observable<void> confirmSignUp(
      String username, String password, String verificationCode) {
    final user = CognitoUser(username, _userPool, storage: _userPool.storage);
    return Observable.fromFuture(user.confirmRegistration(verificationCode))
        .flatMap((_) => signIn(username, password));
  }

  Observable<void> resendConfirmationCode(String username) {
    final user = CognitoUser(username, _userPool, storage: _userPool.storage);
    return Observable.fromFuture(user.resendConfirmationCode());
  }

  Observable<void> forgotPassword(String username) {
    final user = CognitoUser(username, _userPool, storage: _userPool.storage);
    return Observable.fromFuture(user.forgotPassword());
  }

  Observable<void> confirmPassword(
      String username, String verificationCode, String newPassword) {
    final user = CognitoUser(username, _userPool, storage: _userPool.storage);
    return Observable.fromFuture(
        user.confirmPassword(verificationCode, newPassword));
  }

  Observable<void> getAttributeVerificationCode() {
    return Observable.fromFuture(_getCurrentUser()).flatMap((user) =>
        Observable.fromFuture(user.getAttributeVerificationCode('email')));
  }

  Observable<void> verifyAttribute(String code) {
    return Observable.fromFuture(_getCurrentUser()).flatMap(
        (user) => Observable.fromFuture(user.verifyAttribute('email', code)));
  }

  signOut() {
    _getCurrentUser().then((user) {
      user.signOut();
      _currentUser = null;
    });
    _sharedPrefs.then((prefs) => prefs.remove('username'));
    _isSignedIn.add(false);
  }
}

class _Storage extends CognitoStorage {
  final _sharedPrefs = SharedPreferences.getInstance();
  static const String _prefix = 'cognito.';

  @override
  Future<void> clear() {
    return _sharedPrefs.then((prefs) {
      for (String key in prefs.getKeys()) {
        if (key.startsWith(_prefix)) {
          prefs.remove(key);
        }
      }
    });
  }

  @override
  Future getItem(String key) {
    return _sharedPrefs.then((prefs) => prefs.get('$_prefix$key'));
  }

  @override
  Future removeItem(String key) {
    return _sharedPrefs.then((prefs) => prefs.remove('$_prefix$key'));
  }

  @override
  Future setItem(String key, value) {
    return _sharedPrefs.then((prefs) => prefs.setString('$_prefix$key', value));
  }
}

class CognitoUserProperties {
  final String id;
  final String username;

  CognitoUserProperties(this.id, this.username);
}
