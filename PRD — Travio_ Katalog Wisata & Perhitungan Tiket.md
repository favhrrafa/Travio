# PRODUCT REQUIREMENTS DOCUMENT (PRD)

## TRAVIO
### Katalog Wisata & Perhitungan Tiket

**Platform:** Mobile / Responsive Flutter App  
**Framework:** Flutter  
**Bahasa:** Dart  
**Konsep:** Katalog objek wisata dan perhitungan biaya tiket berdasarkan jumlah pengunjung.

---

# 1. Gambaran Umum

**Travio** adalah aplikasi katalog wisata yang memungkinkan pengguna melihat daftar objek wisata, mencari dan menyaring destinasi berdasarkan kategori, mengurutkan objek wisata berdasarkan harga tiket atau kuota harian, serta melihat rincian dan menghitung total biaya tiket.

Aplikasi dirancang menggunakan **Flutter** dengan pendekatan **mobile-first** dan harus dapat menyesuaikan tampilan berdasarkan lebar layar.

Fokus utama aplikasi:

- Menampilkan katalog objek wisata.
- Menampilkan informasi harga tiket dewasa dan anak.
- Menampilkan kuota harian setiap objek wisata.
- Mencari objek wisata.
- Menyaring berdasarkan kategori.
- Mengurutkan berdasarkan harga atau kuota.
- Melihat halaman rincian objek wisata.
- Menghitung total biaya tiket.
- Menerapkan diskon rombongan.
- Membatasi jumlah pengunjung berdasarkan kuota harian.

---

# 2. Tujuan Aplikasi

Travio dibuat untuk memberikan pengalaman sederhana bagi pengguna dalam:

1. Menemukan objek wisata.
2. Membandingkan harga tiket antar objek wisata.
3. Mengetahui kuota harian suatu objek wisata.
4. Menghitung estimasi biaya kunjungan.
5. Mengetahui apakah jumlah rombongan masih berada dalam batas kuota.
6. Mendapatkan potongan harga untuk rombongan besar.

---

# 3. Teknologi

## Teknologi Utama

- **Dart**
- **Flutter**
- **Material Design / Material 3**

## Package Tambahan

Jika diperlukan:

- `google_fonts` — typography.
- `intl` — format harga Rupiah.

Tidak menggunakan package eksternal lain kecuali memang diperlukan.

---

# 4. Struktur Data

Setiap objek wisata minimal memiliki 5 atribut berikut:

| Field | Tipe | Contoh |
|---|---|---|
| `namaObjek` | `String` | `"Taman Air"` |
| `jenis` | `String` | `"Air"` |
| `tiketDewasa` | `int` | `15000` |
| `tiketAnak` | `int` | `10000` |
| `kuotaHarian` | `int` | `200` |

Model data dapat menggunakan class:

```dart
class ObjekWisata {
  String namaObjek;
  String jenis;
  int tiketDewasa;
  int tiketAnak;
  int kuotaHarian;

  ObjekWisata({
    required this.namaObjek,
    required this.jenis,
    required this.tiketDewasa,
    required this.tiketAnak,
    required this.kuotaHarian,
  });
}
```

---

# 5. Data Minimal

Aplikasi wajib memiliki **minimal 8 objek wisata**.

Data harus memiliki variasi:

- Nama objek wisata.
- Kategori wisata.
- Harga tiket dewasa.
- Harga tiket anak.
- Kuota harian.

Kategori minimal dapat mencakup:

- Alam
- Air
- Edukasi
- Budaya

Contoh data:

| No | Nama | Jenis | Dewasa | Anak | Kuota |
|---:|---|---|---:|---:|---:|
| 1 | Taman Air | Air | Rp15.000 | Rp10.000 | 200 |
| 2 | Coban Pelangi | Alam | Rp12.000 | Rp8.000 | 300 |
| 3 | Museum Angkut | Edukasi | Rp50.000 | Rp35.000 | 500 |
| 4 | Jatim Park | Edukasi | Rp75.000 | Rp50.000 | 800 |
| 5 | Pantai Balekambang | Alam | Rp20.000 | Rp15.000 | 600 |
| 6 | Candi Singosari | Budaya | Rp10.000 | Rp7.000 | 150 |
| 7 | Selecta | Alam | Rp40.000 | Rp30.000 | 400 |
| 8 | Hawai Waterpark | Air | Rp80.000 | Rp60.000 | 1000 |

