class InternetModel {
  static bool? _isOff;

  static set setOff(bool off) {
    _isOff = off;
  }

  static bool get isOff {
    return _isOff ?? false;
  }
}
