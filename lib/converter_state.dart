import 'package:flutter/foundation.dart';
import 'api_client.dart';
import 'currency_repository.dart';
import 'rates.dart';

enum Status { none, loading, success, error }

class ConverterState extends ChangeNotifier {
  final CurrencyRepository repo;
  ConverterState(this.repo);

  String from = 'EUR';
  String to = 'RUB';
  Status status = Status.none;
  String errMsg = '';

  // последний результат
  double amount = 0;
  double res = 0;
  double rate = 0;
  String resFrom = '';
  String resTo = '';
  DateTime? time;

  List<String> history = [];

  void setFrom(String c) {
    if (status == Status.loading) {
      return;
    }
    from = c;
    notifyListeners();
  }

  void setTo(String c) {
    if (status == Status.loading) {
      return;
    }
    to = c;
    notifyListeners();
  }

  void swap() {
    String t = from;
    from = to;
    to = t;
    notifyListeners();
  }

  Future<void> convert(String text) async {
    text = text.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (text.isEmpty) {
      showErr('Введите сумму');
      return;
    }
    double? a = double.tryParse(text);
    if (a == null) {
      showErr('Некорректная сумма');
      return;
    }
    if (a <= 0) {
      showErr('Сумма должна быть больше нуля');
      return;
    }

    status = Status.loading;
    notifyListeners();

    try {
      Rates r = await repo.getRates(from);
      if (!r.rates.containsKey(to)) {
        showErr('Нет курса для $to');
        return;
      }
      amount = a;
      rate = r.rates[to]!;
      res = a * rate;
      resFrom = from;
      resTo = to;
      time = r.time.toLocal();
      status = Status.success;

      DateTime now = DateTime.now();
      history.insert(0,
          '${two(now.hour)}:${two(now.minute)}   ${fmt(amount)} $from = ${fmt(res)} $to');
      if (history.length > 10) {
        history.removeLast();
      }
      notifyListeners();
    } on ApiError catch (e) {
      showErr(e.msg);
    }
  }

  void showErr(String msg) {
    errMsg = msg;
    status = Status.error;
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
  }

  String fmt(double x) {
    // мелкие суммы с большим колвом знаков (1 донг)
    int n = 2;
    if (x < 1) n = 4;
    if (x < 0.01) n = 6;
    String s = x.toStringAsFixed(n);
    int dot = s.indexOf('.');
    if (dot == -1) return s;
    String whole = s.substring(0, dot);
    String out = '';
    for (int i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        out += ' ';
      }
      out += whole[i];
    }
    return out + s.substring(dot);
  }

  String two(int n) {
    return n.toString().padLeft(2, '0');
  }

  String timeStr(DateTime t) {
    return '${two(t.day)}.${two(t.month)}.${t.year} ${two(t.hour)}:${two(t.minute)}';
  }
}
