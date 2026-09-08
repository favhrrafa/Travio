import 'package:flutter/material.dart';
import '../data/wisata_data.dart';
import '../models/objek_wisata.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';
import 'detail_screen.dart';

/// Halaman Destinasi — menampilkan katalog lengkap seluruh objek wisata.
///
/// Fitur yang tersedia sesuai PRD dan Mockup:
/// 1. Pencarian berdasarkan nama objek wisata, lokasi, dan kategori
/// 2. Filter kategori: Semua, Alam, Air, Edukasi, Budaya (dalam bentuk chip)
/// 3. Pengurutan data (Harga Naik/Turun, Kuota Naik/Turun) sesuai PRD Bab 16
/// 4. Desain responsif menggunakan LayoutBuilder:
///    - Lebar < 600 px: 1 kolom (smartphone)
///    - Lebar 600 - 899 px: 2 kolom (tablet portrait)
///    - Lebar >= 900 px: 3 kolom (tablet landscape/desktop)
/// 5. Empty State informatif jika pencarian/filter tidak menemukan hasil
/// 6. Navigasi langsung ke Halaman Detail Destinasi saat kartu ditekan
class DestinasiScreen extends StatefulWidget {
  /// Kategori awal saat halaman dibuka (opsional, default: 'Semua')
  final String? initialKategori;

  const DestinasiScreen({super.key, this.initialKategori});

  @override
  State<DestinasiScreen> createState() => _DestinasiScreenState();
}

/// Enum untuk pilihan pengurutan daftar objek wisata
enum UrutanWisata {
  hargaNaik, // Harga terendah ke tertinggi
  hargaTurun, // Harga tertinggi ke terendah
  kuotaNaik, // Kuota terkecil ke terbesar
  kuotaTurun, // Kuota terbesar ke terkecil
}

class _DestinasiScreenState extends State<DestinasiScreen> {
  // Controller untuk input teks pencarian
  final TextEditingController _searchController = TextEditingController();

  // State pencarian dan filter
  String _searchQuery = '';
  late String _kategoriTerpilih;
  UrutanWisata _urutan = UrutanWisata.hargaNaik;
  bool _isSearchVisible = false; // status apakah search bar aktif ditampilkan

  // Daftar kategori wisata sesuai PRD
  static const List<String> _daftarKategori = [
    'Semua',
    'Alam',
    'Air',
    'Edukasi',
    'Budaya',
  ];

  // Label tampilan untuk setiap opsi pengurutan
  static const Map<UrutanWisata, String> _labelUrutan = {
    UrutanWisata.hargaNaik: 'Harga Terendah → Tertinggi',
    UrutanWisata.hargaTurun: 'Harga Tertinggi → Terendah',
    UrutanWisata.kuotaNaik: 'Kuota Terkecil → Terbesar',
    UrutanWisata.kuotaTurun: 'Kuota Terbesar → Terkecil',
  };

