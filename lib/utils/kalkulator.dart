// Menghitung total harga tiket berdasarkan jumlah pengunjung dan harga per kategori.
int hitungTotalTiket(int jumlahDewasa, int jumlahAnak, int hargaDewasa, int hargaAnak) {
  return (jumlahDewasa * hargaDewasa) + (jumlahAnak * hargaAnak);
}