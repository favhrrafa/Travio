import 'package:flutter_test/flutter_test.dart';
import 'package:travio/main.dart';
import 'package:travio/data/wisata_data.dart';

void main() {
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
