import 'package:flutter/material.dart';
import '../../models/property.dart';
import '../property_card.dart';

class NearbyPropertiesList extends StatelessWidget {
  final List<Property> properties;
  final void Function(Property) onTap;
  final void Function(int, bool) onFavoriteToggle;

  const NearbyPropertiesList({
    super.key,
    required this.properties,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final property = properties[index];
          return PropertyListCard(
            property: property,
            onTap: () => onTap(property),
            onFavoriteToggle: (val) => onFavoriteToggle(index, val),
          );
        },
        childCount: properties.length,
      ),
    );
  }
}
