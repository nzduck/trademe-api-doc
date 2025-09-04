# Search for Listings

**Source:** [Trade Me API Reference - Search Methods](https://developer.trademe.co.nz/api-reference/search-methods)

## Overview

Search for marketplace listings across all Trade Me categories using various filters and criteria. This is the primary search endpoint that powers Trade Me's marketplace discovery.

## Authentication

- **Required:** None (public endpoint)
- **Scopes:** N/A

## Endpoint

```
GET /v1/Search/General
```

## Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `search_string` | string | No | - | Keywords to search for |
| `category` | string | No | - | Category number or path (e.g., "0001-0348-0357-") |
| `region` | integer | No | - | Region ID for location filtering |
| `price_min` | number | No | - | Minimum price filter in NZD |
| `price_max` | number | No | - | Maximum price filter in NZD |
| `buy_now` | boolean | No | false | Filter for Buy Now listings only |
| `pay_now` | boolean | No | false | Filter for Pay Now enabled listings |
| `condition` | string | No | - | Item condition (new, used) |
| `date_from` | string | No | - | Listing date filter (last_45_days, last_7_days, last_2_days, last_day) |
| `sort_order` | string | No | default | Sort order (default, alphabetical, price_asc, price_desc, expiry_asc, expiry_desc, featured_first) |
| `rows` | integer | No | 25 | Number of results per page (1-500) |
| `page` | integer | No | 1 | Page number for pagination |

## Request Examples

### Basic Search

```bash
curl -X GET "https://api.trademe.co.nz/v1/Search/General?search_string=iPhone&rows=10" \
  -H "Accept: application/json"
```

### Category Search with Filters

```bash
curl -X GET "https://api.trademe.co.nz/v1/Search/General?category=0001-0348-0357-&price_min=500&price_max=1500&buy_now=true" \
  -H "Accept: application/json"
```

### Location-based Search

```bash
curl -X GET "https://api.trademe.co.nz/v1/Search/General?search_string=bicycle&region=1&sort_order=price_asc" \
  -H "Accept: application/json"
```

## Response Schema

### 200 OK

```json
{
  "TotalCount": 1250,
  "Page": 1,
  "PageSize": 25,
  "List": [
    {
      "ListingId": 1234567890,
      "Title": "iPhone 14 Pro Max 256GB - Deep Purple",
      "Category": "0001-0348-0357-",
      "StartPrice": 1.00,
      "BuyNowPrice": 1200.00,
      "MaxBidAmount": 850.00,
      "StartDate": "2025-01-15T10:00:00Z",
      "EndDate": "2025-01-22T10:00:00Z",
      "Region": "Auckland",
      "Suburb": "Auckland Central",
      "HasGallery": true,
      "IsFeatured": false,
      "HasBuyNow": true
    }
  ]
}
```

### Key Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `TotalCount` | integer | Total matching listings across all pages |
| `Page` | integer | Current page number |
| `PageSize` | integer | Number of results on this page |
| `List` | array | Array of listing summaries |
| `List[].ListingId` | integer | Unique listing identifier |
| `List[].Title` | string | Listing title |
| `List[].Category` | string | Category path |
| `List[].StartPrice` | number | Starting bid price |
| `List[].BuyNowPrice` | number | Buy now price (if available) |
| `List[].MaxBidAmount` | number | Current highest bid |
| `List[].HasGallery` | boolean | Has photo gallery |
| `List[].IsFeatured` | boolean | Is a featured listing |
| `List[].HasBuyNow` | boolean | Has buy now option |

## Error Responses

### 400 Bad Request

```json
{
  "ErrorDescription": "Invalid search parameters provided.",
  "Request": "search_string=&price_min=-1"
}
```

## Common Errors

- **Invalid parameters**: Negative prices, invalid date formats, or out-of-range page numbers
- **Category not found**: Invalid category numbers return no results
- **Rate limiting**: Heavy usage may result in temporary throttling

## Gotchas

1. **Category Format**: Use Trade Me's hierarchical category format ("0001-0348-0357-")
2. **Price Precision**: Prices are in NZD; consider exchange rates for international users
3. **Pagination**: Large result sets require pagination; max 500 results per page
4. **Location IDs**: Region and district IDs are specific to New Zealand geography
5. **Date Filters**: Relative date filters (`last_7_days`) are more reliable than absolute dates
6. **Sort Performance**: Some sort orders may be slower on large result sets
7. **Featured Listings**: Featured listings appear at top regardless of sort order when `sort_order=featured_first`

## Advanced Usage

### Combining Filters

```bash
# Search for cars under $20K in Auckland with Buy Now
curl -X GET "https://api.trademe.co.nz/v1/Search/General?category=0268-&price_max=20000&region=1&buy_now=true&condition=used&sort_order=price_asc"
```

### Pagination

```bash
# Get second page of results
curl -X GET "https://api.trademe.co.nz/v1/Search/General?search_string=laptop&page=2&rows=50"
```

## See Also

- [Get Categories](./get-categories.md) - Browse category hierarchy
- [Get Listing by ID](./get-listing-by-id.md) - Get full listing details
- [Search Property](./search-property.md) - Property-specific search
- [Search Jobs](./search-jobs.md) - Job-specific search