  @override
  void initState() {
    super.initState();
    // Gunakan kategori awal jika disediakan dari halaman sebelumnya
    _kategoriTerpilih = widget.initialKategori ?? 'Semua';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── LOGIKA FILTER & SORTING ──────────────────────────────────

  /// Mengambil semua data wisata kemudian memfilter dan mengurutkannya
  List<ObjekWisata> _getDaftarWisata() {
    final semua = getSemuaWisata();
    final query = _searchQuery.toLowerCase().trim();

    // 1. Filter data berdasarkan kata kunci pencarian dan kategori
    final difilter = semua.where((w) {
      final cocokNama = query.isEmpty ||
          w.namaObjek.toLowerCase().contains(query) ||
          w.lokasi.toLowerCase().contains(query) ||
          w.jenis.toLowerCase().contains(query);

      final cocokKategori =
          _kategoriTerpilih == 'Semua' || w.jenis == _kategoriTerpilih;

      return cocokNama && cocokKategori;
    }).toList();

    // 2. Urutkan daftar yang telah difilter sesuai opsi yang dipilih
    switch (_urutan) {
      case UrutanWisata.hargaNaik:
        difilter.sort((a, b) => a.tiketDewasa.compareTo(b.tiketDewasa));
        break;
      case UrutanWisata.hargaTurun:
        difilter.sort((a, b) => b.tiketDewasa.compareTo(a.tiketDewasa));
        break;
      case UrutanWisata.kuotaNaik:
        difilter.sort((a, b) => a.kuotaHarian.compareTo(b.kuotaHarian));
        break;
      case UrutanWisata.kuotaTurun:
        difilter.sort((a, b) => b.kuotaHarian.compareTo(a.kuotaHarian));
        break;
    }

    return difilter;
  }

  // ── HANDLER EVENT ─────────────────────────────────────────────

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _clearSearch();
      }
    });
  }

  void _onKategoriDipilih(String kategori) {
    setState(() => _kategoriTerpilih = kategori);
  }

  /// Menampilkan modal bottom sheet untuk memilih metode pengurutan
  void _tampilkanPilihanUrutan() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => _buildBottomSheetUrutan(),
    );
  }

  // ── BUILD UTAMA ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final daftarWisata = _getDaftarWisata();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search bar (muncul saat ikon pencarian ditekan)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isSearchVisible
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _buildSearchBar(),
            secondChild: const SizedBox.shrink(),
          ),

          // Baris filter kategori (chip Semua, Alam, Air, Edukasi, Budaya)
          _buildBarisKategori(),

          // Konten utama: Grid Responsif atau Pesan Kosong (Empty State)
          Expanded(
            child: daftarWisata.isEmpty
                ? _buildEmptyState()
                : _buildGridResponsif(daftarWisata),
          ),
        ],
      ),
    );
  }

  // ── APPBAR (Sesuai Mockup) ───────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      // Tombol kembali di sisi kiri
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF1A1A2E),
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      // Judul halaman
      title: const Text(
        'Destinasi Wisata',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
          letterSpacing: -0.3,
        ),
      ),
      // Aksi sisi kanan: tombol sort & tombol cari
      actions: [
        // Tombol pengurutan data
        IconButton(
          icon: const Icon(Icons.tune_rounded, color: AppColors.accent, size: 22),
          tooltip: 'Urutkan Data',
          onPressed: _tampilkanPilihanUrutan,
        ),
        // Tombol pencarian (toggle search bar)
        IconButton(
          icon: Icon(
            _isSearchVisible ? Icons.close_rounded : Icons.search_rounded,
            color: const Color(0xFF1A1A2E),
            size: 24,
          ),
          tooltip: 'Cari Wisata',
          onPressed: _toggleSearchBar,
        ),
        const SizedBox(width: 6),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.grey.shade100),
      ),
    );
  }

  // ── KOTAK PENCARIAN ──────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          autofocus: true,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari destinasi wisata...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon:
                const Icon(Icons.search_rounded, color: AppColors.accent, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: Colors.grey[400], size: 18),
                    onPressed: _clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  // ── BARIS FILTER KATEGORI (CHIP) ─────────────────────────────

  Widget _buildBarisKategori() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _daftarKategori.map((kategori) {
            final isActive = _kategoriTerpilih == kategori;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _onKategoriDipilih(kategori),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isActive ? AppColors.accent : Colors.grey.shade200,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    kategori,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? Colors.white : const Color(0xFF555555),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── GRID RESPONSIF (PRD Bab 19) ──────────────────────────────

  /// Menggunakan LayoutBuilder untuk menentukan jumlah kolom:
  /// - < 600 px  → 1 kolom (Mobile)
  /// - 600-899 px → 2 kolom (Tablet)
  /// - >= 900 px  → 3 kolom (Desktop / Layar Lebar)
  Widget _buildGridResponsif(List<ObjekWisata> daftarWisata) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lebar = constraints.maxWidth;

        // Tampilan 1 kolom untuk smartphone (ListView vertikal)
        if (lebar < 600) {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            physics: const BouncingScrollPhysics(),
            itemCount: daftarWisata.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildKartuDestinasi(daftarWisata[index]);
            },
          );
        }

        // Tampilan multi-kolom untuk tablet & desktop (GridView responsif)
        final int jumlahKolom = lebar < 900 ? 2 : 3;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: jumlahKolom,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 2.7,
          ),
          itemCount: daftarWisata.length,
          itemBuilder: (context, index) {
            return _buildKartuDestinasi(daftarWisata[index]);
          },
        );
      },
    );
  }

  // ── KARTU DESTINASI (Sesuai Mockup) ──────────────────────────

  /// Tampilan kartu destinasi:
  /// [Thumbnail] [Nama, Lokasi • Jenis, Rating, Harga Dewasa] [Panah >]
  Widget _buildKartuDestinasi(ObjekWisata wisata) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(wisata: wisata),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Gambar thumbnail di sebelah kiri
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 76,
                height: 76,
                child: _buildGambarThumbnail(wisata),
              ),
            ),
            const SizedBox(width: 14),

            // Informasi objek wisata di bagian tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nama objek wisata
                  Text(
                    wisata.namaObjek,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Lokasi dan Kategori (misal: "Bogor • Air")
                  Text(
                    '${wisata.lokasi} • ${wisata.jenis}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Bintang rating dan jumlah ulasan
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFA000),
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${wisata.rating} (${formatUlasan(wisata.jumlahUlasan)})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Harga tiket dewasa
                  Text(
                    formatRupiah(wisata.tiketDewasa),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),

            // Ikon panah ke kanan di sisi kanan kartu
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFBBBBBB),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ── THUMBNAIL GAMBAR ─────────────────────────────────────────

  Widget _buildGambarThumbnail(ObjekWisata wisata) {
    if (wisata.imageUrl.startsWith('assets/')) {
      return Image.asset(
        wisata.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackGambar(),
      );
    }
    return Image.network(
      wisata.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.primary.withValues(alpha: 0.1),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildFallbackGambar(),
    );
  }

  Widget _buildFallbackGambar() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.15),
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.accent, size: 28),
      ),
    );
  }

  // ── EMPTY STATE (PRD Bab 15) ─────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 42,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Destinasi tidak ditemukan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba gunakan kata kunci lain\natau ubah kategori wisata.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _kategoriTerpilih = 'Semua';
                  _clearSearch();
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Reset Filter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── BOTTOM SHEET PENGURUTAN (PRD Bab 16) ─────────────────────

  Widget _buildBottomSheetUrutan() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Urutkan Berdasarkan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...UrutanWisata.values.map((urutan) {
              final isAktif = _urutan == urutan;
              return GestureDetector(
                onTap: () {
                  setState(() => _urutan = urutan);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isAktif
                        ? AppColors.accent.withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isAktif ? AppColors.accent : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _labelUrutan[urutan]!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isAktif ? FontWeight.w700 : FontWeight.w500,
                            color: isAktif
                                ? AppColors.accent
                                : const Color(0xFF333333),
                          ),
                        ),
                      ),
                      if (isAktif)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.accent,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
