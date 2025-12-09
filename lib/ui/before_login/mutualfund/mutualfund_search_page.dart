import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/data/models/mutual_fund.dart';
import 'package:istreet/providers/mutualfund_provider.dart';
import 'package:istreet/ui/before_login/mutualfund/fund_detail_page.dart';

class MutualFundSearchPage extends ConsumerStatefulWidget {
  final String? initialSearch; // ⭐ NEW

  const MutualFundSearchPage({super.key, this.initialSearch});

  @override
  ConsumerState<MutualFundSearchPage> createState() =>
      _MutualFundSearchPageState();
}

class _MutualFundSearchPageState extends ConsumerState<MutualFundSearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _controller;
  String _search = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _search = widget.initialSearch?.toLowerCase() ?? "";
    _controller = TextEditingController(text: widget.initialSearch ?? "");
  }

  String _getInitials(String txt) {
    if (txt.trim().isEmpty) return "?";
    List<String> parts = txt.split(" ");
    return parts.length == 1
        ? parts[0].substring(0, 2).toUpperCase()
        : (parts[0][0] + parts[1][0]).toUpperCase();
  }

  bool _isDirect(MutualFund f) => f.schemeName.toLowerCase().contains("direct");
  bool _isRegular(MutualFund f) =>
      f.schemeName.toLowerCase().contains("regular");
  bool _isIdcw(MutualFund f) =>
      f.schemeName.toLowerCase().contains("idcw") ||
      f.schemeName.toLowerCase().contains("bonus");

  List<MutualFund> _searchFilter(List<MutualFund> list) {
    if (_search.isEmpty) return list;

    return list
        .where(
          (e) =>
              e.fundHouse.toLowerCase().contains(_search) ||
              e.schemeName.toLowerCase().contains(_search),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(searchFundProvider(_search));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Search Mutual Funds",
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [
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
              data: (all) {
                final filtered = _searchFilter(all);

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(filtered.where(_isDirect).toList()),
                    _buildList(filtered.where(_isRegular).toList()),
                    _buildList(filtered.where(_isIdcw).toList()),
                    _buildList(
                      filtered
                          .where(
                            (f) =>
                                !_isDirect(f) &&
                                !_isRegular(f) &&
                                !_isIdcw(f),
                          )
                          .toList(),
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

  Widget _buildList(List<MutualFund> items) {
    final list = _searchFilter(items);

    if (_search.isEmpty) return _emptySearchUI();
    if (list.isEmpty) return _noResultsUI();

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: list.length,
      itemBuilder: (_, i) => _fundCard(list[i]),
    );
  }

  Widget _emptySearchUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 70, color: AppColors.primaryBlue),
          SizedBox(height: 12),
          Text(
            "Search a mutual fund",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Start typing to explore funds",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _noResultsUI() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 70, color: AppColors.primaryBlue),
            SizedBox(height: 12),
            Text(
              "No matching results",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Try searching something else",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ ALWAYS SHOW BACKEND IMAGE
  Widget _buildFundLogo(MutualFund f) {
    if (f.mfImageUrl.isNotEmpty && f.mfImageUrl.startsWith("http")) {
      return Image.network(
        f.mfImageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fallbackLogo(f),
      );
    }
    return _fallbackLogo(f);
  }

  Widget _fundCard(MutualFund f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.hardEdge,
                child: _buildFundLogo(f),
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
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            f.schemeCategory,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Start Date • ${f.schemeStartDate}",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _schemeChip(f.schemeType),
              const Spacer(),
              _learnMoreButton(f.schemeName),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fallbackLogo(MutualFund f) {
    return Center(
      child: Text(
        _getInitials(f.fundHouse),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _schemeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 10, 132, 255).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _learnMoreButton(String schemeName) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FundDetailPage(fundName: schemeName),
          ),
        );
      },
      child: const Text(
        "LEARN MORE",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}
