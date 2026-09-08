import 'package:flutter/material.dart';
import '../utils/formatter.dart';
import '../utils/app_colors.dart';

class ObjekWisataCard extends StatelessWidget {
  final String namaObjek;
  final String jenis;
  final int tiketDewasa;
  final int tiketAnak;
  final int kuotaHarian;

  const ObjekWisataCard({
    super.key,
    required this.namaObjek,
    required this.jenis,
    required this.tiketDewasa,
    required this.tiketAnak,
    required this.kuotaHarian,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          buildThumbnail(),
          const SizedBox(width: 12),
          Expanded(child: buildInfo()),
          const Icon(Icons.chevron_right, color: AppColors.accent),
        ],
      ),
    );
  }

  // Placeholder thumbnail (ikon), karena belum ada aset gambar objek wisata.
  Widget buildThumbnail() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.landscape, color: AppColors.accent),
    );
  }

  Widget buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          namaObjek,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(jenis, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          'Kuota: $kuotaHarian orang/hari',
          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
        ),
        const SizedBox(height: 4),
        Text(
          formatRupiah(tiketDewasa),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}
