<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use App\Models\Properties;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request)
    {
        $favorites = Favorite::with('property.user')
            ->latest()
            ->paginate($request->input('per_page', 15));

        return response()->json($favorites);
    }

    public function toggle(Request $request)
    {
        $validated = $request->validate([
            'property_id' => ['required', 'exists:properties,id'],
        ]);

        $validated = array_merge($validated, $request->validate([
            'user_id' => ['required', 'exists:users,id'],
        ]));

        $existing = Favorite::where('user_id', $validated['user_id'])
            ->where('property_id', $validated['property_id'])
            ->first();

        if ($existing) {
            $existing->delete();
            return response()->json(['message' => 'Removed from favorites.', 'favorited' => false]);
        }

        Favorite::create([
            'user_id' => $validated['user_id'],
            'property_id' => $validated['property_id'],
        ]);

        return response()->json(['message' => 'Added to favorites.', 'favorited' => true], 201);
    }

    public function destroy(Request $request, Favorite $favorite)
    {
        $favorite->delete();

        return response()->json(['message' => 'Removed from favorites.']);
    }
}
