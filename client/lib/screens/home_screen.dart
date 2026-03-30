import 'package:flutter/material.dart';
import '../api/property_api.dart';
import '../models/property.dart';
import 'profile.dart';
import 'property_details_screen.dart';
import '../widgets/property_card.dart';

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
    _loadProperties();
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
      final List<Property> properties = await _propertyApi.getProperties(
        type: type,
        search: search.isEmpty ? null : search,
      );

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
    } catch (_) {
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
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildCategories()),
              ..._buildPropertyContent(),
            ],
          ),
        );
      case 1:
        return _buildPlaceholderTab(
          icon: Icons.search,
          title: 'Search',
          subtitle: 'Use this tab to search homes.',
        );
      case 2:
        return _buildPlaceholderTab(
          icon: Icons.favorite_border,
          title: 'Saved',
          subtitle: 'Your saved properties will show here.',
        );
      case 3:
        return _buildPlaceholderTab(
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

  Widget _buildPlaceholderTab({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 52, color: const Color(0xFF4F6FFF)),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, color: Color(0xFF1A1A2E)),
                  children: [
                    TextSpan(text: 'Find Your '),
                    TextSpan(
                      text: 'Dream Home',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F6FFF),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 14, color: Colors.grey),
                  SizedBox(width: 2),
                  Text(
                    'New York, USA',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF4F6FFF),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _loadProperties(),
                decoration: InputDecoration(
                  hintText: 'Search address, city, or type…',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF4F6FFF),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _loadProperties,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF4F6FFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategoryIndex = index);
              _loadProperties();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF4F6FFF) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4F6FFF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See all',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF4F6FFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedList() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _featuredProperties.length,
        itemBuilder: (context, index) {
          final property = _featuredProperties[index];
          return PropertyCard(
            property: property,
            onTap: () => _openPropertyDetails(property),
            onFavoriteToggle: (val) => setState(() {
              _featuredProperties[index] = property.copyWith(isFavorite: val);
            }),
          );
        },
      ),
    );
  }

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
          child: _buildSectionTitle('Featured Properties', onSeeAll: () {}),
        ),
      if (_featuredProperties.isNotEmpty)
        SliverToBoxAdapter(child: _buildFeaturedList()),
      if (_nearbyProperties.isNotEmpty)
        SliverToBoxAdapter(
          child: _buildSectionTitle('Nearby Properties', onSeeAll: () {}),
        ),
      if (_nearbyProperties.isNotEmpty)
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final property = _nearbyProperties[index];
            return PropertyListCard(
              property: property,
              onTap: () => _openPropertyDetails(property),
              onFavoriteToggle: (val) => setState(() {
                _nearbyProperties[index] = property.copyWith(isFavorite: val);
              }),
            );
          }, childCount: _nearbyProperties.length),
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
