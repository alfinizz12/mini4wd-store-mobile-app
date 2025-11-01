import 'package:flutter/material.dart';

class TestimonialPage extends StatelessWidget {
  const TestimonialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              "Saya senang belajar mata kuliah Pemrograman Aplikasi Mobile karena saya dari awal memang suka coding atau programming dan bisa dibilang salah satu passion saya.",
              textAlign: TextAlign.justify,
            ),
          ),
          ListTile(
            title: Text("Pesan", style: Theme.of(context).textTheme.headlineSmall,),
            subtitle: Text(
              "Pesan dari saya tidak banyak, mungkin untuk mata kuliah ini bisa ditambahkan materi sedikit tentang state manager atau application lifecycle seperti itu, karena dari nama mata kuliah lebih mengarah ke Pemrograman Aplikasi.",
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}