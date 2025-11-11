import 'package:flutter/material.dart';

class TestimonialPage extends StatelessWidget {
  const TestimonialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Testimonials about Mobile Programming Subject",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20,),
            ListTile(
              title: Text("Kesan", style: Theme.of(context).textTheme.headlineSmall,),
              subtitle: Text(
                "Terima kasih untuk Pak Bagus selaku dosen Pemrograman Aplikasi Mobile yang telah membimbing kami selama menjalani mata kuliah ini. Mata kuliah ini akan menjadi mata kuliah yang berkesan karena tugas-tugas yang luar biasa. Overall, Saya senang belajar mata kuliah Pemrograman Aplikasi Mobile karena minat saya ke dalam bidang Software Engineering.",
                textAlign: TextAlign.justify,
              ),
            ),
            ListTile(
              title: Text("Pesan", style: Theme.of(context).textTheme.headlineSmall,),
              subtitle: Text(
                "Semoga mata kuliah ini menjadi mata kuliah yang sangat diminati, karena mata kuliah ini sangat menyenangkan. Sedikit pesan saya, mungkin untuk mata kuliah ini bisa ditambahkan materi sedikit mengenai state management atau application lifecycle seperti itu.",
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
    );
  }
}