Nilai tersebut merupakan **contoh data awal** dan dapat diganti selama memenuhi struktur data yang ditentukan.

---

# 6. Aturan Perhitungan Tiket

## 6.1 Total Tiket

Total tiket dihitung berdasarkan jumlah pengunjung dewasa dan anak.

Rumus:

```text
Total Dewasa =
jumlah dewasa × tiket dewasa

Total Anak =
jumlah anak × tiket anak

Subtotal =
Total Dewasa + Total Anak
```

Contoh:

```text
2 dewasa × Rp15.000 = Rp30.000
1 anak × Rp10.000   = Rp10.000

Subtotal = Rp40.000
```

---

# 7. Diskon Rombongan

Jika jumlah seluruh pengunjung **20 orang atau lebih**, pengguna mendapatkan potongan sebesar **15% dari total tiket**.

Rumus:

```text
jumlah pengunjung =
dewasa + anak
```

Jika:

```text
jumlah pengunjung >= 20
```

maka:

```text
diskon = subtotal × 15%
total akhir = subtotal - diskon
```

Jika jumlah pengunjung kurang dari 20:

```text
diskon = Rp0
total akhir = subtotal
```

### Contoh

20 orang dengan total tiket:

```text
Rp300.000
```

Diskon:

```text
15% × Rp300.000
= Rp45.000
```

Total:

```text
Rp255.000
```

---

# 8. Aturan Kuota

Jumlah pengunjung tidak boleh melebihi `kuotaHarian` objek wisata.

Rumus:

```text
jumlah pengunjung =
jumlah dewasa + jumlah anak
```

Validasi:

```text
jumlah pengunjung <= kuotaHarian
```

Jika jumlah pengunjung sudah mencapai kuota:

- Tombol penambahan tidak boleh menambah jumlah.
- Tampilkan peringatan kepada pengguna.
- Jumlah pengunjung tidak boleh melebihi kuota.

Contoh:

```text
Kuota harian: 200
Jumlah saat ini: 200
```

Ketika pengguna menekan tombol `+`:

```text
Peringatan:
"Jumlah pengunjung sudah mencapai kuota harian."
```

Nilai tetap:

```text
200
```

---

# 9. Komponen Stateful

Halaman perhitungan tiket harus menggunakan komponen stateful karena jumlah pengunjung berubah berdasarkan interaksi pengguna.

Wajib memiliki **dua penghitung yang terpisah**:

### Penghitung Dewasa

```text
[-]  2  [+]
```

### Penghitung Anak

```text
[-]  1  [+]
```

Keduanya harus memiliki state yang berbeda.

Contoh:

```dart
int jumlahDewasa = 0;
int jumlahAnak = 0;
```

Perubahan salah satu penghitung harus memperbarui total biaya secara otomatis.

---

# 10. Total Biaya

Total biaya harus ditampilkan di dalam sebuah **Card**.

Contoh:

```text
┌─────────────────────────────┐
│ Total Biaya                 │
│                             │
│ Rp40.000                    │
│                             │
│ 1 Dewasa • 2 Anak           │
└─────────────────────────────┘
```

Card harus berubah secara realtime ketika:

- Jumlah dewasa bertambah.
- Jumlah dewasa berkurang.
- Jumlah anak bertambah.
- Jumlah anak berkurang.
- Diskon rombongan aktif.
- Diskon rombongan tidak aktif.

---

# 11. Fungsi Logika

Setiap aturan atau proses harus dibuat sebagai **fungsi tersendiri**.

Jangan menumpuk seluruh logika di dalam `build()`.

Minimal fungsi yang diperlukan:

```dart
int hitungJumlahPengunjung(...)
```

```dart
int hitungSubtotal(...)
```

```dart
double hitungDiskon(...)
```

```dart
double hitungTotalAkhir(...)
```

```dart
bool cekKuota(...)
```

```dart
String formatRupiah(...)
```

Fungsi dapat dikembangkan sesuai kebutuhan implementasi.

`build()` hanya bertugas membangun dan menampilkan UI.

---

# 12. Katalog Wisata

Halaman utama menampilkan daftar objek wisata dalam bentuk card.

Setiap card minimal menampilkan:

- Nama objek wisata.
- Kategori.
- Harga tiket dewasa.
- Harga tiket anak.
- Kuota harian.
- Tombol atau aksi untuk melihat rincian.

Contoh:

