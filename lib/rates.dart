// курсы всех валют относительно base
class Rates {
  final String base;
  final Map<String, double> rates;
  final DateTime time; // когда сервер обновил курс

  Rates(this.base, this.rates, this.time);

  factory Rates.fromJson(Map<String, dynamic> json) {
    Map<String, double> r = {};
    (json['rates'] as Map<String, dynamic>).forEach((k, v) {
      r[k] = (v as num).toDouble(); // там бывают и int и double
    });
    int unix = json['time_last_update_unix'];
    return Rates(
      json['base_code'],
      r,
      DateTime.fromMillisecondsSinceEpoch(unix * 1000),
    );
  }
}
