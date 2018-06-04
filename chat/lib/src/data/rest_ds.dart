import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat/src/models/auth.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/utils/network_util.dart';
import 'package:http/http.dart' as http;

const String backendUrl = "http://192.168.0.24:3000";

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = "$backendUrl/api/auth/sign_in";

  Future<Auth> login(String email, String password, String device_token) {
    return _netUtil.post(LOGIN_URL, body: {
      "email": email,
      "password": password,
      "device_token": device_token,
    }).then((dynamic res) {
      var body = JSON.decode(res.body);

      print(body.toString());
      if (body["error"] != null) throw new Exception(body["error_msg"]);
      return new Auth.map(res);
    });
  }

  Future<ListMessage> getMessages([int page = 1]) {
    var MESSAGE_URL = "$backendUrl/api/messages?page=$page";
    return _netUtil.get(MESSAGE_URL).then((dynamic res) {
      var body = JSON.decode(res.body);

      print(body.toString());
      if (body["error"] != null) throw new Exception(body["error_msg"]);

      return new ListMessage.map(body);
    });
  }
}
