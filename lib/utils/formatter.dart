/// Memformat angka menjadi format Rupiah.
/// Contoh: 15000 → "Rp15.000"
String formatRupiah(int nilai) {
  String angka = nilai.toString();
  String hasil = "";
  int hitung = 0;

  for (int i = angka.length - 1; i >= 0; i--) {
    hasil = angka[i] + hasil;
    hitung++;
    if (hitung % 3 == 0 && i != 0) {
      hasil = "." + hasil;
    }
  }

  return "Rp$hasil";
}

/// Memformat jumlah ulasan menjadi singkatan yang mudah dibaca.
/// Contoh: 1200 → "1.2k", 500 → "500"
String formatUlasan(int jumlah) {
  if (jumlah >= 1000) {
    final double nilai = jumlah / 1000;
    return '${nilai.toStringAsFixed(1)}k';
  }
  return jumlah.toString();
}