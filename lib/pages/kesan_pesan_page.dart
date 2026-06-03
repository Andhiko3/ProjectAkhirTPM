import 'package:flutter/material.dart';

class KesanPesanPage extends StatelessWidget {
  const KesanPesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kesan & Pesan TPM"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "KESAN",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  "Mata kuliah Teknologi Pemrograman Mobile memberikan pengalaman yang sangat berharga dalam memahami proses pengembangan aplikasi mobile menggunakan Flutter. Melalui mata kuliah ini saya belajar mengenai UI/UX, API, database lokal, autentikasi, sensor perangkat, serta berbagai fitur mobile lainnya yang dapat diterapkan pada aplikasi nyata.",
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 25),

                Text(
                  "PESAN",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Semoga mata kuliah TPM terus berkembang mengikuti teknologi mobile terbaru. Praktikum yang diberikan sudah sangat membantu mahasiswa memahami implementasi secara langsung. Diharapkan semakin banyak studi kasus dan project nyata agar mahasiswa lebih siap menghadapi dunia kerja maupun pengembangan aplikasi mobile secara profesional.",
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}