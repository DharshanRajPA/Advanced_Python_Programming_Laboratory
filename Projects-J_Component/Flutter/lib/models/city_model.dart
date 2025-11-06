class City {
  final String name;
  final double? latitude;
  final double? longitude;

  City({
    required this.name,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is City && other.name.toLowerCase() == name.toLowerCase();
  }

  @override
  int get hashCode => name.toLowerCase().hashCode;
}

