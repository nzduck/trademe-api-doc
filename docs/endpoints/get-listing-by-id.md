# Get Listing by ID

**Source:** [Trade Me API Reference - Retrieve the details of a single listing](https://developer.trademe.co.nz/api-reference/listing-methods/retrieve-the-details-of-a-single-listing)

## Overview

Retrieve comprehensive details for a specific marketplace listing using its unique identifier. This endpoint provides all available information about a listing including pricing, timing, seller details, photos, and metadata.

## Authentication

- **Required:** OAuth 1.0a
- **Scopes:** Read access to public listing data

## Endpoint

```
GET /v1/Listings/{id}
```

## Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | The unique identifier of the listing |

## Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `file_format` | string | No | json | Response format (json, xml) |

## Request Examples

### cURL

```bash
# Get listing details
curl -X GET "https://api.trademe.co.nz/v1/Listings/1234567890" \
  -H "Authorization: OAuth oauth_consumer_key=\"your_key\", oauth_token=\"your_token\", ..." \
  -H "Accept: application/json"
```

### HTTP

```http
GET /v1/Listings/1234567890 HTTP/1.1
Host: api.trademe.co.nz
Authorization: OAuth oauth_consumer_key="your_key", oauth_token="your_token", ...
Accept: application/json
```

## Response Schema

### 200 OK

```json
{
  "ListingId": 1234567890,
  "Title": "iPhone 14 Pro Max 256GB - Deep Purple",
  "Category": "0001-0348-0357-",
  "StartDate": "2025-01-15T10:00:00Z",
  "EndDate": "2025-01-22T10:00:00Z",
  "StartPrice": 1.00,
  "ReservePrice": 800.00,
  "BuyNowPrice": 1200.00,
  "MaxBidAmount": 850.00,
  "Member": {
    "MemberId": 98765,
    "Nickname": "TechSeller123"
  },
  "Photos": [
    {
      "Key": "12345",
      "FullSize": "https://images.trademe.co.nz/photoserver/full/12345.jpg",
      "Gallery": "https://images.trademe.co.nz/photoserver/gallery/12345.jpg"
    }
  ],
  "AsAt": "2025-01-20T14:30:00Z"
}
```

### Key Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `ListingId` | integer | Unique listing identifier |
| `Title` | string | Listing title/headline |
| `Category` | string | Category path in Trade Me hierarchy |
| `StartDate` | datetime | When the listing started |
| `EndDate` | datetime | When the listing ends/ended |
| `StartPrice` | number | Opening bid price in NZD |
| `ReservePrice` | number | Reserve price (if set) |
| `BuyNowPrice` | number | Buy now price (if available) |
| `MaxBidAmount` | number | Current highest bid |
| `Member` | object | Seller information |
| `Photos` | array | Listing photos in various sizes |
| `AsAt` | datetime | Data snapshot timestamp |

## Error Responses

### 404 Not Found

```json
{
  "ErrorDescription": "The listing could not be found.",
  "Request": "1234567890"
}
```

### 401 Unauthorized

```json
{
  "ErrorDescription": "OAuth authentication required.",
  "Request": "1234567890"
}
```

## Common Errors

- **Invalid listing ID**: Returns 404 if the listing doesn't exist or has been removed
- **Authentication failure**: Returns 401 if OAuth signature is invalid
- **Rate limiting**: Returns 429 if API rate limits are exceeded

## Gotchas

1. **Listing States**: Listings can be active, closed, or removed. Check `EndDate` and current time
2. **Price Fields**: Not all price fields are always present - check for null values
3. **Photos**: Photo URLs may expire; refresh if getting 404s on images
4. **Category Format**: Category strings use Trade Me's hierarchical numbering (e.g., "0001-0348-0357-")
5. **Member Privacy**: Some member details may be limited based on privacy settings

## See Also

- [Search for Listings](./search-general.md) - Find listings by criteria
- [Get Listing Questions](./get-listing-questions.md) - View Q&A for a listing
- [Get Listing Reviews](./get-listing-reviews.md) - View reviews for a listing
- [My Trade Me Summary](./get-my-trademe-summary.md) - Your account overview