import 'package:flutter/material.dart';
import '../data/wisata_data.dart';
import '../models/objek_wisata.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';

/// Halaman Beranda — halaman utama aplikasi Travio.
///
/// Menampilkan:
/// - Header sambutan
/// - Search bar
/// - Hero banner
/// - Kategori wisata (Alam, Air, Edukasi, Budaya)
/// - Daftar Destinasi Populer (horizontal scroll)
/// - Bottom Navigation Bar
class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _selectedNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  static const List<Map<String, dynamic>> _daftarKategori = [
    {'label': 'Alam', 'icon': Icons.landscape},
    {'label': 'Air', 'icon': Icons.pool},
    {'label': 'Edukasi', 'icon': Icons.school},
    {'label': 'Budaya', 'icon': Icons.account_balance},
  ];

  // ── Data helpers ─────────────────────────────────────────────

  /// Mengambil dan memfilter daftar wisata berdasarkan [_searchQuery] dan [_selectedCategory].
  List<ObjekWisata> _getDestinasPopuler() {
    final semua = getSemuaWisata();
    final query = _searchQuery.toLowerCase().trim();

    return semua.where((w) {
      final matchesQuery = query.isEmpty ||
          w.namaObjek.toLowerCase().contains(query) ||
          w.lokasi.toLowerCase().contains(query) ||
          w.jenis.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == null ||
          w.jenis.toLowerCase() == _selectedCategory!.toLowerCase();

      if (query.isNotEmpty || _selectedCategory != null) {
        return matchesQuery && matchesCategory;
      }
      return w.isPopuler && matchesQuery;
    }).toList();
  }

  void _onCategoryTap(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
  }

  // ── Event handlers ───────────────────────────────────────────

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _onNavTap(int index) {
    if (index == _selectedNavIndex) return;
    if (index != 0) {
      _showComingSoonSnackbar();
      return;
    }
    setState(() => _selectedNavIndex = index);
  }

  void _showComingSoonSnackbar([String? pesan]) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan ?? 'Fitur ini akan segera hadir 🚀'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final populer = _getDestinasPopuler();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 4),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildHeroBanner(),
              _buildKategori(),
              _buildSeksiDestinasPopuler(populer),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SECTION: Header
  // ════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildHeaderTeks()),
          const SizedBox(width: 12),
          _buildAvatarButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderTeks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat datang,',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        const SizedBox(height: 2),
        const Text(
          'Jelajahi Indonesia',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Temukan destinasi terbaik untuk perjalananmu.',
          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildAvatarButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.14),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.person, color: AppColors.accent, size: 24),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SECTION: Search Bar
  // ════════════════════════════════════════════════════════════

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari destinasi wisata...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[400], size: 18),
                    onPressed: _clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SECTION: Hero Banner
  // ════════════════════════════════════════════════════════════

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 188,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildBannerGambar(),
              _buildBannerOverlay(),
              _buildBannerKonten(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerGambar() {
    return Image.asset(
      'assets/nature/Gunung Bromo.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, _) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildBannerOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
          stops: const [0.25, 1.0],
        ),
      ),
    );
  }

  Widget _buildBannerKonten() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Pesona Alam\ndi Setiap Langkah',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.3,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          _buildJelajahiButton(),
        ],
      ),
    );
  }

  Widget _buildJelajahiButton() {
    return ElevatedButton(
      onPressed: _showComingSoonSnackbar,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.accent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Jelajahi Sekarang',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: 14),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SECTION: Kategori
  // ════════════════════════════════════════════════════════════

  Widget _buildKategori() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _daftarKategori
            .map((k) => _buildItemKategori(k))
            .toList(),
      ),
    );
  }

  Widget _buildItemKategori(Map<String, dynamic> kategori) {
    final isSelected = _selectedCategory == kategori['label'];
    return GestureDetector(
      onTap: () => _onCategoryTap(kategori['label'] as String),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.accent.withOpacity(0.35)
                      : AppColors.primary.withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              kategori['icon'] as IconData,
              color: isSelected ? Colors.white : AppColors.accent,
              size: 34,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kategori['label'] as String,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? AppColors.accent : const Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SECTION: Destinasi Populer
  // ════════════════════════════════════════════════════════════

  Widget _buildSeksiDestinasPopuler(List<ObjekWisata> populer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSeksi(),
        const SizedBox(height: 14),
        populer.isEmpty ? _buildEmptyState() : _buildListPopuler(populer),
      ],
    );
  }

  Widget _buildHeaderSeksi() {
    final title = _selectedCategory != null
        ? 'Wisata ${_selectedCategory!}'
        : (_searchQuery.isNotEmpty ? 'Hasil Pencarian' : 'Destinasi Populer');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          if (_selectedCategory != null)
            GestureDetector(
              onTap: () => setState(() => _selectedCategory = null),
              child: const Text(
                'Tampilkan Semua',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _showComingSoonSnackbar,
              child: const Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 11,
                    color: AppColors.accent,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListPopuler(List<ObjekWisata> populer) {
    return SizedBox(
      height: 232,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: populer.length,
        itemBuilder: (context, index) => _buildKartuPopuler(populer[index]),
      ),
    );
  }

  Widget _buildKartuPopuler(ObjekWisata wisata) {
    return GestureDetector(
      onTap: _showComingSoonSnackbar,
      child: Container(
        width: 174,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKartuGambar(wisata),
            Expanded(child: _buildKartuInfo(wisata)),
          ],
        ),
      ),
    );
  }

  Widget _buildKartuGambar(ObjekWisata wisata) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: Stack(
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: _buildGambarWisata(wisata.imageUrl),
          ),
          // Badge jenis wisata
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                wisata.jenis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGambarWisata(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.primary.withOpacity(0.15),
          child: const Center(
            child: Icon(Icons.landscape, color: AppColors.primary, size: 40),
          ),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.primary.withOpacity(0.12),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      },
      errorBuilder: (context, error, _) => Container(
        color: AppColors.primary.withOpacity(0.15),
        child: const Center(
          child: Icon(Icons.landscape, color: AppColors.primary, size: 40),
        ),
      ),
    );
  }

  Widget _buildKartuInfo(ObjekWisata wisata) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 8, 11, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            wisata.namaObjek,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Icon(Icons.location_on, size: 12, color: Colors.grey[400]),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  '${wisata.lokasi} • ${wisata.jenis}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 15),
              const SizedBox(width: 2),
              Text(
                '${wisata.rating}',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                '(${formatUlasan(wisata.jumlahUlasan)})',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatRupiah(wisata.tiketDewasa),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
              Text(
                '/tiket',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 52, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'Destinasi tidak ditemukan',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Coba gunakan kata kunci lain\natau ubah kategori wisata.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SECTION: Bottom Navigation Bar
  // ════════════════════════════════════════════════════════════

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Destinasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            activeIcon: Icon(Icons.confirmation_number),
            label: 'Tiket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
