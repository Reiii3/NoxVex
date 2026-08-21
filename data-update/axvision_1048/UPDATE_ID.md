## 🚀 Pembaruan Versi 1048-210826-S | Rilis Deep Fix

> Pembaruan ini berfokus pada penyelesaian masalah micro-stutter akibat daemon dan inkonsistensi status, terutama di lingkungan non-root. Kami telah sepenuhnya beralih dari pendekatan polling paksa (brute-force) ke arsitektur adaptif yang sangat optimal untuk memastikan perangkat Anda berjalan lebih ringan dan lebih dingin di latar belakang.

## ✨ Perubahan & Peningkatan
> **⚡ Pengurangan Stutter & Lag Signifikan**
Loop inti daemon telah dirombak secara besar-besaran untuk meminimalkan beban CPU dan bottleneck I/O, secara drastis mengurangi frame drop selama sesi gaming berat.»

## 🌐 Optimasi Jaringan & Input
> Menghadirkan penyesuaian (tweaks) Ping Stabilizer tingkat lanjut dan Responsivitas Sentuhan untuk memberikan pengalaman bermain game yang lancar dan sangat kompetitif.

**Apa yang Baru di Versi Ini?**
- **Ping Stabilizer:** Menambahkan pembatasan data latar belakang (`netpolicy set-restrict-background`) untuk secara otomatis memblokir aplikasi yang tidak aktif agar tidak memakan bandwidth saat bermain game, secara drastis mengurangi lonjakan ping (ping spike).
- **Responsivitas Sentuhan:** Mengintegrasikan penyesuaian kecepatan pointer maksimal dan mematikan sensor rotasi otomatis di latar belakang selama Mode Game untuk membebaskan siklus CPU dan meningkatkan respons layar sentuh.
- **Pembersihan RAM Pintar:** Menambahkan pembersihan cache memori tingkat kernel (`drop_caches`) yang dieksekusi tepat sebelum game diluncurkan untuk memberikan RAM kosong maksimal dan mencegah freeze saat loading awal (Hanya Root).

## ⚙️ Pembaruan Engine
> Engine daemon latar belakang telah menerima perbaikan struktural mendalam untuk meningkatkan manajemen tugas, efisiensi baterai, dan keamanan sistem.

- **Anti-Zombie Background Reaper:** Mengimplementasikan mekanisme Lock-File atomik (`vision_reaper.lock`) untuk mencegah loop pembersihan latar belakang saling bertumpuk (overlap) saat pengguna beralih antar aplikasi dengan cepat.
- **Deteksi Root Dinamis:** Memperbarui sistem pengecekan root untuk menguji akses tulis (write access) secara langsung pada klaster CPU yang aktif, memastikan perlindungan termal bawaan OS tidak lumpuh secara tidak sengaja pada pengaturan Shizuku/non-root.
- **Parsing Tanggal POSIX-Safe:** Mengonsolidasikan perintah pengecekan waktu agar hanya dieksekusi sekali per loop, secara signifikan menghemat daya baterai dan mengurangi beban pemrosesan (overhead).

---

## 🔧 Perbaikan Tambahan
- **Polling Adaptif (`game_stable_loops`):** Daemon kini secara cerdas menyesuaikan waktu jedanya (dari 3 detik hingga 15 detik) setelah status di dalam game mulai stabil.
- Mengganti spam perintah `dumpsys window` yang berat dengan sistem deteksi aplikasi *foreground* yang berlapis dan di-cache.
- Perbaikan bug minor dan peningkatan stabilitas sistem secara keseluruhan.

> Terima kasih telah menggunakan sistem kami. Nantikan pembaruan mendatang yang akan menghadirkan lebih banyak peningkatan dan fitur baru yang menarik.