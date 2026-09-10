import 'package:flutter/material.dart';
import '../utils/formatter.dart';
import '../utils/kalkulator.dart';
import '../utils/app_colors.dart';

class PenghitungTiket extends StatefulWidget {
  final String namaObjek;
  final String? jenis;
  final int hargaDewasa;
  final int hargaAnak;
  final int? kuotaHarian;

  const PenghitungTiket({
    super.key,
    required this.namaObjek,
    this.jenis,
    required this.hargaDewasa,
    required this.hargaAnak,
    this.kuotaHarian,
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
    final int totalPengunjung = hitungJumlahPengunjung(jumlahDewasa, jumlahAnak);
    final int subtotal = hitungSubtotal(
      jumlahDewasa,
      jumlahAnak,
      widget.hargaDewasa,
      widget.hargaAnak,
    );
    final int diskon = hitungDiskon(subtotal, totalPengunjung);
    final int totalAkhir = hitungTotalAkhir(subtotal, diskon);
    final bool dapatDiskon = totalPengunjung >= 20;
    final bool kuotaAman = widget.kuotaHarian == null ||
        cekKuota(totalPengunjung, widget.kuotaHarian!);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hitung Tiket',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (widget.jenis != null && widget.jenis!.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.jenis!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(widget.namaObjek, style: TextStyle(color: Colors.grey[600])),
          if (widget.kuotaHarian != null) ...[
            const SizedBox(height: 4),
            Text(
              'Kuota harian: ${widget.kuotaHarian} orang',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jumlah Pengunjung',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '$totalPengunjung orang',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: dapatDiskon
                      ? const Color(0xFF2E7D32)
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          buildJumlahRow(
            'Dewasa',
            jumlahDewasa,
            widget.hargaDewasa,
            tambahDewasa,
            kurangDewasa,
          ),
          const SizedBox(height: 8),
          buildJumlahRow(
            'Anak',
            jumlahAnak,
            widget.hargaAnak,
            tambahAnak,
            kurangAnak,
          ),
          const SizedBox(height: 12),
          // Banner Status Diskon Rombongan
          _buildDiskonBanner(dapatDiskon, totalPengunjung, diskon),
          // Peringatan kuota jika melampaui batas harian
          if (!kuotaAman) ...[
            const SizedBox(height: 8),
            _buildKuotaWarning(totalPengunjung, widget.kuotaHarian!),
          ],
          const Divider(height: 24),
          const Text(
            'Rincian Harga',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          buildRincianRow(
            'Tiket Dewasa ($jumlahDewasa × ${formatRupiah(widget.hargaDewasa)})',
            formatRupiah(jumlahDewasa * widget.hargaDewasa),
          ),
          buildRincianRow(
            'Tiket Anak ($jumlahAnak × ${formatRupiah(widget.hargaAnak)})',
            formatRupiah(jumlahAnak * widget.hargaAnak),
          ),
          buildRincianRow(
            'Subtotal',
            formatRupiah(subtotal),
            isBold: true,
          ),
          buildRincianRow(
            dapatDiskon ? 'Diskon Rombongan (15%)' : 'Diskon',
            dapatDiskon ? '-${formatRupiah(diskon)}' : 'Rp0',
            valueColor: dapatDiskon ? const Color(0xFF2E7D32) : null,
            isBold: dapatDiskon,
          ),
          const SizedBox(height: 12),
          buildTotalBox(totalAkhir, subtotal, diskon),
        ],
      ),
    );
  }

  Widget _buildDiskonBanner(
    bool dapatDiskon,
    int totalPengunjung,
    int diskon,
  ) {
    if (dapatDiskon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFA5D6A7)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diskon Rombongan 15% Aktif!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  Text(
                    'Hemat ${formatRupiah(diskon)} untuk rombongan $totalPengunjung orang.',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final int sisaOrang = 20 - totalPengunjung;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.discount_outlined,
            size: 16,
            color: Color(0xFFF57C00),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              totalPengunjung > 0
                  ? 'Tambah $sisaOrang orang lagi untuk diskon 15%!'
                  : 'Diskon 15% berlaku untuk rombongan minimal 20 orang.',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB78103),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKuotaWarning(int totalPengunjung, int kuotaHarian) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: Color(0xFFD32F2F),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pengunjung ($totalPengunjung) melebihi kuota harian ($kuotaHarian orang)!',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC62828),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildJumlahRow(
    String label,
    int jumlah,
    int hargaSatuan,
    VoidCallback onTambah,
    VoidCallback onKurang,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                formatRupiah(hargaSatuan),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        buildBulatButton(Icons.remove, onKurang),
        SizedBox(
          width: 36,
          child: Text(
            jumlah.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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

  Widget buildRincianRow(
    String label,
    String nilai, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isBold ? Colors.black87 : Colors.grey[600],
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            nilai,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? (isBold ? Colors.black87 : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalBox(int totalAkhir, int subtotal, int diskon) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Akhir',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if (diskon > 0)
                Text(
                  'Hemat ${formatRupiah(diskon)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          Text(
            formatRupiah(totalAkhir),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
