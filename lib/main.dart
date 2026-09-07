import 'package:flutter/material.dart';
import 'models/objek_wisata.dart';
import 'data/wisata_data.dart';
import 'widgets/objek_wisata_card.dart';
import 'widgets/penghitung_tiket.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const TravioApp());
}

class TravioApp extends StatelessWidget {
  const TravioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.secondary.withOpacity(0.08),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ObjekWisata wisata = getSampleWisata();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ObjekWisataCard(
              namaObjek: wisata.namaObjek,
              jenis: wisata.jenis,
              tiketDewasa: wisata.tiketDewasa,
              tiketAnak: wisata.tiketAnak,
              kuotaHarian: wisata.kuotaHarian,
            ),
            const SizedBox(height: 16),
            PenghitungTiket(
              namaObjek: wisata.namaObjek,
              hargaDewasa: wisata.tiketDewasa,
              hargaAnak: wisata.tiketAnak,
            ),
          ],
        ),
      ),
    );
  }
}