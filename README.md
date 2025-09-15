# Trade Me API Documentation

Documentation for Trade Me's API in OpenAPI format, both individual files and transformable into a single consolidated file. Also, a few simple tools and workflows for extracting and processing Trade Me's API documentation from the official Trade Me developer site.

## Overview

**OpenAPI Implementation**: The repository includes an incomplete OpenAPI 3.1 specification with:

- **5 endpoint paths**: Listings, Categories, Search (General & Suggestions), and Watchlist operations
- **44 schema components**: Complex data structures including Listing details, Search results, and Category definitions
- **4 path modules**: Organized endpoint definitions with full parameter and response specifications
- **Authentication models**: OAuth 1.0a configuration for Trade Me API access
- **Interactive documentation**: Swagger UI integration for testing and exploration

## Dataset Structure (data/)

### Raw Data

- **`data/downloaded-specs/`** - Original HTML documentation files from Trade Me developer portal as at September 2025. Downloaded with `curl` - see **`scripts/download-trademe-docs.sh`**
- **`data/stripped-specs/`** - HTML files with cleaned formatting (removed navigation, ads, etc.) used prior to formatting in OpenAPI specification. See **`specs/strip-html-from-docs.md`** for a helpful Claude context prompt to help transform downloaded-specs (**`data/downloaded-specs/`**) into stripped 'specs' (**`data/stripped-specs`**)
- **`data/trademe-api-downloaded-specs-20250902.tar.gz`** - Compressed backup of original files

### Processed Data

- **`data/json-doc/`** - Structured JSON specifications for 265 active endpoints (deprecated endpoints excluded)

## Scripts and Specs

### Scripts

- **`scripts/download-trademe-docs.sh`** - Script to download official Trade Me API developer documentation
- **`scripts/generate-openapi-schemas.js`** - Sample script to generate OpenAPI schemas for endpoint **`data/json-doc/listing-methods/retrieve-the-details-of-a-single-listing.json`**
- **`scripts/browse-api.sh`** - Generates a single consolidated yaml file in OpenAPI 3.1 specification format using Redocly and opens this local file for browsing using Docker/Swagger
- **`scripts/stop-api-server.sh`** - Stops the local Docker web server if still running

### Specs

- **`specs/json-extraction-guide.md`** - Complete schema and extraction methodology
- **`specs/generate-doc.md`** - Documentation generation workflow
- **`specs/strip-html-from-docs.md`** - HTML cleaning process

## Purpose

This project provides an example of a simple, clean OpenAPI-based structure to represent the documentation of Trade Me's API.

## API Coverage

The project includes comprehensive extraction of 265 active Trade Me API endpoints with complete JSON documentation. A compartmentalized OpenAPI structure exists under openapi/api.yaml (5 sample endpoints) along with a single consolidated file at openapi/openapi-consolidated.yaml.

Note that deprecated endpoints have been intentionally excluded from the dataset.

## Using the Dataset

### Browsing the Consolidated OpenAPI Specification (Swagger)

The repository includes a functional OpenAPI 3.1 specification for 5 endpoints and 44 schema components:

**Quick Start:**

```bash
# Generate consolidated spec, start server, and open in browser
./scripts/browse-api.sh
```

**Manual Steps:**

```bash
# Generate consolidated OpenAPI specification
redocly bundle openapi/api.yaml --output openapi/openapi-consolidated.yaml --force

# View in Swagger UI
docker run -d -p 5353:8080 --name trademe-api-docs --rm \
  -e SWAGGER_JSON=/openapi/openapi-consolidated.yaml \
  -v "$(pwd)/openapi:/openapi" swaggerapi/swagger-ui

# Stop server: docker stop trademe-api-docs
```

**Prerequisites:** Redocly CLI (`npm install -g @redocly/cli`) and Docker

## Use Cases

- **API Documentation Projects** - Foundation for comprehensive API documentation efforts
- **Extraction Methodology** - Beginner workflows for HTML-to-structured-data conversion
- **OpenAPI Development** - Sample specifications and generation workflows
- **API Analysis** - Study API design patterns and documentation structures
- **Development Tools** - Scripts and processes for API documentation automation

## Data Sources

All content was extracted from the official Trade Me Developer Documentation:

- **Source**: [developer.trademe.co.nz](https://developer.trademe.co.nz/)
- **Extraction Date**: September 2025
- **Coverage**: 265 active API endpoints (deprecated endpoints excluded)

The processing maintained complete traceability - each endpoint specification includes the original source URL.

## License & Usage

This dataset is provided for reference, analysis, and development purposes. The underlying Trade Me API is subject to Trade Me's terms of service and API agreements. Users should:

1. Verify endpoint details against the official Trade Me sandbox API
2. Comply with Trade Me's API usage policies and rate limits
3. Implement proper OAuth authentication for protected endpoints
4. Test thoroughly before production use

---

**Project Status**: Comprehensive JSON extraction complete (265 active endpoints), sample OpenAPI implementation (5 endpoints)  
**Source**: Trade Me Developer Documentation  
**Processing**: Automated extraction with manual validation  
**Next Steps**: Scale OpenAPI transformation to remaining 260 endpoints
