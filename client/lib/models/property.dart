class Property {
  final int id;
  final String title;
  final String description;
  final String address;
  final String city;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String type; // apartment, house, villa, studio
  final List<String> imageUrls;
  final String listingType; // rent or sale
  final bool isFavorite;
  final bool isAvailable;
  final double? latitude;
  final double? longitude;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.city,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.type,
    required this.imageUrls,
    this.listingType = 'rent',
    this.isFavorite = false,
    this.isAvailable = true,
    this.latitude,
    this.longitude,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final dynamic imagesRaw = json['image_urls'] ?? json['images'];
    final List<String> parsedImages = imagesRaw is List
        ? imagesRaw
              .map((dynamic e) => e.toString())
              .where((String e) => e.isNotEmpty)
              .toList()
        : <String>[];

    final String status = (json['status'] ?? '').toString().toLowerCase();

    return Property(
      id: _asInt(json['id']),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      price: _asDouble(json['price']),
      bedrooms: _asInt(json['bedrooms']),
      bathrooms: _asInt(json['bathrooms']),
      area: _asDouble(json['area'] ?? json['area_sqft']),
      type: (json['type'] ?? '').toString(),
      imageUrls: parsedImages,
      listingType: (json['listing_type'] ?? 'rent').toString(),
      isFavorite: json['is_favorite'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? status == 'available',
      latitude: _asNullableDouble(json['latitude']),
      longitude: _asNullableDouble(json['longitude']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse((value ?? '').toString()) ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse((value ?? '').toString()) ?? 0;
  }

  static double? _asNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'address': address,
    'city': city,
    'price': price,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'area': area,
    'type': type,
    'image_urls': imageUrls,
    'listing_type': listingType,
    'is_favorite': isFavorite,
    'is_available': isAvailable,
    'latitude': latitude,
    'longitude': longitude,
  };

  Property copyWith({bool? isFavorite}) {
    return Property(
      id: id,
      title: title,
      description: description,
      address: address,
      city: city,
      price: price,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      area: area,
      type: type,
      imageUrls: imageUrls,
      listingType: listingType,
      isFavorite: isFavorite ?? this.isFavorite,
      isAvailable: isAvailable,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
