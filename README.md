# Trade Me API Documentation Dataset

This repository contains a comprehensive dataset of Trade Me API documentation, extracted and processed from the official Trade Me developer documentation.

## Overview

This dataset provides clean, structured documentation for all 274 Trade Me API endpoints across all categories. The data has been extracted from HTML documentation, cleaned, and transformed into structured JSON format suitable for analysis, documentation generation, or API client development.

## Dataset Structure

### Raw Data
- **`data/downloaded-specs/`** - Original HTML documentation files from Trade Me developer portal
- **`data/stripped-specs/`** - HTML files with cleaned formatting (removed navigation, ads, etc.)

### Processed Data  
- **`data/json-doc/`** - Structured JSON specifications for all 274 endpoints
- **`data/trademe-api-downloaded-specs-20250902.tar.gz`** - Compressed backup of original files

### Documentation
- **`docs/endpoints/`** - Generated endpoint documentation in markdown format

### Processing Guides
- **`specs/json-extraction-guide.md`** - Complete schema and extraction methodology
- **`specs/generate-doc.md`** - Documentation generation workflow
- **`specs/strip_html_from_docs.md`** - HTML cleaning process

## API Coverage

The dataset includes complete documentation for all major Trade Me API categories:

### Core Marketplace APIs
- **Listing Methods** - View, search, and interact with marketplace listings
- **Search Methods** - Search across categories with filters and sorting
- **Catalogue Methods** - Browse categories and public reference data
- **Bidding Methods** - Place bids and manage auction interactions

### User Account APIs  
- **My Trade Me Methods** - Account summary, selling/bidding items, watchlists
- **Membership Methods** - View member profiles and feedback
- **OAuth Methods** - Authentication token management

### Specialized APIs
- **Property Methods** - Real estate listings, agents, and sold data
- **Job Methods** - Job listings, companies, and applications
- **Photo Methods** - Image upload and management

## Authentication

Trade Me API uses **OAuth 1.0a** for authentication. Most endpoints require proper OAuth signatures, except for public catalog data.

### Servers
- **Production**: `https://api.trademe.co.nz/v1`
- **Sandbox**: `https://api.tmsandbox.co.nz/v1`

## Sample Endpoints

Here are some key endpoints included in the dataset:

| Endpoint | Method | Description | Auth Required |
|----------|--------|-------------|---------------|
| `/Listings/{id}` | GET | Get listing details | Yes |
| `/Search/General` | GET | Search marketplace | No |
| `/Categories` | GET | Get category tree | No |
| `/MyTradeMe/Summary` | GET | Account summary | Yes |
| `/OAuth/RequestToken` | POST | Get OAuth token | No |
| `/Listings/{id}/bids` | POST | Place a bid | Yes |
| `/Listings/{id}/questions` | GET/POST | Listing Q&A | Yes |

## Using the Dataset

### Explore the Data
```bash
# View available API categories
ls data/json-doc/

# Count total endpoints
find data/json-doc -name "*.json" | wc -l

# View a specific endpoint
cat data/json-doc/catalogue-methods/GetCategory.json

# Search for endpoints by name
grep -r "ListingDetail" data/json-doc/
```

### Generate Documentation
```bash
# View processing methodology
cat specs/json-extraction-guide.md

# Check generated documentation
ls docs/endpoints/
```

### Generate Interactive OpenAPI Documentation
The repository includes OpenAPI 3.1 specifications that can be bundled into a consolidated documentation and viewed with Swagger UI:

```bash
# Generate consolidated OpenAPI spec and start documentation server
./scripts/gen-consolidated-doc.sh
```

This will:
1. Bundle all OpenAPI specs into a single consolidated file using Redocly
2. Start a Docker container with Swagger UI 
3. Make the documentation available at http://localhost:8080

**Prerequisites:**
- [Redocly CLI](https://redocly.com/docs/cli/installation/) installed: `npm install -g @redocly/cli`
- Docker installed and running

**Manual steps (if you prefer):**
```bash
# Generate consolidated spec
redocly bundle openapi/api.yaml --output openapi/openapi-consolidated.yaml --force

# Start documentation server
docker run -p 8080:8080 \
  -e SWAGGER_JSON=/openapi/openapi-consolidated.yaml \
  -v "$(pwd)/openapi:/openapi" \
  swaggerapi/swagger-ui
```

## Data Quality & Characteristics

### What's Included
- **Complete endpoint coverage** - All 274 documented Trade Me API endpoints
- **Structured parameters** - All path and query parameters with types and descriptions
- **Response schemas** - Return types and field definitions
- **Authentication info** - OAuth requirements and permissions for each endpoint  
- **Code examples** - Request/response samples where available
- **Source tracking** - Original documentation URLs preserved

### Use Cases
- **API Client Development** - Generate client libraries from structured specifications
- **Documentation Generation** - Create comprehensive API documentation
- **API Analysis** - Study API design patterns and endpoint relationships
- **Testing & Validation** - Build test suites and validation tools
- **OpenAPI Generation** - Convert to OpenAPI 3.1 specifications

## Data Sources

All content was extracted from the official Trade Me Developer Documentation:
- **Source**: [developer.trademe.co.nz](https://developer.trademe.co.nz/)
- **Extraction Date**: September 2025
- **Coverage**: All publicly documented API endpoints and methods

The processing maintained complete traceability - each endpoint specification includes the original source URL.

## License & Usage

This dataset is provided for reference, analysis, and development purposes. The underlying Trade Me API is subject to Trade Me's terms of service and API agreements. Users should:

1. Verify endpoint details against the official Trade Me sandbox API
2. Comply with Trade Me's API usage policies and rate limits  
3. Implement proper OAuth authentication for protected endpoints
4. Test thoroughly before production use

---

**Dataset Version**: 2025-09-02  
**Source**: Trade Me Developer Documentation  
**Processing**: Automated extraction with manual validation