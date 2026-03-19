import 'package:flutter/material.dart';

import '../models/property.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({
    super.key,
    required this.property,
    this.onMessageOwner,
  });

  final Property property;
  final VoidCallback? onMessageOwner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Property Details',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            const SizedBox(height: 16),
            Text(
              property.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${property.address}, ${property.city}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _detailStat(
                    Icons.bed_outlined,
                    '${property.bedrooms}',
                    'Beds',
                  ),
                  _detailStat(
                    Icons.bathtub_outlined,
                    '${property.bathrooms}',
                    'Baths',
                  ),
                  _detailStat(
                    Icons.square_foot,
                    '${property.area.toInt()}',
                    'Sqft',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildRelatedPhotosSection(),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description.isEmpty
                        ? 'No description available for this property.'
                        : property.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type: ${_capitalize(property.type)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    property.isAvailable ? 'Available' : 'Unavailable',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: property.isAvailable
                          ? Colors.green
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '\$${_formatPrice(property.price)}${property.listingType == 'rent' ? '/mo' : ''}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F6FFF),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onMessageOwner,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  backgroundColor: const Color(0xFF4F6FFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Message Owner'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    final List<String> images = property.displayImageUrls;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: images.isNotEmpty
          ? Image.network(
              images.first,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderImage(),
            )
          : _placeholderImage(),
    );
  }

  Widget _buildRelatedPhotosSection() {
    final List<String> images = property.displayImageUrls;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Photos',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    images[index],
                    width: 120,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120,
                      height: 90,
                      color: const Color(0xFFEEF2FF),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFF4F6FFF),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4F6FFF)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 240,
      width: double.infinity,
      color: const Color(0xFFEEF2FF),
      child: const Icon(Icons.home, size: 72, color: Color(0xFF4F6FFF)),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}k';
    }
    return price.toStringAsFixed(0);
  }

  String _capitalize(String s) {
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
  }
}
