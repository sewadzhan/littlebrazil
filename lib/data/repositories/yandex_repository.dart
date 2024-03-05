import 'dart:convert';
import 'package:http/http.dart';
import 'package:littlebrazil/view/config/restaurant_exception.dart';
import 'package:littlebrazil/data/providers/yandex_provider.dart';

class YandexRepository {
  final YandexProvider yandexProvider;

  YandexRepository(this.yandexProvider);

  Future<List<String>> getSuggestedAddresses(String query) async {
    Response response = await yandexProvider.getSuggestedAddresses(query, 7);
    if (response.statusCode == 200) {
      var str = response.body.substring(14);
      List<dynamic> body = jsonDecode(str.substring(0, str.length - 1));
      List<dynamic> list = body[1];
      List<String> result = [];
      for (int i = 0; i < list.length; i++) {
        List<dynamic> tmp = list[i];
        result.add(tmp[2]);
      }
      return result;
    }
    throw RestaurantException("Unable to retrieve organization ID");
  }
}
