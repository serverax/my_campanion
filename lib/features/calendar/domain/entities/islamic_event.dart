class IslamicEvent {
  final String id;
  final String name;
  final String nameAr;
  final int hijriMonth; // 1-12
  final int hijriDay;
  final String? notes;
  final bool isMajor;

  const IslamicEvent({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.hijriMonth,
    required this.hijriDay,
    this.notes,
    this.isMajor = false,
  });
}
