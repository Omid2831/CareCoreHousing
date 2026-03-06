<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('properties', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('description');
            $table->string('address');
            $table->string('city');
            $table->string('country');
            $table->string('zip_code')->nullable();
            $table->enum('type', ['house', 'apartment', 'condo', 'townhouse', 'land', 'commercial', 'studenthouse'])->default('house');
            $table->enum('status', ['available', 'sold', 'rented', 'pending'])->default('available');
            $table->enum('listing_type', ['sale', 'rent']);
            $table->decimal('price', 10, 2);
            $table->integer('bedrooms')->nullable();
            $table->integer('bathrooms')->nullable();
            $table->integer('year_built')->nullable();
            $table->json('images')->nullable();           // array of image URLs
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // property owner/agent
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('properties');
    }
};
