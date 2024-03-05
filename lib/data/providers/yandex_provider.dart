import 'package:http/http.dart';

class YandexProvider {
  Future<Response> getSuggestedAddresses(String query, int numOfResults) async {
    return await get(
      Uri.parse(
          'https://suggest-maps.yandex.ru/suggest-geo?lang=ru_RU&highlight=0&fullpath=1&n=$numOfResults&part=Казахстан, Алматы, $query'),
      headers: {
        "content-type": "application/json",
      },
    );
  }
}
