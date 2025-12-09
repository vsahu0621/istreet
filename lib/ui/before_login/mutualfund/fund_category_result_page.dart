import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/providers/fund_by_category_provider.dart';
import 'package:istreet/ui/before_login/mutualfund/fund_detail_page.dart';

class FundCategoryResultPage extends ConsumerStatefulWidget {
  final String title;
  final String apiCategory;

  const FundCategoryResultPage({
    super.key,
    required this.title,
    required this.apiCategory,
  });

  @override
  ConsumerState<FundCategoryResultPage> createState() =>
      _FundCategoryResultPageState();
}

class _FundCategoryResultPageState extends ConsumerState<FundCategoryResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _controller;
  String _search = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _controller = TextEditingController();
  }

  // ---------------- FILTER LOGIC ----------------

  bool _isDirect(f) => f.schemeName.toLowerCase().contains("direct");
  bool _isRegular(f) => f.schemeName.toLowerCase().contains("regular");
  bool _isIdcw(f) =>
      f.schemeName.toLowerCase().contains("idcw") ||
      f.schemeName.toLowerCase().contains("bonus");

  List _searchFilter(List list) {
    if (_search.isEmpty) return list;

    return list
        .where(
          (e) =>
              e.schemeName.toLowerCase().contains(_search) ||
              e.fundHouse.toLowerCase().contains(_search),
        )
        .toList();
  }

  // ---------------- UI HELPERS (same as Search Page) ----------------

  String _getInitials(String name) {
    if (name.isEmpty) return "?";
    final parts = name.split(" ");
    return (parts.length == 1
            ? parts[0].substring(0, 2)
            : parts[0][0] + parts[1][0])
        .toUpperCase();
  }

  Widget _fallbackLogo(String fundHouse) {
    return Center(
      child: Text(
        _getInitials(fundHouse),
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _schemeChip(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _fundCard(f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  f.imageUrl,
                  width: 42,
                  height: 42,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _fallbackLogo(f.fundHouse),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  f.schemeName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            f.fundHouse,
            style: const TextStyle(color: AppColors.primaryBlue, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            f.schemeCategory,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            "Start Date • ${f.schemeStartDate}",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _schemeChip(f.schemeType),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FundDetailPage(fundName: f.schemeName),
                    ),
                  );
                },
                child: const Text(
                  "LEARN MORE",
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- PAGE BUILD ----------------

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(fundByCategoryProvider(widget.apiCategory));

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Column(
        children: [
          // SEARCH BAR SAME UI
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search fund house or scheme...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // TAB BAR SAME UI
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryBlue,
            tabs: const [
              Tab(text: "Direct"),
              Tab(text: "Regular"),
              Tab(text: "IDCW"),
              Tab(text: "Other"),
            ],
          ),

          Expanded(
            child: asyncData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text("Error: $e")),
              data: (allFunds) {
                final filtered = _searchFilter(allFunds);

                return TabBarView(
                  controller: _tabController,
                  children: [
                    // DIRECT
                    ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: filtered.where(_isDirect).length,
                      itemBuilder: (_, i) =>
                          _fundCard(filtered.where(_isDirect).toList()[i]),
                    ),

                    // REGULAR
                    ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: filtered.where(_isRegular).length,
                      itemBuilder: (_, i) =>
                          _fundCard(filtered.where(_isRegular).toList()[i]),
                    ),

                    // IDCW
                    ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: filtered.where(_isIdcw).length,
                      itemBuilder: (_, i) =>
                          _fundCard(filtered.where(_isIdcw).toList()[i]),
                    ),

                    // OTHER
                    ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: filtered
                          .where(
                            (f) =>
                                !_isDirect(f) && !_isRegular(f) && !_isIdcw(f),
                          )
                          .length,
                      itemBuilder: (_, i) => _fundCard(
                        filtered
                            .where(
                              (f) =>
                                  !_isDirect(f) &&
                                  !_isRegular(f) &&
                                  !_isIdcw(f),
                            )
                            .toList()[i],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
