import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'haber_model.dart';
import 'app_state.dart';


class HaberDetay extends StatefulWidget {
  final Haber haber;

  HaberDetay({required this.haber});

  @override
  State<HaberDetay> createState() => _HaberDetayState();
}

class _HaberDetayState extends State<HaberDetay> {

  void _favoriToggle() async {
    setState(() {
      if (widget.haber.favoriMi) {
        favoriler.removeWhere((h) => h.url == widget.haber.url);
      } else {
        favoriler.add(widget.haber);
      }

      widget.haber.favoriMi = !widget.haber.favoriMi;
    });

    await FavoriServisi.kaydet(favoriler);
  }

  Future<void> _linkAc() async {
    if (widget.haber.url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Geçerli link bulunamadı")),
      );
      return;
    }

    final Uri url = Uri.parse(widget.haber.url);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Link açılamadı")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haber Detayı"),
        actions: [
          // 🔗 Paylaşma
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                  "${widget.haber.baslik}\n\nDetaylar için: ${widget.haber.url}");
            },
          ),

          // ⭐ Favori Butonu
          IconButton(
            icon: Icon(
              widget.haber.favoriMi
                  ? Icons.star
                  : Icons.star_border,
            ),
            onPressed: _favoriToggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Haber Resmi

        widget.haber.resimUrl != null && widget.haber.resimUrl!.isNotEmpty
        ? Image.network(
        widget.haber.resimUrl!,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 250,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, size: 50),
          ),
        )
            : Container(
        height: 250,
        color: Colors.grey[300],
        child: Icon(Icons.image_not_supported, size: 50),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📰 Başlık
                  Text(
                    widget.haber.baslik,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  // 📅 Kaynak & Tarih
                  Text(
                    "${widget.haber.kaynak} • ${widget.haber.tarih.day}.${widget.haber.tarih.month}.${widget.haber.tarih.year}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),

                  Divider(height: 30),

                  // 📖 İçerik
                  Text(
                    widget.haber.icerik,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 30),

                  // 🌍 Haber Kaynağı Butonu
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _linkAc,
                      icon: Icon(Icons.open_in_browser),
                      label: Text("Haber Kaynağına Git"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
