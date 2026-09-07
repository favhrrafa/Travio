import 'package:flutter/material.dart';
import '../utils/formatter.dart';
import '../utils/kalkulator.dart';
import '../utils/app_colors.dart';

class PenghitungTiket extends StatefulWidget {
  final String namaObjek;
  final int hargaDewasa;
  final int hargaAnak;

  const PenghitungTiket({
    super.key,
    required this.namaObjek,
    required this.hargaDewasa,
    required this.hargaAnak,
  });

  @override
  State<PenghitungTiket> createState() => _PenghitungTiketState();
}

class _PenghitungTiketState extends State<PenghitungTiket> {
  int jumlahDewasa = 0;
  int jumlahAnak = 0;

  void tambahDewasa() {
    setState(() {
      jumlahDewasa++;
    });
  }

  void kurangDewasa() {
    setState(() {
      if (jumlahDewasa > 0) jumlahDewasa--;
    });
  }

  void tambahAnak() {
    setState(() {
      jumlahAnak++;
    });
  }

  void kurangAnak() {
    setState(() {
      if (jumlahAnak > 0) jumlahAnak--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int total = hitungTotalTiket(
      jumlahDewasa,
      jumlahAnak,
      widget.hargaDewasa,
      widget.hargaAnak,
    );

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hitung Tiket',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(widget.namaObjek, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 16),
          const Text('Jumlah Pengunjung', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          buildJumlahRow('Dewasa', jumlahDewasa, tambahDewasa, kurangDewasa),
          const SizedBox(height: 8),
          buildJumlahRow('Anak', jumlahAnak, tambahAnak, kurangAnak),
          const Divider(height: 24),
          const Text('Rincian Harga', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          buildRincianRow(
            'Tiket Dewasa (${formatRupiah(widget.hargaDewasa)})',
            jumlahDewasa * widget.hargaDewasa,
          ),
          buildRincianRow(
            'Tiket Anak (${formatRupiah(widget.hargaAnak)})',
            jumlahAnak * widget.hargaAnak,
          ),
          const SizedBox(height: 12),
          buildTotalBox(total),
        ],
      ),
    );
  }

  // Baris kontrol jumlah pengunjung dengan tombol bulat -/+.
  Widget buildJumlahRow(String label, int jumlah, VoidCallback onTambah, VoidCallback onKurang) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        buildBulatButton(Icons.remove, onKurang),
        SizedBox(
          width: 32,
          child: Text(
            jumlah.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        buildBulatButton(Icons.add, onTambah),
      ],
    );
  }

  Widget buildBulatButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: AppColors.accent),
      ),
    );
  }

  Widget buildRincianRow(String label, int subtotal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Text(formatRupiah(subtotal), style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget buildTotalBox(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Harga', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            formatRupiah(total),
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}