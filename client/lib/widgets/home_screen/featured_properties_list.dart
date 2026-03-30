import 'package:flutter/material.dart';
import '../../models/property.dart';
import '../property_card.dart';

class FeaturedPropertiesList extends StatelessWidget {
  final List<Property> properties;
  final void Function(Property) onTap;
  final void Function(int, bool) onFavoriteToggle;

  const FeaturedPropertiesList({
    super.key,
    required this.properties,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return PropertyCard(
            property: property,
            onTap: () => onTap(property),
            onFavoriteToggle: (val) => onFavoriteToggle(index, val),
          );
        },
      ),
    );
  }
}
