/// Recursos de gamificação que atravessam as fases.
///
/// - `coffees`: vidas (xícaras de café), de 0 a [maxCoffees].
/// - `prestige`: Prestígio no Gabinete, de 0 a 100.
/// - `combo`: acertos técnicos consecutivos.
class GameStats {
  const GameStats({
    this.coffees = maxCoffees,
    this.prestige = 0,
    this.combo = 0,
  });

  static const int maxCoffees = 3;
  static const int maxPrestige = 100;

  final int coffees;
  final int prestige;
  final int combo;

  bool get isOutOfCoffee => coffees <= 0;

  /// O selo de fogo só aparece a partir de dois acertos seguidos.
  bool get hasCombo => combo >= 2;

  double get prestigeRatio => prestige / maxPrestige;

  GameStats copyWith({int? coffees, int? prestige, int? combo}) {
    return GameStats(
      coffees: (coffees ?? this.coffees).clamp(0, maxCoffees),
      prestige: (prestige ?? this.prestige).clamp(0, maxPrestige),
      combo: (combo ?? this.combo).clamp(0, 99),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'coffees': coffees,
    'prestige': prestige,
    'combo': combo,
  };

  static GameStats? fromJson(Map<String, dynamic> json) {
    final Object? coffees = json['coffees'];
    final Object? prestige = json['prestige'];
    final Object? combo = json['combo'];
    if (coffees is! int || prestige is! int || combo is! int) return null;
    return GameStats(
      coffees: coffees.clamp(0, maxCoffees),
      prestige: prestige.clamp(0, maxPrestige),
      combo: combo.clamp(0, 99),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GameStats &&
      other.coffees == coffees &&
      other.prestige == prestige &&
      other.combo == combo;

  @override
  int get hashCode => Object.hash(coffees, prestige, combo);
}
