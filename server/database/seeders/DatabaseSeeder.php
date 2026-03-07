<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Properties;
use App\Models\RentalAgreement;
use App\Models\Favorite;
use App\Models\Notification;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    public function run(): void
    {
        // Create admin user
        $admin = User::factory()->create([
            'name' => 'Admin User',
            'email' => 'admin@casacore.com',
            'role' => 'admin',
        ]);

        // Create landlords
        $landlord1 = User::factory()->create([
            'name' => 'John Landlord',
            'email' => 'landlord@casacore.com',
            'role' => 'landlord',
        ]);

        $landlord2 = User::factory()->create([
            'name' => 'Sarah Properties',
            'email' => 'sarah@casacore.com',
            'role' => 'landlord',
        ]);

        // Create tenants
        $tenant1 = User::factory()->create([
            'name' => 'Mike Tenant',
            'email' => 'tenant@casacore.com',
            'role' => 'tenant',
        ]);

        $tenant2 = User::factory()->create([
            'name' => 'Emma Renter',
            'email' => 'emma@casacore.com',
            'role' => 'tenant',
        ]);

        // Create additional random users
        User::factory(5)->create();

        // Create properties
        $properties = [
            [
                'title' => 'Modern Downtown Apartment',
                'description' => 'A stunning 2-bedroom apartment in the heart of downtown with city views, modern kitchen, and in-unit laundry.',
                'address' => '123 Main Street, Apt 4B',
                'city' => 'Amsterdam',
                'country' => 'Netherlands',
                'zip_code' => '1012 AB',
                'type' => 'apartment',
                'status' => 'available',
                'listing_type' => 'rent',
                'price' => 1800.00,
                'bedrooms' => 2,
                'bathrooms' => 1,
                'area_sqft' => 850,
                'year_built' => 2020,
                'latitude' => 52.3676,
                'longitude' => 4.9041,
                'user_id' => $landlord1->id,
            ],
            [
                'title' => 'Spacious Family House',
                'description' => 'Beautiful 4-bedroom family house with a large garden, garage, and quiet neighborhood. Perfect for families.',
                'address' => '45 Oak Avenue',
                'city' => 'Rotterdam',
                'country' => 'Netherlands',
                'zip_code' => '3011 AA',
                'type' => 'house',
                'status' => 'available',
                'listing_type' => 'sale',
                'price' => 450000.00,
                'bedrooms' => 4,
                'bathrooms' => 2,
                'area_sqft' => 2200,
                'year_built' => 2015,
                'latitude' => 51.9225,
                'longitude' => 4.4792,
                'user_id' => $landlord1->id,
            ],
            [
                'title' => 'Cozy Student Room',
                'description' => 'Affordable student room near the university campus with shared kitchen and bathroom facilities.',
                'address' => '78 University Lane',
                'city' => 'Utrecht',
                'country' => 'Netherlands',
                'zip_code' => '3512 JE',
                'type' => 'studenthouse',
                'status' => 'available',
                'listing_type' => 'rent',
                'price' => 550.00,
                'bedrooms' => 1,
                'bathrooms' => 1,
                'area_sqft' => 250,
                'year_built' => 2005,
                'latitude' => 52.0907,
                'longitude' => 5.1214,
                'user_id' => $landlord2->id,
            ],
            [
                'title' => 'Luxury Condo with Sea View',
                'description' => 'Premium 3-bedroom condo with panoramic sea views, balcony, pool access, and underground parking.',
                'address' => '12 Coastal Boulevard',
                'city' => 'The Hague',
                'country' => 'Netherlands',
                'zip_code' => '2511 BT',
                'type' => 'condo',
                'status' => 'available',
                'listing_type' => 'sale',
                'price' => 675000.00,
                'bedrooms' => 3,
                'bathrooms' => 2,
                'area_sqft' => 1500,
                'year_built' => 2022,
                'latitude' => 52.0705,
                'longitude' => 4.3007,
                'user_id' => $landlord2->id,
            ],
            [
                'title' => 'Commercial Office Space',
                'description' => 'Open-plan office space in a modern business district. Includes reception area, meeting rooms, and kitchenette.',
                'address' => '200 Business Park',
                'city' => 'Eindhoven',
                'country' => 'Netherlands',
                'zip_code' => '5611 AB',
                'type' => 'commercial',
                'status' => 'available',
                'listing_type' => 'rent',
                'price' => 3500.00,
                'bedrooms' => 0,
                'bathrooms' => 2,
                'area_sqft' => 3000,
                'year_built' => 2018,
                'latitude' => 51.4416,
                'longitude' => 5.4697,
                'user_id' => $landlord1->id,
            ],
            [
                'title' => 'Charming Townhouse',
                'description' => 'A 3-bedroom townhouse with original features, updated kitchen, and a private courtyard garden.',
                'address' => '33 Heritage Row',
                'city' => 'Amsterdam',
                'country' => 'Netherlands',
                'zip_code' => '1017 DS',
                'type' => 'townhouse',
                'status' => 'rented',
                'listing_type' => 'rent',
                'price' => 2500.00,
                'bedrooms' => 3,
                'bathrooms' => 2,
                'area_sqft' => 1600,
                'year_built' => 1920,
                'latitude' => 52.3602,
                'longitude' => 4.8852,
                'user_id' => $landlord2->id,
            ],
        ];

        $createdProperties = [];
        foreach ($properties as $property) {
            $createdProperties[] = Properties::create($property);
        }

        // Create a rental agreement
        RentalAgreement::create([
            'property_id' => $createdProperties[5]->id, // Townhouse (rented)
            'tenant_id' => $tenant1->id,
            'landlord_id' => $landlord2->id,
            'start_date' => '2026-01-01',
            'end_date' => '2026-12-31',
            'monthly_rent' => 2500.00,
            'deposit' => 5000.00,
            'status' => 'active',
            'terms' => 'Standard 12-month lease. Pets allowed with additional deposit.',
        ]);

        // Create favorites
        Favorite::create(['user_id' => $tenant1->id, 'property_id' => $createdProperties[0]->id]);
        Favorite::create(['user_id' => $tenant1->id, 'property_id' => $createdProperties[3]->id]);
        Favorite::create(['user_id' => $tenant2->id, 'property_id' => $createdProperties[1]->id]);

        // Create notifications
        Notification::create([
            'user_id' => $tenant1->id,
            'title' => 'Welcome to CasaCoreHousing!',
            'message' => 'Start browsing available properties and find your perfect home.',
            'type' => 'system',
        ]);

        Notification::create([
            'user_id' => $tenant1->id,
            'title' => 'New Listing in Amsterdam',
            'message' => 'A new apartment matching your preferences has been listed.',
            'type' => 'listing',
            'data' => ['property_id' => $createdProperties[0]->id],
        ]);
    }
}
