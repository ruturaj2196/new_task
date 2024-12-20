import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/list_of_stores_model.dart';

class FetchStoresList {
  Future<List<Data>> fetchStoreData() async {
    const String apiUrl = 'https://atomicbrain.neosao.online/nearest-store';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decoding the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Parsing the response into ListOfStores model
        final ListOfStores storeList = ListOfStores.fromJson(jsonResponse);
        // debugPrint(storeList.data.toString());
        // Returning the data list
        return storeList.data ?? [];
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred: $error');
    }
  }
}
