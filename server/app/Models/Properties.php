<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Properties extends Model
{
    protected $fillable = [
        'title',
        'description',
        'address',
        'city',
        'country',
        'zip_code',
        'type',
        'status',
        'listing_type',
        'price',
        'bedrooms',
        'bathrooms',
        'area_sqft',
        'year_built',
        'images',
        'latitude',
        'longitude',
        'user_id'
    ];

    protected $casts = [
        'images' => 'array',
        'price' => 'decimal:2',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function rentalAgreements()
    {
        return $this->hasMany(RentalAgreement::class, 'property_id');
    }

    public function favorites()
    {
        return $this->hasMany(Favorite::class, 'property_id');
    }
}
