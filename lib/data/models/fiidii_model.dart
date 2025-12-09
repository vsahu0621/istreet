class FiiDiiData {
  final String date;
  final double niftyValue;
  final String niftyChange;
  final double netCash;
  final double fiiCash;
  final double diiCash;

  final double netDerivatives;
  final double fiiIdxFut;
  final double fiiIdxOpt;
  final double fiiStkFut;
  final double fiiStkOpt;

  FiiDiiData({
    required this.date,
    required this.niftyValue,
    required this.niftyChange,
    required this.netCash,
    required this.fiiCash,
    required this.diiCash,
    required this.netDerivatives,
    required this.fiiIdxFut,
    required this.fiiIdxOpt,
    required this.fiiStkFut,
    required this.fiiStkOpt,
  });

  factory FiiDiiData.fromJson(Map<String, dynamic> json) {
    return FiiDiiData(
      date: json['date'],
      niftyValue: (json['nifty_value'] as num).toDouble(),
      niftyChange: json['nifty_change'],
      netCash: (json['net_cash'] as num).toDouble(),
      fiiCash: (json['fii_cash'] as num).toDouble(),
      diiCash: (json['dii_cash'] as num).toDouble(),

      netDerivatives: (json['net_derivatives'] as num).toDouble(),
      fiiIdxFut: (json['fii_idx_fut'] as num).toDouble(),
      fiiIdxOpt: (json['fii_idx_opt'] as num).toDouble(),
      fiiStkFut: (json['fii_stk_fut'] as num).toDouble(),
      fiiStkOpt: (json['fii_stk_opt'] as num).toDouble(),
    );
  }
}
