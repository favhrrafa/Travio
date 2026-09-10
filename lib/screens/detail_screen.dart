import 'package:flutter/material.dart';
import '../models/objek_wisata.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';
import '../widgets/penghitung_tiket.dart';

/// Halaman Detail Destinasi — Menampilkan informasi lengkap satu objek wisata.
/// Sesuai Mockup layar ke-5 (baris bawah pertama) dan PRD Bab 17:
/// 1. Foto hero destinasi dengan tombol kembali & tombol favorit
/// 2. Nama wisata beserta badge kategori
/// 3. Lokasi & provinsi dengan ikon penanda
/// 4. Rating bintang & jumlah ulasan
/// 5. Deskripsi lengkap objek wisata
/// 6. Tiga kartu fitur (Jam Buka, Kuota Harian, Fasilitas)
/// 7. Rincian harga tiket dewasa & anak beserta promo rombongan
/// 8. Tombol sticky "Hitung Tiket" yang membuka layar perhitungan tiket
class DetailScreen extends StatefulWidget {
  final ObjekWisata wisata;

  const DetailScreen({super.key, required this.wisata});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Status tombol favorit (like/unlike)
  bool _isFavorit = false;

  void _toggleFavorit() {
    setState(() => _isFavorit = !_isFavorit);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorit
              ? '${widget.wisata.namaObjek} ditambahkan ke Favorit ❤️'
              : '${widget.wisata.namaObjek} dihapus dari Favorit',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Konten halaman yang dapat di-scroll
          _buildKontenScroll(context),

          // Tombol Kembali (sisi kiri atas)
          _buildTombolKembali(context),

          // Tombol Favorit (sisi kanan atas)
          _buildTombolFavorit(context),
        ],
      ),
      // Tombol "Hitung Tiket" menempel di bagian bawah
      bottomNavigationBar: _buildTombolHitungTiket(context),
    );
  }

  // ── KONTEN SCROLL ─────────────────────────────────────────────

  Widget _buildKontenScroll(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Gambar Hero Utama di Bagian Atas
          _buildHeroGambar(),

          // 2. Seluruh Konten Informasi di Bawah Gambar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama destinasi + Badge Kategori
                _buildNamaDanKategori(),
                const SizedBox(height: 8),

                // Lokasi dengan ikon penanda
                _buildLokasi(),
                const SizedBox(height: 10),

                // Rating bintang + jumlah ulasan
                _buildRating(),
                const SizedBox(height: 18),

                // Garis pemisah halus
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 18),

                // Seksi Deskripsi
                _buildDeskripsi(),
                const SizedBox(height: 20),

                // Seksi 3 Kartu Fitur (Jam Buka, Kuota Harian, Fasilitas)
                _buildBarisTigaFitur(),
                const SizedBox(height: 20),

                // Kartu Harga Tiket & Promo Diskon Rombongan
                _buildKartuHargaTiket(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TOMBOL FLOATING ATAS (Kembali & Favorit) ───────────────────

  Widget _buildTombolKembali(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1A2E),
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTombolFavorit(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 16,
      child: GestureDetector(
        onTap: _toggleFavorit,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            _isFavorit ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _isFavorit ? Colors.redAccent : const Color(0xFF1A1A2E),
            size: 22,
          ),
        ),
      ),
    );
  }

  // ── GAMBAR HERO ──────────────────────────────────────────────

  Widget _buildHeroGambar() {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: widget.wisata.imageUrl.startsWith('assets/')
          ? Image.asset(
              widget.wisata.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildFallbackGambar(),
            )
          : Image.network(
              widget.wisata.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildFallbackGambar(),
            ),
    );
  }

  Widget _buildFallbackGambar() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.15),
      child: const Center(
        child: Icon(Icons.landscape, color: AppColors.accent, size: 60),
      ),
    );
  }

  // ── INFORMASI UTAMA ──────────────────────────────────────────

  Widget _buildNamaDanKategori() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.wisata.namaObjek,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.4,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Badge Kategori (misal: "Air", "Alam")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.wisata.jenis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLokasi() {
    return Row(
      children: [
        const Icon(
          Icons.location_on_rounded,
          size: 16,
          color: AppColors.accent,
        ),
        const SizedBox(width: 4),
        Text(
          '${widget.wisata.lokasi}, ${widget.wisata.provinsi.isNotEmpty ? widget.wisata.provinsi : 'Indonesia'}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 18),
        const SizedBox(width: 4),
        Text(
          '${widget.wisata.rating}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '(${formatUlasan(widget.wisata.jumlahUlasan)} ulasan)',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildDeskripsi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.wisata.deskripsi.isNotEmpty
              ? widget.wisata.deskripsi
              : '${widget.wisata.namaObjek} adalah destinasi wisata pilihan yang menawarkan pemandangan menakjubkan dan fasilitas lengkap untuk liburan Anda bersama keluarga.',
          style: TextStyle(
            fontSize: 13.5,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ── 3 KARTU FITUR (Sesuai Mockup) ────────────────────────────

  Widget _buildBarisTigaFitur() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItemFitur(
            ikon: Icons.access_time_filled_rounded,
            label: 'Jam Buka',
            nilai: '08.00 - 17.00',
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade200),
          _buildItemFitur(
            ikon: Icons.groups_rounded,
            label: 'Kuota Harian',
            nilai: '${widget.wisata.kuotaHarian} orang',
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade200),
          _buildItemFitur(
            ikon: Icons.business_rounded,
            label: 'Fasilitas',
            nilai: 'Parkir, Toilet',
          ),
        ],
      ),
    );
  }

  Widget _buildItemFitur({
    required IconData ikon,
    required String label,
    required String nilai,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 14, color: AppColors.accent),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          nilai,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  // ── KARTU HARGA TIKET & PROMO ────────────────────────────────

  Widget _buildKartuHargaTiket() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBarisHarga(
            label: 'Tiket Dewasa',
            nilai: formatRupiah(widget.wisata.tiketDewasa),
          ),
          const SizedBox(height: 10),
          _buildBarisHarga(
            label: 'Tiket Anak',
            nilai: formatRupiah(widget.wisata.tiketAnak),
          ),
          const SizedBox(height: 12),
          // Banner diskon rombongan (PRD Bab 18)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.discount_rounded,
                  size: 16,
                  color: Color(0xFFF57C00),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Diskon 15% untuk rombongan minimal 20 orang!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB78103),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarisHarga({required String label, required String nilai}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
        ),
        Text(
          nilai,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  // ── TOMBOL HITUNG TIKET (STICKY BOTTOM) ───────────────────────

  Widget _buildTombolHitungTiket(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => _bukaModalHitungTiket(context),
          icon: const Icon(Icons.confirmation_number_rounded, size: 20),
          label: const Text(
            'Hitung Tiket',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  /// Membuka widget PenghitungTiket di dalam modal bottom sheet
  void _bukaModalHitungTiket(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                PenghitungTiket(
                  namaObjek: widget.wisata.namaObjek,
                  jenis: widget.wisata.jenis,
                  hargaDewasa: widget.wisata.tiketDewasa,
                  hargaAnak: widget.wisata.tiketAnak,
                  kuotaHarian: widget.wisata.kuotaHarian,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
