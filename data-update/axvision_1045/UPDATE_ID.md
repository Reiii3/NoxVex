## Update AxVision v1047-070726-S

> Update ini berfokus pada optimalisasi plugin, mulai dari WebUI, engine, hingga berbagai komponen lainnya. Update ini menjadi bukti bahwa AxVision terus berkembang. Kini kami telah memasuki versi **1047-070726-S**, yang tentunya bukan perjalanan yang mudah. Banyak bug yang ditemukan selama proses pengembangan, namun semuanya berhasil kami atasi hingga akhirnya versi ini siap dirilis. Berikut adalah beberapa perubahan yang hadir pada update kali ini.

### - Perbaikan pada Engine

> Kami telah memperbaiki beberapa bug yang ditemukan pada engine, khususnya pada fitur `Frame Rate` dan `Game Driver`. Dengan perbaikan ini, kedua fitur tersebut kini dapat digunakan kembali dengan normal.

### - Penambahan Fitur pada Engine v1042

> Berikut beberapa fitur baru yang kami tambahkan pada Engine v1042:

* **Multitask Mode**

  > Fitur ini memungkinkan engine mengatur batas penggunaan RAM untuk aplikasi yang berjalan di latar belakang, sehingga penggunaan memori menjadi lebih efisien dan multitasking menjadi lebih optimal.

* **CMD Tweak**

  > CMD Tweak merupakan kumpulan optimasi berbasis perintah `cmd` yang diadaptasi dari plugin **AxManager**. Berkat source code yang tersedia, kami dapat mengintegrasikan fitur ini ke dalam engine AxVision. Terima kasih kepada **[HoyoSlave](https://t.me/HoyoSlave)** atas kontribusinya.

* **Smart Compact**

  > Smart Compact membantu mengurangi fragmentasi RAM, meningkatkan efisiensi alokasi memori berukuran besar, serta mengoptimalkan penggunaan RAM secara keseluruhan.

* **Auto Cut Charging** `Khusus Perangkat OPPO`

  > Fitur ini dikhususkan untuk perangkat OPPO yang telah mendukung sistem Auto Cut Charging bawaan. Engine akan mengaktifkan fitur tersebut secara otomatis ketika batas pengisian daya telah tercapai, sehingga pengguna dapat bermain game sambil mengisi daya dengan lebih aman.

* **Profile Protect**

  > Profile Protect merupakan mekanisme yang dikembangkan untuk melakukan pergantian profil secara otomatis ketika suhu perangkat mulai meningkat. Dengan begitu, engine akan memilih profil yang paling sesuai agar performa tetap stabil dan suhu perangkat lebih terjaga.

* **Dan Masih Banyak Lagi**

  > Masih terdapat berbagai penambahan fitur dan penyempurnaan lainnya pada engine yang dapat langsung Anda coba.

### - Penambahan Fitur pada Game Library

> Pada update **v1045**, kami sempat lupa melakukan konfigurasi pada menu **Game Library**. Saat itu update masih menggunakan Engine **v1036** yang belum memiliki konfigurasi tersebut. Melalui uji coba Engine **v1038** pada **Daemon Monitor**, proses implementasi berhasil diselesaikan sehingga fitur seperti `Game Driver`, `Graphic Scale`, dan `Frame Rate` akhirnya dapat digunakan.

#### Penambahan Terbaru

* **Dynamic Frame Rate**

  > Dengan hadirnya fitur ini, pengguna tidak perlu lagi melakukan konfigurasi Frame Rate secara manual. WebUI akan secara otomatis mendeteksi frame rate tertinggi yang didukung oleh perangkat Anda.

### - Update WebUI

> Ini merupakan pembaruan UI terbesar yang pernah kami lakukan pada AxVision. Banyak perubahan besar yang berhasil kami hadirkan, di antaranya:

* **Perubahan Tema UI**

  > Kami mengakui bahwa tampilan UI pada versi **v1045** masih kurang optimal dan terasa cukup berat, terutama pada perangkat kelas entry-level. Pada update ini kami melakukan perubahan besar dengan mengadopsi tema warna bergaya **Android 16**, sehingga tampilannya menjadi lebih modern dan nyaman digunakan.

* **Optimalisasi WebUI**

  > Optimalisasi pada versi sebelumnya masih jauh dari harapan. Setelah melalui proses maintenance yang cukup panjang, kami berhasil mengurangi sekitar **70%** penyebab utama lag pada WebUI sehingga pengalaman penggunaan kini menjadi jauh lebih lancar.

* **Penamaan UI**

  > Sebelumnya antarmuka kami belum memiliki identitas khusus. Mulai dari versi **1045** dan **1047**, antarmuka resmi menggunakan nama **VISIONUI** versi **10200-UI**. Dengan adanya penamaan ini, proses maintenance dan pengelolaan versi akan menjadi lebih mudah.

* **Dan Masih Banyak Perubahan Lainnya**

  > Masih banyak penyempurnaan lain yang dapat Anda temukan langsung saat menggunakan WebUI terbaru.

### - Penjelasan Mengenai Available Features

> **Available Features** merupakan mekanisme yang kami buat agar pengguna dapat menikmati fitur-fitur baru tanpa harus memperbarui seluruh file plugin. Kami hanya perlu memperbarui versi engine, kemudian fitur baru akan tersedia melalui patch online. Dengan cara ini, kami berharap pengguna dapat menikmati pembaruan fitur dengan lebih mudah dan praktis.

---

> Sebenarnya masih banyak hal yang ingin kami jelaskan mengenai update kali ini karena ini merupakan salah satu update terbesar yang pernah kami kerjakan. Namun karena kondisi saya sedang kurang sehat, saya rasa penjelasan kali ini cukup sampai di sini. Semoga kalian bisa memakluminya.
>
> Terakhir, saya ingin mengucapkan terima kasih kepada seluruh pengguna **AxVision**. Saat ini jumlah pengguna telah mencapai lebih dari **7.000 pengguna**, dan melihat perkembangan komunitas sebesar ini tentu menjadi kebanggaan tersendiri bagi kami.
>
> **Terima kasih atas dukungan kalian. Semoga AxVision terus berkembang menjadi lebih baik! 😊**
