import 'dart:convert';
import 'package:http/http.dart' as http;
import 'haber_model.dart';

class HaberServisi {
  // NewsAPI.org sitesinden aldığın anahtar
  final String _apiKey = '327a0eb5a93d4f29ac5c187c44ae07b4';

  Future<List<Haber>> haberleriGetir(String sorgu) async {
    // Belge Madde 4: Kullanıcı herhangi bir konu hakkında arama yapabilmeli
    // Türkçe sonuçlar için 'language=tr' ekledik
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$sorgu&apiKey=$_apiKey&language=tr');

    try {
      final cevap = await http.get(url);

      if (cevap.statusCode == 200) {
        final veri = json.decode(cevap.body);
        List makaleler = veri['articles'];

        // İnternetten gelen ham veriyi (Map), Flutter'da kullandığımız Haber nesnesine dönüştürüyoruz
        return makaleler.map((m) => Haber(
          baslik: m['title'] ?? "Başlık Mevcut Değil",
          icerik: m['description'] ?? "Bu haberin içeriği bulunamadı.",
          resimUrl: m['urlToImage'] ?? "https://via.placeholder.com/150",
          tarih: DateTime.parse(m['publishedAt'] ?? DateTime.now().toString()),
          kaynak: m['source']['name'] ?? "Bilinmiyor",
          url: m['url'] ?? "", // WebView için orijinal haber linki
        )).toList();
      } else {
        // API hata döndürürse (örneğin limit aşımı)
        throw Exception('Haberler getirilemedi: ${cevap.statusCode}');
      }
    } catch (e) {
      // Bağlantı hatası veya diğer hatalar için
      throw Exception('Bir hata oluştu: $e');
    }
  }
}