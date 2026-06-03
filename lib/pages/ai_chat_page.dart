import 'package:flutter/material.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();

 List<Map<String, dynamic>> messages = [
  {
    "isUser": false,
    "message":
        "Halo 👋\nSaya MovieBot.\n\nSaya bisa membantu:\n• Rekomendasi Film\n• Harga Tiket\n• Cara Pembelian Tiket\n• Informasi Bioskop",
  }
];

  String getBotResponse(String text) {
    final msg = text.toLowerCase();

    if (msg.contains("action")) {
      return """
🎬 Rekomendasi Film Action

• John Wick
• Mad Max
• Extraction
• The Dark Knight

Selamat menonton 🍿
""";
    }

    if (msg.contains("horor") || msg.contains("horror")) {
      return """
👻 Rekomendasi Film Horor

• The Conjuring
• Insidious
• Annabelle
• The Nun

Jangan nonton sendirian 😱
""";
    }

    if (msg.contains("comedy") || msg.contains("komedi")) {
      return """
😂 Rekomendasi Film Komedi

• Home Alone
• Mr Bean Holiday
• The Mask
• Free Guy
""";
    }

    if (msg.contains("drama")) {
      return """
🎭 Rekomendasi Film Drama

• Titanic
• The Pursuit of Happyness
• Forrest Gump
• A Star Is Born
""";
    }

    if (msg.contains("harga")) {
      return """
💰 Harga Tiket

Harga tiket saat ini:

Rp 50.000 / kursi

Total harga dihitung berdasarkan jumlah kursi yang dipilih.
""";
    }

    if (msg.contains("beli") ||
        msg.contains("ticket") ||
        msg.contains("tiket")) {
      return """
🎟 Cara Membeli Tiket

1. Pilih film
2. Pilih kursi
3. Pilih jam tayang
4. Klik Buy Ticket

Tiket akan otomatis masuk ke History.
""";
    }

    if (msg.contains("lokasi") ||
        msg.contains("bioskop") ||
        msg.contains("map")) {
      return """
📍 Informasi Bioskop

Silakan buka menu MAP pada Halaman Utama untuk melihat lokasi bioskop.
""";
    }

    if (msg.contains("favorit") || msg.contains("favorite")) {
      return """
❤️ Favorite Movies

Tekan ikon hati pada halaman detail film untuk menambahkan film ke daftar favorit.
""";
    }

    if (msg.contains("halo") || msg.contains("hai") || msg.contains("hello")) {
      return """
Halo 👋

Ada yang bisa saya bantu?

Contoh:

• Film Action
• Film Horor
• Harga Tiket
• Cara Beli Tiket
• Lokasi Bioskop
""";
    }

    return """
🤖 Maaf saya belum memahami pertanyaan tersebut.

Coba tanyakan:

• Film Action
• Film Horor
• Film Drama
• Harga Tiket
• Cara Beli Tiket
• Lokasi Bioskop
""";
  }

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    String userText = _controller.text.trim();

    setState(() {
      messages.add({
        "isUser": true,
        "message": userText,
      });
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        messages.add({
          "isUser": false,
          "message": getBotResponse(userText),
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie AI ChatBot"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
              Color(0xFFDDD6FE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final chat = messages[index];

                  return Align(
                    alignment: chat["isUser"]
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: chat["isUser"]
                            ? Colors.blue.shade700
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        chat["message"],
                        style: TextStyle(
                          color: chat["isUser"] ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Tulis pesan...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade700,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
