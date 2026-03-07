<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RentalAgreement;
use App\Models\Properties;
use App\Models\Notification;
use Illuminate\Http\Request;

class RentalAgreementController extends Controller
{
    public function index(Request $request)
    {
        $agreements = RentalAgreement::with(['property', 'tenant', 'landlord'])
            ->latest()
            ->paginate($request->input('per_page', 15));

        return response()->json($agreements);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'property_id' => ['required', 'exists:properties,id'],
            'tenant_id' => ['required', 'exists:users,id'],
            'start_date' => ['required', 'date', 'after_or_equal:today'],
            'end_date' => ['required', 'date', 'after:start_date'],
            'monthly_rent' => ['required', 'numeric', 'min:0'],
            'deposit' => ['nullable', 'numeric', 'min:0'],
            'terms' => ['nullable', 'string'],
        ]);

        $property = Properties::findOrFail($validated['property_id']);

        $validated['landlord_id'] = $property->user_id;
        $validated['status'] = 'pending';

        $agreement = RentalAgreement::create($validated);

        Notification::create([
            'user_id' => $validated['tenant_id'],
            'title' => 'New Rental Agreement',
            'message' => "A rental agreement has been created for '{$property->title}'.",
            'type' => 'rental',
            'data' => ['rental_agreement_id' => $agreement->id],
        ]);

        return response()->json($agreement->load(['property', 'tenant', 'landlord']), 201);
    }

    public function show(Request $request, RentalAgreement $rentalAgreement)
    {
        return response()->json($rentalAgreement->load(['property', 'tenant', 'landlord']));
    }

    public function update(Request $request, RentalAgreement $rentalAgreement)
    {

        $validated = $request->validate([
            'start_date' => ['sometimes', 'date'],
            'end_date' => ['sometimes', 'date', 'after:start_date'],
            'monthly_rent' => ['sometimes', 'numeric', 'min:0'],
            'deposit' => ['nullable', 'numeric', 'min:0'],
            'status' => ['sometimes', 'in:pending,active,expired,terminated'],
            'terms' => ['nullable', 'string'],
        ]);

        $rentalAgreement->update($validated);

        if (isset($validated['status'])) {
            Notification::create([
                'user_id' => $rentalAgreement->tenant_id,
                'title' => 'Rental Agreement Updated',
                'message' => "Your rental agreement status has been changed to '{$validated['status']}'.",
                'type' => 'rental',
                'data' => ['rental_agreement_id' => $rentalAgreement->id],
            ]);
        }

        return response()->json($rentalAgreement->load(['property', 'tenant', 'landlord']));
    }

    public function destroy(Request $request, RentalAgreement $rentalAgreement)
    {
        $rentalAgreement->delete();

        return response()->json(['message' => 'Rental agreement deleted successfully.']);
    }
}
