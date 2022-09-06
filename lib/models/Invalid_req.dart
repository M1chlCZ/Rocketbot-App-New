import 'Error.dart';
import 'dart:convert';

/// message : "Validation error."
/// hasError : true
/// error : [{"propertyName":"ToAddress","errorMessage":"The length of 'To Address' must be at least 26 characters. You entered 16 characters.","attemptedValue":"MSrEScTooTrKkvaF","customState":null,"severity":0,"errorCode":"MinimumLengthValidator","formattedMessagePlaceholderValues":{"MinLength":26,"MaxLength":-1,"TotalLength":16,"PropertyName":"To Address","PropertyValue":"MSrEScTooTrKkvaF"}}]
/// data : null

InvalidReq invalidReqFromJson(String str) => InvalidReq.fromJson(json.decode(str));
String invalidReqToJson(InvalidReq data) => json.encode(data.toJson());
class InvalidReq {
  InvalidReq({
      String? message, 
      bool? hasError, 
      List<Error>? error, 
      dynamic data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  InvalidReq.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    if (json['error'] != null) {
      _error = [];
      json['error'].forEach((v) {
        _error?.add(Error.fromJson(v));
      });
    }
    _data = json['data'];
  }
  String? _message;
  bool? _hasError;
  List<Error>? _error;
  dynamic _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  List<Error>? get error => _error;
  dynamic get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    if (_error != null) {
      map['error'] = _error?.map((v) => v.toJson()).toList();
    }
    map['data'] = _data;
    return map;
  }

}