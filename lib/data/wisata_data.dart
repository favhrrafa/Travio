import '../models/objek_wisata.dart';

/// Mengembalikan seluruh daftar objek wisata (minimal 8 sesuai PRD).
/// Data mencakup 4 kategori: Alam, Air, Edukasi, Budaya.
List<ObjekWisata> getSemuaWisata() {
  return const [
    ObjekWisata(
      namaObjek: 'Taman Air',
      jenis: 'Air',
      tiketDewasa: 15000,
      tiketAnak: 10000,
      kuotaHarian: 200,
      lokasi: 'Bogor',
      provinsi: 'Jawa Barat',
      rating: 4.8,
      jumlahUlasan: 1200,
      deskripsi:
          'Taman Air adalah destinasi wisata keluarga yang menawarkan berbagai wahana air seru dan fasilitas lengkap. Cocok untuk liburan bersama keluarga maupun teman.',
      imageUrl: 'https://picsum.photos/seed/tamanair123/400/250',
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
      rating: 4.9,
      jumlahUlasan: 2100,
      deskripsi:
          'Kawah Ijen adalah gunung berapi aktif yang terkenal dengan fenomena api biru unik dan danau kawah berwarna tosca yang memukau. Wajib dikunjungi bagi pecinta alam.',
      imageUrl: 'https://picsum.photos/seed/kawahijen456/400/250',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Taman Safari',
      jenis: 'Edukasi',
      tiketDewasa: 75000,
      tiketAnak: 50000,
      kuotaHarian: 800,
      lokasi: 'Bogor',
      provinsi: 'Jawa Barat',
      rating: 4.7,
      jumlahUlasan: 1800,
      deskripsi:
          'Taman Safari Indonesia menawarkan pengalaman safari seru dengan berbagai satwa liar dari seluruh dunia. Tersedia wahana pendukung dan pertunjukan satwa yang menghibur.',
      imageUrl: 'https://picsum.photos/seed/tamansafari789/400/250',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Pantai Kuta',
      jenis: 'Alam',
      tiketDewasa: 12000,
      tiketAnak: 8000,
      kuotaHarian: 600,
      lokasi: 'Badung',
      provinsi: 'Bali',
      rating: 4.6,
      jumlahUlasan: 2700,
      deskripsi:
          'Pantai Kuta adalah pantai paling terkenal di Bali yang menyajikan sunset memukau, ombak yang cocok untuk surfing, serta deretan toko dan restoran di sekitarnya.',
      imageUrl: 'https://picsum.photos/seed/pantaikuta321/400/250',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Candi Borobudur',
      jenis: 'Budaya',
      tiketDewasa: 50000,
      tiketAnak: 25000,
      kuotaHarian: 500,
      lokasi: 'Magelang',
      provinsi: 'Jawa Tengah',
      rating: 4.9,
      jumlahUlasan: 3500,
      deskripsi:
          'Candi Borobudur adalah salah satu keajaiban dunia dan candi Buddha terbesar di dunia. Dibangun pada abad ke-8, candi ini menjadi warisan budaya UNESCO yang memukau.',
      imageUrl: 'https://picsum.photos/seed/borobudur654/400/250',
      isPopuler: true,
    ),
    ObjekWisata(
      namaObjek: 'Museum Angkut',
      jenis: 'Edukasi',
      tiketDewasa: 50000,
      tiketAnak: 35000,
      kuotaHarian: 500,
      lokasi: 'Batu',
      provinsi: 'Jawa Timur',
      rating: 4.6,
      jumlahUlasan: 900,
      deskripsi:
          'Museum Angkut adalah museum transportasi unik yang menampilkan koleksi berbagai jenis kendaraan dari berbagai era dan negara. Sangat cocok untuk wisata edukatif keluarga.',
      imageUrl: 'https://picsum.photos/seed/museum987/400/250',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Coban Pelangi',
      jenis: 'Alam',
      tiketDewasa: 15000,
      tiketAnak: 10000,
      kuotaHarian: 300,
      lokasi: 'Malang',
      provinsi: 'Jawa Timur',
      rating: 4.5,
      jumlahUlasan: 850,
      deskripsi:
          'Coban Pelangi adalah air terjun indah di lereng Gunung Semeru yang menciptakan pelangi alami saat sinar matahari menyinarinya. Dikelilingi hutan tropis yang asri dan segar.',
      imageUrl: 'https://picsum.photos/seed/waterfall111/400/250',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Hawai Waterpark',
      jenis: 'Air',
      tiketDewasa: 80000,
      tiketAnak: 60000,
      kuotaHarian: 1000,
      lokasi: 'Malang',
      provinsi: 'Jawa Timur',
      rating: 4.4,
      jumlahUlasan: 750,
      deskripsi:
          'Hawai Waterpark adalah taman air terbesar di Jawa Timur yang menyediakan berbagai wahana air seru untuk semua usia, mulai dari anak-anak hingga dewasa.',
      imageUrl: 'https://picsum.photos/seed/waterpark222/400/250',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Candi Singosari',
      jenis: 'Budaya',
      tiketDewasa: 10000,
      tiketAnak: 7000,
      kuotaHarian: 150,
      lokasi: 'Malang',
      provinsi: 'Jawa Timur',
      rating: 4.3,
      jumlahUlasan: 400,
      deskripsi:
          'Candi Singosari merupakan candi peninggalan Kerajaan Singosari yang dibangun sebagai penghormatan kepada Raja Kertanegara. Nilai sejarah dan arsitekturnya sangat tinggi.',
      imageUrl: 'https://picsum.photos/seed/temple333/400/250',
      isPopuler: false,
    ),
    ObjekWisata(
      namaObjek: 'Selecta',
      jenis: 'Alam',
      tiketDewasa: 40000,
      tiketAnak: 30000,
      kuotaHarian: 400,
      lokasi: 'Batu',
      provinsi: 'Jawa Timur',
      rating: 4.5,
      jumlahUlasan: 650,
      deskripsi:
          'Selecta adalah taman rekreasi tertua di Jawa Timur yang menawarkan keindahan taman bunga, kolam renang air pegunungan, dan udara segar di lereng Gunung Arjuno.',
      imageUrl: 'https://picsum.photos/seed/garden444/400/250',
      isPopuler: false,
    ),
  ];
}

/// Mengembalikan satu data sample untuk backward compatibility.
ObjekWisata getSampleWisata() {
  return getSemuaWisata().first;
}