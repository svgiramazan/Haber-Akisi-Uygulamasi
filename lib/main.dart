import 'package:flutter/material.dart';
import 'haber_model.dart';
import 'haber_detay.dart';
import 'haber_servis.dart';
import 'app_state.dart';
const Color anaKirmizi = Color(0xFFE30A17);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  favoriler = await FavoriServisi.yukle();
  runApp(HaberUygulamasi());
}

class HaberUygulamasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Haber Uygulaması",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: anaKirmizi,
          primary: anaKirmizi,
          secondary: anaKirmizi,
          background: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: anaKirmizi,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: anaKirmizi,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: anaKirmizi,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int seciliIndex = 0;

  void _tabDegistir(int index) {
    setState(() {
      seciliIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sayfalar = [
      HaberListesi(),   // 1. Tab
      FavorilerSayfasi() // 2. Tab
    ];

    return Scaffold(
      body: sayfalar[seciliIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliIndex,
        onTap: _tabDegistir,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "Haberler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favoriler",
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// HABER LİSTESİ (Ana Sayfa)
//////////////////////////////////////////////////////////////

class HaberListesi extends StatefulWidget {
  @override
  State<HaberListesi> createState() => _HaberListesiState();
}

class _HaberListesiState extends State<HaberListesi> {

  List<Haber> tumHaberler = [];
  List<Haber> filtrelenmisHaberler = [];

  String seciliKategori = "teknoloji";
  bool yukleniyor = true;

  TextEditingController aramaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    haberleriYukle(seciliKategori);
  }

  Future<void> haberleriYukle(String sorgu) async {
    setState(() {
      yukleniyor = true;
    });

    final servis = HaberServisi();
    final gelenHaberler = await servis.haberleriGetir(sorgu);
    for (var haber in gelenHaberler) {
      if (favoriler.any((f) => f.url == haber.url)) {
        haber.favoriMi = true;
      }
    }
    setState(() {
      tumHaberler = gelenHaberler;
      filtrelenmisHaberler = gelenHaberler;
      yukleniyor = false;
    });
  }

  void aramaYap(String kelime) async {

    if (kelime.isEmpty) {
      haberleriYukle(seciliKategori);
      return;
    }

    setState(() {
      yukleniyor = true;
    });

    final servis = HaberServisi();
    final gelenHaberler = await servis.haberleriGetir(kelime);

    setState(() {
      tumHaberler = gelenHaberler;
      filtrelenmisHaberler = gelenHaberler;
      yukleniyor = false;
    });
  }

  Widget kategoriButon(String kategori, String baslik) {
    bool secili = seciliKategori == kategori;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ChoiceChip(
        label: Text(baslik),
        selected: secili,
        selectedColor: anaKirmizi,
        labelStyle: TextStyle(
          color: secili ? Colors.white : anaKirmizi,
          fontWeight: FontWeight.bold,
        ),
        onSelected: (_) {
          setState(() {
            seciliKategori = kategori;
          });
          haberleriYukle(kategori);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: aramaController,
            decoration: const InputDecoration(
              hintText: "Haber ara...",
              border: InputBorder.none,
              icon: Icon(Icons.search, color: anaKirmizi),
            ),
            onChanged: aramaYap,
          ),
        ),
      ),
      body: Column(
        children: [

          //  Kategoriler
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                kategoriButon("teknoloji", "Teknoloji"),
                kategoriButon("spor", "Spor"),
                kategoriButon("ekonomi", "Ekonomi"),
                kategoriButon("sağlık", "Sağlık"),
              ],
            ),
          ),

          //  Liste
          Expanded(
            child: yukleniyor
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filtrelenmisHaberler.length,
              itemBuilder: (context, index) {
                final haber = filtrelenmisHaberler[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: haber.resimUrl != null &&
                          haber.resimUrl!.isNotEmpty
                          ? Image.network(
                        haber.resimUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
                    ),
                    title: Text(
                      haber.baslik,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      haber.kaynak,
                      style: TextStyle(color: anaKirmizi),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HaberDetay(haber: haber),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


//////////////////////////////////////////////////////////////
/// FAVORİLER SAYFASI
//////////////////////////////////////////////////////////////

class FavorilerSayfasi extends StatefulWidget {
  @override
  State<FavorilerSayfasi> createState() => _FavorilerSayfasiState();
}

class _FavorilerSayfasiState extends State<FavorilerSayfasi> {

  @override
  Widget build(BuildContext context) {

    if (favoriler.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Favoriler")),
        body: Center(
          child: Text("Henüz favori eklenmedi."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Favoriler")),
      body: ListView.builder(
        itemCount: favoriler.length,
        itemBuilder: (context, index) {
          final haber = favoriler[index];

          return ListTile(
            leading: Image.network(
              haber.resimUrl ?? "",
              width: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image),
                );
              },
            ),
            title: Text(haber.baslik),
            subtitle: Text(haber.kaynak),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HaberDetay(haber: haber),
                ),
              ).then((_) {
                setState(() {}); // geri dönünce liste yenilensin
              });
            },
          );
        },
      ),
    );
  }
}
