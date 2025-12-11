import 'package:flutter/material.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/ui/common_widgets/insidepage_appbar.dart';
import '../../../data/models/news_model.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsItem item;

  const NewsDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: const InsidePageAppBar(),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ TOP IMAGE
            if (item.imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⭐ TITLE
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ⭐ DESCRIPTION
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.55,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ⭐ INDIA • DATE (Below description)
                  Row(
                    children: [
                      const Text(
                        "India",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text("•", style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      Text(
                        item.publishedAt,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
