import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

import '../models/auth_status.dart';

class Auth with ChangeNotifier {
  String _tokenId = '';
  String _userId = '';
  DateTime _expiry = DateTime.now().subtract(const Duration(seconds: 1));

  String get token {
    return _tokenId;
  }

  String get usedId {
    return _userId;
  }

  DateTime get expiry {
    return _expiry;
  }

  bool isAuth() {
    return _tokenId != '' && _expiry.isAfter(DateTime.now());
  }

  void tryAuth() {
    SharedPreferences.getInstance().then((value) {
      if (value.containsKey("tokenId")) {
        _tokenId = value.getString("tokenId") as String;
        _userId = value.getString("userId") as String;
        _expiry = DateTime.parse(value.getString("expiry") as String);
      }
    }).then((value) {
      notifyListeners();
    });
  }

  Future<void> signUp(
    String email,
    String password,
    AuthStatus authStatus,
  ) async {
    final String urlSegment;
    if (authStatus == AuthStatus.login) {
      urlSegment = "signInWithPassword";
    } else {
      urlSegment = "signUp";
    }

    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=[API_KEY]",
    );
    final reqPayload = json.encode(
      {
        "email": email,
        "password": password,
        "returnSecureToken": true,
      },
    );

    try {
      final response = await http.post(
        url,
        body: reqPayload,
      );

      if (json.decode(response.body)["error"] != null) {
        throw HttpException(
          message: json.decode(response.body)["error"]["message"],
        );
      }
      _tokenId = json.decode(response.body)["idToken"];
      _userId = json.decode(response.body)["localId"];
      _expiry = DateTime.now().add(
        Duration(
          seconds: int.parse(
            json.decode(response.body)["expiresIn"],
          ),
        ),
      );
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("tokenId", _tokenId);
      await prefs.setString("userId", _userId);
      await prefs.setString("expiry", _expiry.toIso8601String());
    } catch (error) {
      rethrow;
    }
  }

  void signOut() {
    _tokenId = '';
    _userId = '';
    _expiry = DateTime.now().subtract(const Duration(seconds: 1));

    notifyListeners();

    SharedPreferences.getInstance().then((value) {
      value.clear();
    });
  }
}
