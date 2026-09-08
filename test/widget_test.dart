import 'package:flutter_test/flutter_test.dart';
import 'package:travio/main.dart';
import 'package:travio/data/wisata_data.dart';
import 'package:travio/utils/formatter.dart';

void main() {
  test('formatRupiah and formatUlasan test', () {
    expect(formatRupiah(15000), 'Rp15.000');
    expect(formatRupiah(0), 'Rp0');
    expect(formatRupiah(1000000), 'Rp1.000.000');
    expect(formatUlasan(1200), '1.2k');
    expect(formatUlasan(500), '500');
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