```text
┌─────────────────────────────┐
│ [ Gambar Wisata ]           │
│                             │
│ Taman Air                   │
│ Air                         │
│                             │
│ Dewasa       Rp15.000       │
│ Anak         Rp10.000       │
│ Kuota        200 orang      │
│                             │
│ Lihat Rincian →             │
└─────────────────────────────┘
```

---

# 13. Pencarian

Aplikasi memiliki **kotak pencarian** untuk mencari objek wisata berdasarkan nama.

Contoh:

```text
🔍 Cari destinasi wisata...
```

Pencarian harus bekerja bersama dengan filter kategori.

Jika pengguna mengetik:

```text
Taman
```

maka daftar hanya menampilkan objek wisata yang sesuai dengan pencarian.

---

# 14. Filter Kategori

Filter kategori harus berada **berdampingan dengan kotak pencarian** pada layout yang memungkinkan.

Kategori dapat berupa:

```text
[Semua] [Alam] [Air] [Edukasi] [Budaya]
```

Filter harus bekerja bersama pencarian.

Contoh:

```text
Pencarian: "Taman"
Kategori: "Air"
```

Maka hasil hanya menampilkan objek wisata yang:

1. Sesuai dengan kata pencarian.
2. Memiliki kategori Air.

---

# 15. Empty State

Jika hasil pencarian atau filter kosong, jangan hanya menampilkan layar kosong.

Tampilkan **empty state informatif** yang terdiri dari:

- Ikon.
- Judul/pesan.
- Kalimat yang membantu pengguna.

Contoh:

```text
        🔍

Destinasi tidak ditemukan

Coba gunakan kata kunci lain
atau ubah kategori wisata.
```

Empty state harus tampil ketika:

- Pencarian tidak menemukan hasil.
- Filter kategori tidak menemukan hasil.
- Kombinasi pencarian + kategori tidak menemukan hasil.

---

# 16. Pengurutan Data

Aplikasi memiliki tombol untuk mengurutkan daftar objek wisata.

Minimal tersedia dua parameter pengurutan:

### A. Harga Tiket

Urut berdasarkan harga tiket dewasa:

```text
Harga Terendah → Tertinggi
Harga Tertinggi → Terendah
```

### B. Kuota Harian

Urut berdasarkan:

```text
Kuota Terkecil → Terbesar
Kuota Terbesar → Terkecil
```

Contoh UI:

```text
Urutkan:

[ Harga ↑ ]
[ Harga ↓ ]
[ Kuota ↑ ]
[ Kuota ↓ ]
```

Pengurutan harus memperbarui daftar tanpa menghilangkan fungsi pencarian dan filter kategori.

---

# 17. Halaman Rincian

Setiap objek wisata memiliki halaman rincian tersendiri.

Halaman rincian minimal menampilkan:

- Nama objek wisata.
- Kategori.
- Harga tiket dewasa.
- Harga tiket anak.
- Kuota harian.
- Informasi wisata.
- Tombol untuk menghitung tiket.

Contoh struktur:

```text
┌─────────────────────────────┐
│ ← Detail Wisata             │
├─────────────────────────────┤
│                             │
│       [ Gambar ]            │
│                             │
│ Taman Air                   │
│ Air                         │
│                             │
│ Tiket Dewasa   Rp15.000     │
│ Tiket Anak     Rp10.000     │
│ Kuota Harian   200 orang    │
│                             │
│ [ Hitung Tiket ]            │
└─────────────────────────────┘
```

---

# 18. Halaman Perhitungan Tiket

Halaman ini digunakan untuk menghitung total harga tiket.

Komponen wajib:

### Informasi objek wisata

Menampilkan:

- Nama.
- Jenis.
- Harga tiket.
- Kuota.

### Counter Dewasa

```text
Dewasa

[-]     2     [+]
```

### Counter Anak

```text
Anak

[-]     1     [+]
```

### Ringkasan

Menampilkan:

```text
Dewasa       2 × Rp15.000
Anak         1 × Rp10.000

Subtotal     Rp40.000
Diskon       Rp0

Total        Rp40.000
```

Jika jumlah mencapai 20:

```text
Subtotal     Rp300.000
Diskon 15%   -Rp45.000

Total        Rp255.000
```

---

# 19. Responsive Design

Aplikasi harus menggunakan pendekatan responsive layout.

Gunakan `LayoutBuilder` untuk menentukan jumlah kolom berdasarkan lebar layar.

### Lebar < 600 px

