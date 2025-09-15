# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains downloaded, parsed, and transformed documentation for the Trade Me API, extracted from the official Trade Me developer documentation. It includes comprehensive extraction of active endpoints and serves as a foundation for API analysis and documentation generation.

## Project Architecture

### Data Processing Pipeline
The repository contains the results of a multi-stage data processing pipeline:

1. **HTML Download & Scraping** - Downloaded Trade Me API documentation pages (274 files)
2. **HTML to JSON Conversion** - Converted active endpoint docs to structured JSON using extraction guide (265 endpoints, deprecated excluded)
3. **Data Cleaning & Validation** - Applied data cleaning and normalization
4. **OpenAPI Transformation** - Sample implementation with 5 endpoints demonstrating methodology

### Directory Structure

```
/data/
├── downloaded-specs/  # Original HTML documentation files
├── stripped-specs/    # HTML files with clean formatting
└── json-doc/          # Processed JSON specifications (265 active endpoints)
/docs/
└── endpoints/         # Generated endpoint documentation
/specs/                # Processing guides and documentation
├── json-extraction-guide.md
├── generate-doc.md
└── strip-html-from-docs.md
```

### Key Components

- **Downloaded Specifications**: Original HTML documentation files from Trade Me developer portal (274 files)
- **Processed JSON Data**: Clean, structured JSON specifications for 265 active endpoints (deprecated endpoints excluded)
- **OpenAPI Implementation**: Sample implementation with 5 endpoints demonstrating transformation methodology
- **Processing Guides**: Documentation for data extraction and transformation workflows

## Working with the Data

### Exploring the Dataset
```bash
# View available endpoint categories
ls data/json-doc/

# Count total endpoints
find data/json-doc -name "*.json" | wc -l

# Search for specific endpoints
grep -r "ListingDetail" data/json-doc/

# View an endpoint specification
cat data/json-doc/catalogue-methods/GetCategory.json
```

### Documentation Generation
```bash
# View processing guides
cat specs/json-extraction-guide.md
cat specs/generate-doc.md

# Check endpoint documentation
ls docs/endpoints/
```

## Data Processing Architecture

### JSON Specification Format
All endpoint data follows a standardized JSON schema defined in `specs/json-extraction-guide.md`:

```json
{
  "endpoint": "UpperCamelCaseFromTitle",
  "title": "Exact page title",
  "description": "Endpoint description", 
  "source": "https://developer.trademe.co.nz/...",
  "url": "https://api.trademe.co.nz/v1/{path}.{file_format}",
  "method": "GET|POST|PUT|DELETE",
  "authentication_required": true|false,
  "permission_required": "string|null",
  "rate_limited": true|false,
  "supported_formats": ["XML", "JSON"],
  "parameters": {
    "path": [/* parameter objects */],
    "query": [/* parameter objects */]
  },
  "request_body": {
    "type": "<TypeName>",
    "fields": [/* field objects */]
  },
  "returns": {
    "type": "<ReturnType>",
    "description": "Response description",
    "fields": [/* response field objects */]
  },
  "examples": {
    "request_json": {},
    "response_json": {}
  }
}
```

### Field Schema for Parameters/Fields
```json
{
  "name": "FieldName",
  "type": "Type description", 
  "required": true|false,
  "description": "Field description",
  "enum": [/* optional enum values */],
  "nested_fields": [/* optional nested object fields */]
}
```

### Processing Workflow

The data in this repository was processed through these stages:
1. **HTML Extraction** - Downloaded 274 HTML documentation files and converted active endpoints to structured JSON (265 files, deprecated excluded)
2. **Data Cleaning** - Fixed formatting, removed duplicates, normalized types  
3. **Validation** - Ensured data completeness and consistency
4. **OpenAPI Transformation** - Sample implementation for 5 endpoints with complete methodology for scaling to remaining endpoints

## API Architecture

### Authentication & Servers
- **Production**: `https://api.trademe.co.nz/v1`
- **Sandbox**: `https://api.tmsandbox.co.nz/v1`
- **Authentication**: OAuth 1.0a (most endpoints require authentication)
- **Public Endpoints**: Categories, general search (no authentication required)

### Major API Categories
- **Listing Methods** - View, search, interact with marketplace listings
- **Search Methods** - Search with filters and sorting
- **Catalogue Methods** - Browse categories and reference data
- **Bidding Methods** - Place bids and manage auctions
- **My Trade Me Methods** - Account management, watchlists, selling items
- **Property/Jobs Methods** - Specialized endpoints for real estate and jobs
- **Photo Methods** - Image upload and management

## Development Guidelines

### Working with JSON Specifications
- All endpoint specifications are stored in `/data/json-doc/` organized by API category
- Follow the JSON schema defined in `specs/json-extraction-guide.md`
- All data includes source URLs for traceability back to original documentation
- Each endpoint includes structured parameters, responses, and examples

### Documentation Structure
- Original HTML files preserved in `/data/downloaded-specs/`
- Cleaned HTML files available in `/data/stripped-specs/`
- Structured JSON specifications in `/data/json-doc/`
- Generated endpoint documentation in `/docs/endpoints/`

### Data Quality
- 265 active endpoints across all Trade Me API categories (deprecated endpoints excluded)
- Complete parameter and response type information for all extracted endpoints
- Preserved authentication and permission requirements
- Includes code examples and usage patterns
- Sample OpenAPI implementation demonstrates transformation methodology

## Key Files for Reference

- `specs/json-extraction-guide.md` - Complete specification format guide and schema
- `specs/generate-doc.md` - Documentation generation workflow
- `specs/strip-html-from-docs.md` - HTML cleaning process documentation
- `data/json-doc/` - All processed endpoint specifications
- `docs/endpoints/` - Generated endpoint documentation