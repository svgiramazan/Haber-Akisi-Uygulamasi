import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'haber_model.dart';
import 'haber_model.dart';

List<Haber> favoriler = [];

class FavoriServisi {

  static const String key = "favoriler";

  static Future<void> kaydet(List<Haber> liste) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> jsonList =
    liste.map((haber) => jsonEncode(haber.toJson())).toList();

    await prefs.setStringList(key, jsonList);
  }

  static Future<List<Haber>> yukle() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key);

    if (jsonList == null) return [];

    return jsonList
        .map((item) => Haber.fromLocalJson(jsonDecode(item))) // Haber.fromJson yerine Haber.fromLocalJson kullanın
        .toList();
  }
}
