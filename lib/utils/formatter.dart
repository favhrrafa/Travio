// Fungsi untuk memformat angka menjadi format Rupiah, misalnya:
// 15000 -> "Rp15.000"
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