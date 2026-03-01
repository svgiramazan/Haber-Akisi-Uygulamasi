class Haber {
  String baslik;
  String icerik;
  final String? resimUrl;
  DateTime tarih;
  String kaynak;
  String url;
  bool favoriMi;

  Haber({
    required this.baslik,
    required this.icerik,
    this.resimUrl,
    required this.tarih,
    required this.kaynak,
    required this.url,
    this.favoriMi = false,
  });

  /// 🌐 API'den gelen JSON için
  factory Haber.fromJson(Map<String, dynamic> json) {
    return Haber(
      baslik: json['title'] ?? "",
      icerik: json['description'] ?? "",
      resimUrl: json['urlToImage'],
      kaynak: json['source']?['name'] ?? "",
      tarih: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt']) ?? DateTime.now()
          : DateTime.now(),
      url: json['url'] ?? "",
      favoriMi: false,
    );
  }

  /// 💾 Telefona kaydetmek için
  Map<String, dynamic> toJson() {
    return {
      "baslik": baslik,
      "icerik": icerik,
      "resimUrl": resimUrl,
      "tarih": tarih.toIso8601String(),
      "kaynak": kaynak,
      "url": url,
      "favoriMi": favoriMi,
    };
  }

  /// 📱 Telefondan geri yüklemek için
  factory Haber.fromLocalJson(Map<String, dynamic> json) {
    return Haber(
      baslik: json["baslik"] ?? "",
      icerik: json["icerik"] ?? "",
      resimUrl: json["resimUrl"],
      tarih: DateTime.tryParse(json["tarih"] ?? "") ?? DateTime.now(),
      kaynak: json["kaynak"] ?? "",
      url: json["url"] ?? "",
      favoriMi: json["favoriMi"] ?? false,
    );
  }
}
