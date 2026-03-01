// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:haber3/main.dart';

void main() {
  testWidgets('Haber Uygulaması arayüz yükleme testi', (WidgetTester tester) async {
    // Uygulamayı başlatır. 'const' anahtar kelimesini kaldırdık
    // çünkü ana sayfa artık dinamik veri çekiyor.
    await tester.pumpWidget(HaberUygulamasi());

    // Uygulama başlığının (AppBar) ekranda olup olmadığını kontrol eder.
    expect(find.text('HABER AKIŞI UYGULAMASI'), findsOneWidget);

    // Arama çubuğunun (TextField) varlığını kontrol eder.
    expect(find.byType(TextField), findsOneWidget);

    // Başlangıçta haber listesinin yüklenme çemberini veya
    // liste elemanlarını arayabiliriz.
  });
}
