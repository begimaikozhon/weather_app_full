class ApiConst {
  static const String apiKey = 'ced098463ae46cb45db3c6f0d4d4a086';
  static const String cityNameOsh = 'osh';
  static const String cityNameBishkek = 'bishkek';
  static const String api =
      'https://api.openweathermap.org/data/2.5/weather?q=$cityNameOsh&appid=$apiKey';
  static String getIcon(String icon, int size) {
    return 'https://openweathermap.org/img/wn/$icon@${size}x.png';
  }
}
