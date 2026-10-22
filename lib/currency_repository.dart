import 'api_client.dart';
import 'rates.dart';

class CurrencyRepository {
  final ApiClient api;
  CurrencyRepository(this.api);

  Future<Rates> getRates(String base) async {
    Map<String, dynamic> json = await api.getLatest(base);
    try {
      return Rates.fromJson(json);
    } catch (e) {
      // не те поля или не тот тип
      throw ApiError('Некорректный ответ сервера');
    }
  }
}