Gunakan:

```text
1 kolom
```

Cocok untuk:

- Smartphone portrait.
- Tampilan mobile utama.

### Lebar 600–899 px

Gunakan:

```text
2 kolom
```

Cocok untuk:

- Tablet portrait.
- Smartphone dengan layar besar/landscape.

### Lebar >= 900 px

Gunakan:

```text
3 kolom
```

Cocok untuk:

- Tablet landscape.
- Layar yang lebih lebar.

Logika:

```text
width < 600
    → 1 column

600 <= width < 900
    → 2 columns

width >= 900
    → 3 columns
```

---

# 20. Struktur Layout Flutter

Implementasi UI harus memanfaatkan widget Flutter yang relevan.

Struktur dasar halaman:

```text
Scaffold
│
├── AppBar
│
└── body
    │
    └── LayoutBuilder
        │
        └── ...
            │
            └── GridView
```

Widget yang dapat digunakan:

- `Scaffold`
- `AppBar`
- `body`
- `Expanded`
- `LayoutBuilder`
- `GridView`
- `Card`
- `Column`
- `Row`
- `Container`
- `Padding`
- `Text`
- `TextField`
- `Icon`
- `IconButton`
- `ElevatedButton`
- `ChoiceChip` / `FilterChip`
- `ListView`
- `SingleChildScrollView`

Gunakan widget sesuai kebutuhan dan hindari widget yang tidak diperlukan.

---

# 21. Prinsip Mobile First

Desain utama harus dibuat untuk layar smartphone terlebih dahulu.

Prioritas:

1. Smartphone.
2. Tablet.
3. Layar lebih lebar.

Pada smartphone:

- Konten menggunakan 1 kolom.
- Informasi tidak terlalu padat.
- Tombol mudah ditekan.
- Counter dewasa dan anak mudah digunakan.
- Card memiliki spacing yang nyaman.
- Navigasi mudah dijangkau.

---

# 22. Design Direction

Travio menggunakan gaya visual:

**Modern + Soft + Cheerful + Clean**

Warna utama:

- Soft blue.
- White.
- Light blue sebagai aksen.

Hindari:

- Navy yang terlalu gelap.
- Biru klasik/old-school.
- Terlalu banyak warna.
- Gradient berlebihan.
- Shadow yang terlalu kuat.
- UI yang terlalu padat.

Gunakan:

- Rounded corners.
- Soft shadow.
- Banyak white space.
- Typography modern.
- Icon sederhana.
- Card yang bersih.

Logo Travio digunakan sebagai identitas utama aplikasi.

Tagline:

> **Explore More, Pay Smarter.**

---

# 23. Aturan Coding

### Wajib

Setiap aturan atau proses harus dibuat sebagai **fungsi tersendiri**.

Contoh:

```dart
int hitungJumlahPengunjung(
  int jumlahDewasa,
  int jumlahAnak,
) {
  return jumlahDewasa + jumlahAnak;
}
```

Contoh:

```dart
bool cekKuota(
  int jumlahPengunjung,
  int kuotaHarian,
) {
  return jumlahPengunjung <= kuotaHarian;
}
```

Contoh:

```dart
int hitungSubtotal(
  int jumlahDewasa,
  int jumlahAnak,
  int tiketDewasa,
  int tiketAnak,
) {
  return (jumlahDewasa * tiketDewasa) +
      (jumlahAnak * tiketAnak);
}
```

Jangan melakukan seluruh perhitungan secara langsung di:

```dart
build()
```

atau:

```dart
setState()
```

`setState()` hanya digunakan untuk memperbarui state setelah terjadi perubahan.

---

# 24. State Management

Untuk project ini belum diperlukan state management eksternal seperti:

- Provider
- Riverpod
- Bloc
- GetX

Gunakan state management bawaan Flutter:

```dart
StatefulWidget
```

dan:

```dart
setState()
```

khususnya untuk counter jumlah dewasa dan anak.

---

# 25. Kriteria Keberhasilan

Project dianggap memenuhi requirement apabila:

### Data

- [ ] Terdapat minimal 8 objek wisata.
- [ ] Setiap objek memiliki 5 data minimal.
- [ ] Data memiliki variasi kategori.

### Katalog

- [ ] Daftar objek wisata ditampilkan.
- [ ] Informasi harga dewasa ditampilkan.
- [ ] Informasi harga anak ditampilkan.
- [ ] Kuota harian ditampilkan.

