/// Menghitung jumlah total pengunjung (dewasa + anak).
int hitungJumlahPengunjung(int jumlahDewasa, int jumlahAnak) {
  return jumlahDewasa + jumlahAnak;
}

/// Menghitung subtotal tiket sebelum diskon.
/// Rumus: (dewasa × tiketDewasa) + (anak × tiketAnak)
int hitungSubtotal(
  int jumlahDewasa,
  int jumlahAnak,
  int tiketDewasa,
  int tiketAnak,
) {
  return (jumlahDewasa * tiketDewasa) + (jumlahAnak * tiketAnak);
}

/// Menghitung diskon rombongan (15% jika jumlah pengunjung >= 20 orang).
/// Mengembalikan nilai diskon dalam Rupiah (int).
int hitungDiskon(int subtotal, int jumlahPengunjung) {
  if (jumlahPengunjung >= 20) {
    return (subtotal * 0.15).round();
  }
  return 0;
}

/// Menghitung total akhir setelah dikurangi diskon.
int hitungTotalAkhir(int subtotal, int diskon) {
  return subtotal - diskon;
}

/// Mengecek apakah jumlah pengunjung masih dalam batas kuota harian.
/// Mengembalikan [true] jika masih dalam batas, [false] jika sudah penuh.
bool cekKuota(int jumlahPengunjung, int kuotaHarian) {
  return jumlahPengunjung <= kuotaHarian;
}

/// Legacy — dipertahankan agar tidak merusak [PenghitungTiket] yang sudah ada.
/// Sama dengan [hitungSubtotal].
int hitungTotalTiket(
  int jumlahDewasa,
  int jumlahAnak,
  int hargaDewasa,
  int hargaAnak,
) {
  return hitungSubtotal(jumlahDewasa, jumlahAnak, hargaDewasa, hargaAnak);
}