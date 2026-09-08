import '../models/objek_wisata.dart';

/// Mengembalikan seluruh daftar objek wisata (16 destinasi, 4 destinasi per kategori).
/// Data mencakup 4 kategori: Alam, Air, Edukasi, Budaya.
/// Menggunakan aset lokal resmi yang telah dikelompokkan dalam folder assets.
List<ObjekWisata> getSemuaWisata() {
  return const [
    // ══════════════════════════════════════════════════════════
    // KATEGORI: ALAM (assets/nature/)
    // ══════════════════════════════════════════════════════════
    ObjekWisata(
      namaObjek: 'Gunung Bromo',
      jenis: 'Alam',
      tiketDewasa: 35000,
      tiketAnak: 25000,
      kuotaHarian: 500,
      lokasi: 'Probolinggo',
      provinsi: 'Jawa Timur',
      rating: 4.9,
      jumlahUlasan: 3200,
      deskripsi:
          'Gunung Bromo menyajikan panorama kaldera pasir yang megah dengan pemandangan matahari terbit spektakuler dari Puncak Penanjakan.',
      imageUrl: 'assets/nature/Gunung Bromo.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Kawah Ijen',
      jenis: 'Alam',
      tiketDewasa: 20000,
      tiketAnak: 12000,
      kuotaHarian: 300,
      lokasi: 'Banyuwangi',
      provinsi: 'Jawa Timur',
      rating: 4.8,
      jumlahUlasan: 2100,
      deskripsi:
          'Kawah Ijen terkenal dengan fenomena api biru (blue fire) langka di dunia dan danau kawah asam berwarna toska yang mempesona.',
      imageUrl: 'assets/nature/Kawah Ijen.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Pantai Kuta',
      jenis: 'Alam',
      tiketDewasa: 15000,
      tiketAnak: 10000,
      kuotaHarian: 800,
      lokasi: 'Badung',
      provinsi: 'Bali',
      rating: 4.7,
      jumlahUlasan: 2800,
      deskripsi:
          'Pantai Kuta adalah ikon pariwisata Bali dengan hamparan pasir putih luas, deburan ombak berselancar, dan panorama matahari terbenam legendaris.',
      imageUrl: 'assets/nature/Pantai Kuta.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Pulau Komodo',
      jenis: 'Alam',
      tiketDewasa: 150000,
      tiketAnak: 75000,
      kuotaHarian: 250,
      lokasi: 'Manggarai Barat',
      provinsi: 'Nusa Tenggara Timur',
      rating: 4.9,
      jumlahUlasan: 1750,
      deskripsi:
          'Habitat asli kadal purba terbesar di dunia, Komodo Dragon, yang dikelilingi perbukitan savana eksotis dan perairan kristal nan jernih.',
      imageUrl: 'assets/nature/Pulau Komodo.jpg',
      isPopuler: true,
    ),

    // ══════════════════════════════════════════════════════════
    // KATEGORI: AIR (assets/water/)
    // ══════════════════════════════════════════════════════════
    ObjekWisata(
      namaObjek: 'Hawai Malang',
      jenis: 'Air',
      tiketDewasa: 85000,
      tiketAnak: 65000,
      kuotaHarian: 1000,
      lokasi: 'Malang',
      provinsi: 'Jawa Timur',
      rating: 4.6,
      jumlahUlasan: 1450,
      deskripsi:
          'Taman rekreasi air bertema Hawaii dengan berbagai seluncuran ekstrem, kolam arus bertema, dan kolam ombak tsunami terbesar di Jawa Timur.',
      imageUrl: 'assets/water/Hawai Malang.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Jakarta Aquarium & Safari',
      jenis: 'Air',
      tiketDewasa: 115000,
      tiketAnak: 85000,
      kuotaHarian: 700,
      lokasi: 'Jakarta Barat',
      provinsi: 'DKI Jakarta',
      rating: 4.8,
      jumlahUlasan: 3100,
      deskripsi:
          'Akuarium indoor megah di dalam pusat perbelanjaan yang menghadirkan ribuan satwa akuatik dan non-akuatik unik dengan pengalaman interaktif dan edukatif.',
      imageUrl: 'assets/water/Jakarta Aquarium & Safari.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Jogja Bay Waterpark',
      jenis: 'Air',
      tiketDewasa: 60000,
      tiketAnak: 45000,
      kuotaHarian: 850,
      lokasi: 'Sleman',
      provinsi: 'DI Yogyakarta',
      rating: 4.6,
      jumlahUlasan: 1200,
      deskripsi:
          'Waterpark tematik bajak laut dengan ragam wahana air interaktif yang seru, menantang, dan menyegarkan untuk seluruh anggota keluarga.',
      imageUrl: 'assets/water/Jogja Bay Waterpark.jpg',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Waterbom Bali',
      jenis: 'Air',
      tiketDewasa: 195000,
      tiketAnak: 145000,
      kuotaHarian: 900,
      lokasi: 'Kuta',
      provinsi: 'Bali',
      rating: 4.9,
      jumlahUlasan: 4200,
      deskripsi:
          'Taman rekreasi air kelas dunia di jantung Kuta yang dikelilingi taman tropis rimbun dengan seluncuran bersertifikat keamanan internasional.',
      imageUrl: 'assets/water/Waterboom Bali.jpg',
      isPopuler: true,
    ),

    // ══════════════════════════════════════════════════════════
    // KATEGORI: EDUKASI (assets/education/)
    // ══════════════════════════════════════════════════════════
    ObjekWisata(
      namaObjek: 'Jatim Park 1',
      jenis: 'Edukasi',
      tiketDewasa: 100000,
      tiketAnak: 80000,
      kuotaHarian: 800,
      lokasi: 'Batu',
      provinsi: 'Jawa Timur',
      rating: 4.7,
      jumlahUlasan: 2600,
      deskripsi:
          'Destinasi wisata edukasi dan rekreasi terpadu dengan wahana sains, galeri etnik nusantara, dan puluhan wahana permainan atraktif.',
      imageUrl: 'assets/education/Jatim Park 1.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Museum Angkut',
      jenis: 'Edukasi',
      tiketDewasa: 110000,
      tiketAnak: 85000,
      kuotaHarian: 750,
      lokasi: 'Batu',
      provinsi: 'Jawa Timur',
      rating: 4.8,
      jumlahUlasan: 3400,
      deskripsi:
          'Museum transportasi pertama di Asia Tenggara dengan koleksi ratusan jenis angkutan bersejarah berlatar zona kota-kota dunia yang menawan.',
      imageUrl: 'assets/education/Museum Angkut.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Sea World Ancol',
      jenis: 'Edukasi',
      tiketDewasa: 85000,
      tiketAnak: 70000,
      kuotaHarian: 900,
      lokasi: 'Jakarta Utara',
      provinsi: 'DKI Jakarta',
      rating: 4.6,
      jumlahUlasan: 2900,
      deskripsi:
          'Wahana akuarium raksasa yang menyajikan edukasi biota laut nusantara melalui terowongan bawah air Antasena dan sesi feeding show atraktif.',
      imageUrl: 'assets/education/Sea World Ancol.jpg',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Taman Safari Indonesia',
      jenis: 'Edukasi',
      tiketDewasa: 150000,
      tiketAnak: 100000,
      kuotaHarian: 1200,
      lokasi: 'Bogor',
      provinsi: 'Jawa Barat',
      rating: 4.8,
      jumlahUlasan: 4500,
      deskripsi:
          'Konservasi satwa liar berwawasan lingkungan tempat pengunjung dapat berinteraksi langsung dengan aneka satwa langka dari berbagai belahan dunia.',
      imageUrl: 'assets/education/Taman Safari.jpg',
      isPopuler: true,
    ),

    // ══════════════════════════════════════════════════════════
    // KATEGORI: BUDAYA (assets/culture/)
    // ══════════════════════════════════════════════════════════
    ObjekWisata(
      namaObjek: 'Candi Borobudur',
      jenis: 'Budaya',
      tiketDewasa: 50000,
      tiketAnak: 25000,
      kuotaHarian: 600,
      lokasi: 'Magelang',
      provinsi: 'Jawa Tengah',
      rating: 4.9,
      jumlahUlasan: 5100,
      deskripsi:
          'Candi Buddha terbesar di dunia peninggalan Dinasti Syailendra abad ke-8 yang diakui sebagai warisan budaya mahakarya dunia oleh UNESCO.',
      imageUrl: 'assets/culture/Borobudur.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Desa Penglipuran',
      jenis: 'Budaya',
      tiketDewasa: 25000,
      tiketAnak: 15000,
      kuotaHarian: 400,
      lokasi: 'Bangli',
      provinsi: 'Bali',
      rating: 4.8,
      jumlahUlasan: 1900,
      deskripsi:
          'Salah satu desa terbersih di dunia yang mempertahankan keaslian arsitektur bambu tradisional Bali, tata ruang Tri Mandala, dan adat istiadat leluhur.',
      imageUrl: 'assets/culture/Desa panglipuran.jpg',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Wae Rebo NTT',
      jenis: 'Budaya',
      tiketDewasa: 75000,
      tiketAnak: 45000,
      kuotaHarian: 150,
      lokasi: 'Manggarai',
      provinsi: 'Nusa Tenggara Timur',
      rating: 4.9,
      jumlahUlasan: 1100,
      deskripsi:
          'Desa adat di atas awan dengan rumah kerucut tradisional Mbaru Niang yang berdiri anggun di tengah perbukitan hijau terpencil Manggarai.',
      imageUrl: 'assets/culture/Wae Rebo, NTT.jpg',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Tari Kecak Uluwatu',
      jenis: 'Budaya',
      tiketDewasa: 150000,
      tiketAnak: 100000,
      kuotaHarian: 500,
      lokasi: 'Badung',
      provinsi: 'Bali',
      rating: 4.8,
      jumlahUlasan: 3800,
      deskripsi:
          'Pertunjukan seni drama tari tradisional Bali berlatar panorama tebing karang laut Samudra Hindia dan matahari terbenam magis di Pura Uluwatu.',
      imageUrl: 'assets/culture/tari kecak.jpg',
      isPopuler: true,
    ),
  ];
}

/// Mengembalikan satu data sample untuk backward compatibility.
ObjekWisata getSampleWisata() {
  return getSemuaWisata().first;
}