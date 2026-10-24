# Aplikasi Resep Kuliner (Tugas UTS Pemrograman Mobile)

Aplikasi mobile berbasis Flutter dan Dart yang menyajikan informasi resep masakan nusantara dan internasional secara dinamis dengan mengonsumsi data dari TheMealDB Public REST API.

Dibuat untuk memenuhi Tugas Ujian Tengah Semester (UTS) Mata Kuliah Pemrograman Mobile, Program Studi Teknik Informatika, Universitas Islam Negeri Maulana Malik Ibrahim Malang.

---

## Fitur Aplikasi

1. **Eksplorasi Kategori Masakan:**
   Menampilkan seluruh kategori kuliner (seperti Seafood, Beef, Chicken, Dessert, Vegetarian) yang diambil secara dinamis dari API.
2. **Daftar Resep Berdasarkan Kategori:**
   Menampilkan hidangan dalam format grid responsif lengkap dengan nama dan foto hidangan.
3. **Pencarian Resep Real-Time:**
   Pencarian resep masakan secara langsung berdasarkan kata kunci nama makanan atau bahan.
4. **Detail Resep Lengkap:**
   Menyajikan foto beresolusi tinggi, informasi asal hidangan (Area/Country), kategori, takaran bahan secara presisi (Ingredients & Measures), dan panduan memasak langkah demi langkah (Cooking Instructions).
5. **State Management & Error Handling:**
   Penanganan komprehensif untuk kondisi memuat (Loading state), gagal koneksi (Error state dengan tombol coba lagi), dan hasil kosong (Empty state).

---

## Arsitektur & Struktur Direktori

Project menggunakan pendekatan modular yang memisahkan antara Data Model, Service API, Tampilan Layar (Screens), dan Komponen Antarmuka (Widgets):

```text
lib/
|-- main.dart                    # Titik masuk utama aplikasi & konfigurasi tema
|-- models/
|   |-- category_model.dart      # Model data kategori masakan
|   |-- meal_item_model.dart     # Model ringkasan hidangan untuk daftar/grid
|   `-- meal_detail_model.dart   # Model rincian resep lengkap & bahan masakan
|-- services/
|   `-- api_service.dart         # Layanan pemanggilan REST API (HTTP Client)
|-- screens/
|   |-- home_screen.dart         # Halaman utama (kategori & pencarian)
|   |-- meal_list_screen.dart    # Halaman daftar makanan per kategori
|   `-- meal_detail_screen.dart  # Halaman detail resep & cara memasak
`-- widgets/
    |-- category_card.dart       # Komponen kartu kategori
    |-- meal_card.dart           # Komponen kartu hidangan
    |-- ingredient_item.dart     # Komponen baris bahan dan takaran
    `-- error_view.dart          # Komponen tampilan kesalahan dan tombol retry
```

---

## Sumber Data API (TheMealDB)

Seluruh data disajikan secara dinamis dari TheMealDB REST API:
- Kategori: `https://www.themealdb.com/api/json/v1/1/categories.php`
- Filter per Kategori: `https://www.themealdb.com/api/json/v1/1/filter.php?c={Category}`
- Pencarian Resep: `https://www.themealdb.com/api/json/v1/1/search.php?s={Query}`
- Detail Resep: `https://www.themealdb.com/api/json/v1/1/lookup.php?i={IdMeal}`

---

## Cara Menjalankan Project

1. Pastikan Flutter SDK telah terpasang di komputer Anda:
   ```bash
   flutter doctor
   ```

2. Clone repositori ini:
   ```bash
   git clone https://github.com/rmhyps1/uts-mobile-programming-flutter.git
   cd uts-mobile-programming-flutter
   ```

3. Unduh seluruh dependensi:
   ```bash
   flutter pub get
   ```

4. Jalankan aplikasi pada perangkat/emulator yang terhubung:
   ```bash
   flutter run
   ```
