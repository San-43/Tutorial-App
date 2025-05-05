class Unit {
  final String title;
  final String subtitle;

  const Unit({
    required this.title,
    required this.subtitle,
  });

  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
    };
  }

  @override
  String toString() => 'Unit(title: $title, subtitle: $subtitle)';
}