/// Model data objek wisata.
/// Wajib memiliki 5 field utama sesuai PRD:
/// [namaObjek], [jenis], [tiketDewasa], [tiketAnak], [kuotaHarian].
/// Field tambahan digunakan untuk kebutuhan tampilan UI.
class ObjekWisata {
  final String namaObjek;
  final String jenis;
  final int tiketDewasa;
  final int tiketAnak;
  final int kuotaHarian;

  // Field tambahan untuk UI (optional, memiliki nilai default)
  final String lokasi;
  final String provinsi;
  final double rating;
  final int jumlahUlasan;
  final String deskripsi;
  final String imageUrl;
  final bool isPopuler;

  const ObjekWisata({
    required this.namaObjek,
    required this.jenis,
    required this.tiketDewasa,
    required this.tiketAnak,
    required this.kuotaHarian,
    this.lokasi = '',
    this.provinsi = '',
    this.rating = 4.5,
    this.jumlahUlasan = 0,
    this.deskripsi = '',
    this.imageUrl = '',
    this.isPopuler = false,
  });
}