## 🚀 Pembaruan Versi 1052-180926-S | Pembuatan Ulang Engine

> Pembaruan ini berfokus pada pembuatan ulang atau menulis ulang kode program Engine Daemon dan CLI nya dengan ini kami berharap bisa mengurangi bug yang sebelum nya ada dan juga deengan adanya penulisan ulang ini kami melakukan sebuah configurasi ulang tweak nya dengan melakukan pengurangan dan penambahan jenis kode tweak nya denganb ini kami harap dapat membuat daemon versi kali ini bisa lebih Optimal

## 🧠 Pembuatan Ulang Structur Dameon
> Kami Telah melakukan serangkaian pembuatan structure baru pada daemon yang baru yaitu versi 10120-UFG-S, di versi ini kami menggunakan model structure dari plugin baru yaitu Qiunix: Apollo model ini menggunakan model structure terbaru buatan kami yang terbukti lebih cepat dalam respon mode nya dan maintenance Tweak nyaa dapat di lakukan secara terstruktur

## 🦾 Pembaruan Fungsi Fitur Sistem 
> Kami melakukan sebuah configurasi ualng pada beberapa fungsi sistem di daemon dengan menggunakan model fungsi terbaaru dari plugin Qiunix: Apollo dengan menulis ulang kode nya dan di gantikan dengan model kode plugin baru

**Beberapa Fungsi Yang telah kami perbarui yaitu**
- **Bakground Reaper:** Sebelum nya background reaper sendiri melakukan (`force-stop`) pada aplikasi background secara masal tanpa adanya pengecekan pada penggunaan ram yang di gunakan oleh aplikasi nya dan itu menyebabkkan ke gagalan system dan membuat cpu berkerja keras untuk melakukan force-stop tersebut, dan juga terjadi nya ke gagalan system launcher yang membuat system UI pada perangkat tidak berfungsi dan mengakibatkan eror pada UI perangkat.
- **Thermal Auto Calculasi:** Penmbahan calculasi pada thermal agar system saat di gunakan bermain game tidak overheat yang akan menyebabkan trotle pada rendering game nya, dengan ini kami mmelakukan sebuahh fungsi calculasi yang di bantu oleh model Ai Opus 5 dengan ini thermal akan menyesuaikan secara otomatis dan meminimalisir kesalahan system thermal.
- **Pembersihan RAM Pintar:** Menambahkan pembersihan cache memori tingkat kernel (`drop_caches`) yang dieksekusi tepat sebelum game diluncurkan untuk memberikan RAM kosong maksimal dan mencegah freeze saat loading awal (Hanya Root).
- **Anti-Zombie Background Reaper:** Mengimplementasikan mekanisme Lock-File atomik (`vision_reaper.lock`) untuk mencegah loop pembersihan latar belakang saling bertumpuk (overlap) saat pengguna beralih antar aplikasi dengan cepat.
- **Deteksi Root Dinamis:** Memperbarui sistem pengecekan root untuk menguji akses tulis (write access) secara langsung pada klaster CPU yang aktif, memastikan perlindungan termal bawaan OS tidak lumpuh secara tidak sengaja pada pengaturan Shizuku/non-root.
- **Parsing Tanggal POSIX-Safe:** Mengonsolidasikan perintah pengecekan waktu agar hanya dieksekusi sekali per loop, secara signifikan menghemat daya baterai dan mengurangi beban pemrosesan (overhead).

---

## 🔧 Perbaikan Tambahan
- **Polling Adaptif (`game_stable_loops`):** Daemon kini secara cerdas menyesuaikan waktu jedanya (dari 3 detik hingga 15 detik) setelah status di dalam game mulai stabil.
- Mengganti spam perintah `dumpsys window` yang berat dengan sistem deteksi aplikasi *foreground* yang berlapis dan di-cache.
- Perbaikan bug minor dan peningkatan stabilitas sistem secara keseluruhan.

> Terima kasih telah menggunakan sistem kami. Nantikan pembaruan mendatang yang akan menghadirkan lebih banyak peningkatan dan fitur baru yang menarik.