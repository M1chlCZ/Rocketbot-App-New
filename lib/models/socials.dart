class Socials {
  String? message;
  bool? hasError;
  Null? error;
  Data? data;

  Socials({this.message, this.hasError, this.error, this.data});

  Socials.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    hasError = json['hasError'];
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['hasError'] = hasError;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? url;

  Data({this.url});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