### Pencarian & Filter

- [ ] Terdapat kotak pencarian.
- [ ] Terdapat filter kategori.
- [ ] Pencarian dan filter dapat digunakan bersamaan.
- [ ] Empty state muncul ketika hasil kosong.
- [ ] Empty state memiliki ikon dan pesan informatif.

### Sorting

- [ ] Dapat mengurutkan berdasarkan harga.
- [ ] Harga dapat ascending.
- [ ] Harga dapat descending.
- [ ] Dapat mengurutkan berdasarkan kuota.
- [ ] Kuota dapat ascending.
- [ ] Kuota dapat descending.

### Perhitungan

- [ ] Counter dewasa tersedia.
- [ ] Counter anak tersedia.
- [ ] Kedua counter memiliki state terpisah.
- [ ] Total berubah ketika counter berubah.
- [ ] Total ditampilkan dalam Card.
- [ ] Tarif dewasa dan anak berbeda.
- [ ] Diskon 15% diterapkan untuk minimal 20 orang.
- [ ] Jumlah pengunjung tidak dapat melebihi kuota.
- [ ] Peringatan muncul ketika kuota tercapai.

### Detail

- [ ] Terdapat halaman rincian objek wisata.
- [ ] Detail menampilkan informasi objek wisata.
- [ ] Terdapat akses menuju perhitungan tiket.

### Responsive

- [ ] Lebar <600 px → 1 kolom.
- [ ] Lebar 600–899 px → 2 kolom.
- [ ] Lebar >=900 px → 3 kolom.
- [ ] Implementasi menggunakan `LayoutBuilder`.
- [ ] Katalog menggunakan `GridView` atau layout grid yang setara.

### Struktur Flutter

- [ ] Menggunakan `Scaffold`.
- [ ] Menggunakan `AppBar`.
- [ ] Menggunakan `body`.
- [ ] Menggunakan `Expanded` ketika diperlukan.
- [ ] Menggunakan `LayoutBuilder`.
- [ ] Menggunakan `GridView`.
- [ ] Logika bisnis dipisahkan ke fungsi.
- [ ] Tidak menumpuk perhitungan di dalam `build()`.

---

# 26. Batasan Pengembangan

Untuk tahap ini:

- Jangan menambahkan login.
- Jangan menambahkan database.
- Jangan menambahkan backend.
- Jangan menambahkan payment gateway.
- Jangan menambahkan API eksternal.
- Jangan menambahkan fitur yang belum ditentukan.
- Jangan menggunakan state management eksternal jika belum diperlukan.

Fokus project adalah:

> **Katalog Wisata + Pencarian + Filter + Sorting + Detail Wisata + Perhitungan Tiket + Validasi Kuota + Diskon Rombongan + Responsive UI.**

---

# 27. Prinsip Pengembangan Bertahap

Project akan dikembangkan secara bertahap.

Ketika requirement baru diberikan:

1. Pertahankan fitur yang sudah dibuat.
2. Jangan menghapus requirement sebelumnya.
3. Tambahkan requirement baru ke sistem yang sudah ada.
4. Jangan membuat fitur tambahan tanpa diminta.
5. Pertahankan penggunaan Dart + Flutter.
6. Pertahankan prinsip mobile-first.
7. Pertahankan responsive breakpoint yang telah ditentukan.
8. Pertahankan pemisahan fungsi dan UI.
9. Jika membutuhkan file baru, gunakan file tersebut hanya jika memang diperlukan.
10. Kode harus tetap mudah dipahami dan sesuai untuk project studi kasus Flutter.

---

# 28. Target Akhir

Hasil akhir Travio adalah aplikasi Flutter mobile-first yang memungkinkan pengguna:

**Mencari → Menyaring → Mengurutkan → Memilih Wisata → Melihat Detail → Mengatur Jumlah Dewasa/Anak → Menghitung Tiket → Mendapatkan Diskon → Memastikan Kuota Tidak Terlampaui.**

Alur utama:

```text
Katalog Wisata
      ↓
Search / Filter / Sort
      ↓
Pilih Objek Wisata
      ↓
Halaman Rincian
      ↓
Hitung Tiket
      ↓
Counter Dewasa + Anak
      ↓
Validasi Kuota
      ↓
Hitung Subtotal
      ↓
Cek Diskon Rombongan
      ↓
Total Biaya
```

**Travio — Explore More, Pay Smarter.**