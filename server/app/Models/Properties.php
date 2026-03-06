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
        'images' => 'array', // Cast images to an array
    ];

    /**
     * Get the user that owns the property.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
