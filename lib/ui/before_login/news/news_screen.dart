// lib/ui/before_login/news/news_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/ui/before_login/news/news_detail_page.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/news_provider.dart';
import '../../../data/models/news_model.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/config/theme/app_text_styles.dart';
import 'package:istreet/config/theme/app_spacing.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> filters = [
    "Today",
    "Yesterday",
    "Last 7 Days",
    "Last 30 Days",
  ];
  final List<int> filterIds = [1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: filters.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsFilterProvider.notifier).state = filterIds[0];
      ref.refresh(newsProvider);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    if (!url.startsWith("http")) url = "https://$url";
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(children: [const CommonAppBar(), _buildTabs()]),
      ),

      body: newsAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text("No news available", style: AppTextStyles.body),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(newsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: list.length,
              itemBuilder: (context, i) => _newsCard(list[i]),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 6),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,

        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.textLight,

        indicatorColor: AppColors.primaryBlue,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,

        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),

        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),

        onTap: (i) {
          ref.read(newsFilterProvider.notifier).state = filterIds[i];
          ref.refresh(newsProvider);
        },

        tabs: filters.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _newsCard(NewsItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailPage(item: item)),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF0F7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.12),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.20),
            width: 1,
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // IMAGE LEFT (Bigger + Premium Rounded)
            // --------------------------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 30, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // --------------------------------------------------
            // CONTENT RIGHT
            // --------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 6),

                  // DESCRIPTION
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),

                  SizedBox(height: 10),

                  // --------------------------------------------------
                  // DATE ROW (CLEAN)
                  // --------------------------------------------------
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 6),
                      Text(
                        _shortDate(item.publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      return "${d.day}-${d.month}-${d.year}";
    } catch (_) {
      return iso;
    }
  }
}
