import 'package:intl/intl.dart';

/// Memformat angka menjadi format Rupiah.
/// Contoh: 15000 → "Rp15.000"
String formatRupiah(num nilai) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(nilai);
}

/// Memformat jumlah ulasan menjadi singkatan yang mudah dibaca.
/// Contoh: 1200 → "1.2k"
String formatUlasan(int jumlah) {
  if (jumlah >= 1000) {
    final double nilai = jumlah / 1000;
    return '${nilai.toStringAsFixed(1)}k';
  }
  return jumlah.toString();
}