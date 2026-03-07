<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePropertyRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string'],
            'address' => ['required', 'string', 'max:500'],
            'city' => ['required', 'string', 'max:100'],
            'country' => ['required', 'string', 'max:100'],
            'zip_code' => ['nullable', 'string', 'max:20'],
            'type' => ['required', 'in:house,apartment,condo,townhouse,land,commercial,studenthouse'],
            'status' => ['nullable', 'in:available,sold,rented,pending'],
            'listing_type' => ['required', 'in:sale,rent'],
            'price' => ['required', 'numeric', 'min:0'],
            'bedrooms' => ['nullable', 'integer', 'min:0'],
            'bathrooms' => ['nullable', 'integer', 'min:0'],
            'area_sqft' => ['nullable', 'integer', 'min:0'],
            'year_built' => ['nullable', 'integer', 'min:1800', 'max:' . date('Y')],
            'images' => ['nullable', 'array'],
            'images.*' => ['string', 'max:1000'],
            'latitude' => ['nullable', 'numeric', 'between:-90,90'],
            'longitude' => ['nullable', 'numeric', 'between:-180,180'],
        ];
    }
}
