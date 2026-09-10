import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travio/main.dart';
import 'package:travio/data/wisata_data.dart';
import 'package:travio/utils/formatter.dart';
import 'package:travio/utils/kalkulator.dart';
import 'package:travio/widgets/penghitung_tiket.dart';

void main() {
  test('formatRupiah and formatUlasan test', () {
    expect(formatRupiah(15000), 'Rp15.000');
    expect(formatRupiah(0), 'Rp0');
    expect(formatRupiah(1000000), 'Rp1.000.000');
    expect(formatUlasan(1200), '1.2k');
    expect(formatUlasan(500), '500');
  });

  test('Kalkulator diskon rombongan 15% untuk minimal 20 orang test', () {
    // Kurang dari 20 orang: diskon 0
    final subtotal19 = hitungSubtotal(19, 0, 15000, 10000);
    expect(subtotal19, 285000);
    expect(hitungDiskon(subtotal19, 19), 0);
    expect(hitungTotalAkhir(subtotal19, 0), 285000);

    // Tepat 20 orang: diskon 15% (contoh PRD: Rp300.000 -> diskon Rp45.000 -> total Rp255.000)
    final subtotal20 = hitungSubtotal(20, 0, 15000, 10000);
    expect(subtotal20, 300000);
    final diskon20 = hitungDiskon(subtotal20, 20);
    expect(diskon20, 45000);
    expect(hitungTotalAkhir(subtotal20, diskon20), 255000);

    // Kombinasi dewasa dan anak: 10 dewasa (15.000) + 10 anak (10.000) = 20 orang, subtotal 250.000
    final subtotalKombinasi = hitungSubtotal(10, 10, 15000, 10000);
    expect(subtotalKombinasi, 250000);
    final diskonKombinasi = hitungDiskon(subtotalKombinasi, 20);
    expect(diskonKombinasi, 37500);
    expect(hitungTotalAkhir(subtotalKombinasi, diskonKombinasi), 212500);
  });

  testWidgets('PenghitungTiket menampilkan kalkulasi dan diskon rombongan 15%',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PenghitungTiket(
              namaObjek: 'Candi Borobudur',
              jenis: 'Budaya',
              hargaDewasa: 15000,
              hargaAnak: 10000,
              kuotaHarian: 100,
            ),
          ),
        ),
      ),
    );

    // Cek tampilan awal
    expect(find.text('Hitung Tiket'), findsOneWidget);
    expect(find.text('Candi Borobudur'), findsOneWidget);
    expect(find.text('0 orang'), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
    expect(find.text('Diskon'), findsOneWidget);

    // Tambah 20 dewasa menggunakan tombol +
    final tambahButtons = find.byIcon(Icons.add);
    final tambahDewasa = tambahButtons.first;

    for (int i = 0; i < 20; i++) {
      await tester.tap(tambahDewasa);
      await tester.pump();
    }

    // Cek setelah 20 orang
    expect(find.text('20 orang'), findsOneWidget);
    expect(find.text('Diskon Rombongan 15% Aktif!'), findsOneWidget);
    expect(find.text('Diskon Rombongan (15%)'), findsOneWidget);
    expect(find.text('-Rp45.000'), findsOneWidget);
    expect(find.text('Rp255.000'), findsOneWidget);
  });

  testWidgets('TravioApp smoke test and data test', (WidgetTester tester) async {
    // Verify destination data has 16 items across 4 categories
    final wisataList = getSemuaWisata();
    expect(wisataList.length, 16);

    final alam = wisataList.where((w) => w.jenis == 'Alam').toList();
    final air = wisataList.where((w) => w.jenis == 'Air').toList();
    final edukasi = wisataList.where((w) => w.jenis == 'Edukasi').toList();
    final budaya = wisataList.where((w) => w.jenis == 'Budaya').toList();

    expect(alam.length, 4);
    expect(air.length, 4);
    expect(edukasi.length, 4);
    expect(budaya.length, 4);

    // Build TravioApp smoke test
    await tester.pumpWidget(const TravioApp());
    expect(find.byType(TravioApp), findsOneWidget);

    // Advance clock past splash timer (2.8s) to avoid pending timer
    await tester.pump(const Duration(seconds: 4));
  });
}
