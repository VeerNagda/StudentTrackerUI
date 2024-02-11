
class LoginRequestModel {
  late String _sap;
  late String _pass;

  LoginRequestModel(this._sap, this._pass);

  String get sap => _sap;

  set sap(String value) {
    _sap = value;
  }

  String get pass => _pass;

  set pass(String value) {
    _pass = value;
  }

  // Method to convert class to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sap'] = _sap;
    data['pass'] = _pass;
    return data;
  }

  // Method to create class from JSON
  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    _sap = json['sap'];
    _pass = json['pass'];
  }
}
