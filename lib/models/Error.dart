import 'dart:convert';

/// propertyName : "ToAddress"
/// errorMessage : "The length of 'To Address' must be at least 26 characters. You entered 16 characters."
/// attemptedValue : "MSrEScTooTrKkvaF"
/// customState : null
/// severity : 0
/// errorCode : "MinimumLengthValidator"
/// formattedMessagePlaceholderValues : {"MinLength":26,"MaxLength":-1,"TotalLength":16,"PropertyName":"To Address","PropertyValue":"MSrEScTooTrKkvaF"}

Error errorFromJson(String str) => Error.fromJson(json.decode(str));
String errorToJson(Error data) => json.encode(data.toJson());
class Error {
  Error({
      String? propertyName, 
      String? errorMessage, 
      String? attemptedValue, 
      dynamic customState, 
      int? severity, 
      String? errorCode, 
     }){
    _propertyName = propertyName;
    _errorMessage = errorMessage;
    _attemptedValue = attemptedValue;
    _customState = customState;
    _severity = severity;
    _errorCode = errorCode;
}

  Error.fromJson(dynamic json) {
    _propertyName = json['propertyName'];
    _errorMessage = json['errorMessage'];
    _attemptedValue = json['attemptedValue'];
    _customState = json['customState'];
    _severity = json['severity'];
    _errorCode = json['errorCode'];
  }
  String? _propertyName;
  String? _errorMessage;
  String? _attemptedValue;
  dynamic _customState;
  int? _severity;
  String? _errorCode;

  String? get propertyName => _propertyName;
  String? get errorMessage => _errorMessage;
  String? get attemptedValue => _attemptedValue;
  dynamic get customState => _customState;
  int? get severity => _severity;
  String? get errorCode => _errorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['propertyName'] = _propertyName;
    map['errorMessage'] = _errorMessage;
    map['attemptedValue'] = _attemptedValue;
    map['customState'] = _customState;
    map['severity'] = _severity;
    map['errorCode'] = _errorCode;

    return map;
  }

}