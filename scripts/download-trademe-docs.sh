#!/bin/bash

# Trade Me API Documentation Download Script
# This script downloads HTML documentation from developer.trademe.co.nz
# Based on the existing file structure in data/downloaded-specs/

set -e

BASE_URL="https://developer.trademe.co.nz/api-reference"
OUTPUT_DIR="data/downloaded-specs"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Downloading Trade Me API documentation..."
echo "Base URL: $BASE_URL"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Function to download a page and save to appropriate directory
download_page() {
    local url="$1"
    local output_path="$2"
    local category_dir=$(dirname "$output_path")
    
    # Create category directory if it doesn't exist
    mkdir -p "$OUTPUT_DIR/$category_dir"
    
    echo "Downloading: $url"
    echo "  -> $OUTPUT_DIR/$output_path"
    
    # Download with curl, following redirects and handling errors
    if curl -s -L -f "$url" -o "$OUTPUT_DIR/$output_path"; then
        echo "  ✓ Success"
    else
        echo "  ✗ Failed to download $url"
    fi
    
    # Small delay to be respectful to the server
    sleep 0.5
}

# Download pages based on existing file structure
# Note: These URLs are reconstructed from the JSON spec files and existing HTML structure

# Catalogue Methods
download_page "$BASE_URL/catalogue-methods/retrieve-general-categories" "catalogue-methods/retrieve-general-categories.html"
download_page "$BASE_URL/catalogue-methods/retrieve-general-categories-by-mcat-path" "catalogue-methods/retrieve-general-categories-by-mcat-path.html"
download_page "$BASE_URL/catalogue-methods/retrieve-jobs-categories" "catalogue-methods/retrieve-jobs-categories.html"
download_page "$BASE_URL/catalogue-methods/retrieve-category-tree-last-modification-date" "catalogue-methods/retrieve-category-tree-last-modification-date.html"

# Search Methods  
download_page "$BASE_URL/search-methods/general-search" "search-methods/general-search.html"
download_page "$BASE_URL/search-methods/get-search-suggestions" "search-methods/get-search-suggestions.html"
download_page "$BASE_URL/search-methods/used-motors-search" "search-methods/used-motors-search.html"
download_page "$BASE_URL/search-methods/residential-search" "search-methods/residential-search.html"
download_page "$BASE_URL/search-methods/rental-search" "search-methods/rental-search.html"
download_page "$BASE_URL/search-methods/jobs-search" "search-methods/jobs-search.html"

# Listing Methods
download_page "$BASE_URL/listing-methods/get-listing-by-id" "listing-methods/get-listing-by-id.html"
download_page "$BASE_URL/listing-methods/retrieve-hot-listings" "listing-methods/retrieve-hot-listings.html"
download_page "$BASE_URL/listing-methods/retrieve-latest-listings" "listing-methods/retrieve-latest-listings.html"
download_page "$BASE_URL/listing-methods/retrieve-closing-soon-listings" "listing-methods/retrieve-closing-soon-listings.html"
download_page "$BASE_URL/listing-methods/retrieve-one-dollar-listings" "listing-methods/retrieve-one-dollar-listings.html"

# My Trade Me Methods
download_page "$BASE_URL/my-trade-me-methods/retrieve-your-watchlist" "my-trade-me-methods/retrieve-your-watchlist.html"

# Favourite Methods
download_page "$BASE_URL/favourite-methods/retrieve-your-favourite-categories" "favourite-methods/retrieve-your-favourite-categories.html"
download_page "$BASE_URL/favourite-methods/retrieve-your-favourite-sellers" "favourite-methods/retrieve-your-favourite-sellers.html"
download_page "$BASE_URL/favourite-methods/save-a-search-category-or-seller-to-your-favourites" "favourite-methods/save-a-search-category-or-seller-to-your-favourites.html"
download_page "$BASE_URL/favourite-methods/save-a-seller-to-your-favourites" "favourite-methods/save-a-seller-to-your-favourites.html"
download_page "$BASE_URL/favourite-methods/update-a-saved-favourites-label" "favourite-methods/update-a-saved-favourites-label.html"

# Job Position Methods
download_page "$BASE_URL/job-position-methods/create-a-job-position" "job-position-methods/create-a-job-position.html"
download_page "$BASE_URL/job-position-methods/update-an-existing-job-position" "job-position-methods/update-an-existing-job-position.html"
download_page "$BASE_URL/job-position-methods/retrieve-positions-for-a-member" "job-position-methods/retrieve-positions-for-a-member.html"
download_page "$BASE_URL/job-position-methods/retrieve-a-position" "job-position-methods/retrieve-a-position.html"
download_page "$BASE_URL/job-position-methods/relist-or-list-similar-job-position" "job-position-methods/relist-or-list-similar-job-position.html"
download_page "$BASE_URL/job-position-methods/tracking-the-listing-process" "job-position-methods/tracking-the-listing-process.html"

# SEO Methods
download_page "$BASE_URL/seo-methods-for-dynamic-pages-directory/retrieves-jobs-dynamic-pages-directory" "seo-methods-for-dynamic-pages-directory/retrieves-jobs-dynamic-pages-directory.html"

echo ""
echo "Download complete!"
echo "Files saved to: $OUTPUT_DIR"
echo ""
echo "Note: This script contains a subset of endpoints. To download all 274 endpoints,"
echo "you would need to generate URLs for all JSON specs in data/json-doc/"