import 'package:flutter/material.dart';
import '../api/property_api.dart';
import '../models/property.dart';
import 'profile.dart';
import 'property_details_screen.dart';
import '../widgets/property_card.dart';
import '../widgets/home_screen/app_header.dart';
import '../widgets/home_screen/search_bar_widget.dart';
import '../widgets/home_screen/category_selector.dart';
import '../widgets/home_screen/section_title.dart';
import '../widgets/home_screen/featured_properties_list.dart';
import '../widgets/home_screen/nearby_properties_list.dart';
import '../widgets/home_screen/placeholder_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final PropertyApi _propertyApi = PropertyApi();
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _categories = [
    'All',
    'Apartment',
    'House',
    'Condo',
    'Townhouse',
    'Studenthouse',
  ];

  final List<Property> _featuredProperties = <Property>[];
  final List<Property> _nearbyProperties = <Property>[];

  @override
  void initState() {
    super.initState();
    // Defer property loading to avoid blocking main thread
    Future.microtask(() => _loadProperties());
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String category = _categories[_selectedCategoryIndex];
    final String? type = category == 'All' ? null : category.toLowerCase();
    final String search = _searchController.text.trim();

    try {
      final List<Property> properties = await _propertyApi
          .getProperties(type: type, search: search.isEmpty ? null : search)
          .timeout(const Duration(seconds: 10));

      if (!mounted) {
        return;
      }

      setState(() {
        _featuredProperties
          ..clear()
          ..addAll(properties.take(3));

        _nearbyProperties
          ..clear()
          ..addAll(properties.skip(3));

        _isLoading = false;
      });
    } catch (e, stack) {
      debugPrint('ERROR in _loadProperties: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load properties. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: _buildCurrentTabBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCurrentTabBody() {
    switch (_selectedNavIndex) {
      case 0:
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: AppHeader()),
              SliverToBoxAdapter(
                child: SearchBarWidget(
                  controller: _searchController,
                  onSearch: _loadProperties,
                  onFilter: _loadProperties,
                ),
              ),
              SliverToBoxAdapter(
                child: CategorySelector(
                  categories: _categories,
                  selectedIndex: _selectedCategoryIndex,
                  onCategorySelected: (index) {
                    setState(() => _selectedCategoryIndex = index);
                    _loadProperties();
                  },
                ),
              ),
              ..._buildPropertyContent(),
            ],
          ),
        );
      case 1:
        return const PlaceholderTab(
          icon: Icons.search,
          title: 'Search',
          subtitle: 'Use this tab to search homes.',
        );
      case 2:
        return const PlaceholderTab(
          icon: Icons.favorite_border,
          title: 'Saved',
          subtitle: 'Your saved properties will show here.',
        );
      case 3:
        return const PlaceholderTab(
          icon: Icons.chat_bubble_outline,
          title: 'Messages',
          subtitle: 'Your conversations will show here.',
        );
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  // PlaceholderTab now in widgets/placeholder_tab.dart

  // AppHeader now in widgets/app_header.dart

  // SearchBarWidget now in widgets/search_bar_widget.dart

  // CategorySelector now in widgets/category_selector.dart

  // SectionTitle now in widgets/section_title.dart

  // FeaturedPropertiesList now in widgets/featured_properties_list.dart

  List<Widget> _buildPropertyContent() {
    if (_isLoading) {
      return <Widget>[
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (_errorMessage != null) {
      return <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadProperties,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    if (_featuredProperties.isEmpty && _nearbyProperties.isEmpty) {
      return <Widget>[
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              'No properties found.',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),
      ];
    }

    return <Widget>[
      if (_featuredProperties.isNotEmpty)
        SliverToBoxAdapter(
          child: SectionTitle(title: 'Featured Properties', onSeeAll: () {}),
        ),
      if (_featuredProperties.isNotEmpty)
        SliverToBoxAdapter(
          child: FeaturedPropertiesList(
            properties: _featuredProperties,
            onTap: _openPropertyDetails,
            onFavoriteToggle: (index, val) => setState(() {
              _featuredProperties[index] = _featuredProperties[index].copyWith(
                isFavorite: val,
              );
            }),
          ),
        ),
      if (_nearbyProperties.isNotEmpty)
        SliverToBoxAdapter(
          child: SectionTitle(title: 'Nearby Properties', onSeeAll: () {}),
        ),
      if (_nearbyProperties.isNotEmpty)
        NearbyPropertiesList(
          properties: _nearbyProperties,
          onTap: _openPropertyDetails,
          onFavoriteToggle: (index, val) => setState(() {
            _nearbyProperties[index] = _nearbyProperties[index].copyWith(
              isFavorite: val,
            );
          }),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ];
  }

  Future<void> _openPropertyDetails(Property property) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PropertyDetailsScreen(
          property: property,
          onMessageOwner: () {
            Navigator.of(context).pop();
            setState(() => _selectedNavIndex = 3);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Message flow started for ${property.title}.'),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    const activeColor = Color(0xFF4F6FFF);
    const inactiveColor = Colors.grey;

    final items = [
      (icon: Icons.home_rounded, label: 'Home'),
      (icon: Icons.search, label: 'Search'),
      (icon: Icons.favorite_border, label: 'Saved'),
      (icon: Icons.chat_bubble_outline, label: 'Messages'),
      (icon: Icons.person_outline, label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
