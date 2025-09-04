# JSON Extraction Guide for Abbreviated API HTML (No `<section>` Wrapper)

This guide explains how to turn your abbreviated HTML pages (like the examples you shared) into a **consistent JSON format**. It covers GET/POST endpoints, URL and query parameters, `POST Data` sections, **Returns** sections with **multiple tables**, **data attributes**, and **nested tables** that should be attached to the **preceding row**.

> **Scope**: Your HTML fragments **do not** include a `<section>` wrapper. Operate on the entire fragment.  
> **Filenames**: **Process in-place**. Do **not** rename files or change file locations during processing.

---

## Target JSON Shape (Field Order)

```json
{
  "endpoint": "UpperCamelCaseFromTitle",
  "title": "Exact page <h1> text",
  "description": "First paragraph after <h1>",
  "source": "https://original-doc-url",
  "url": "https://…/{path}.{file_format}",
  "method": "GET|POST|…",
  "authentication_required": true,
  "permission_required": null,
  "rate_limited": true,
  "supported_formats": ["XML", "JSON"],
  "parameters": {
    "path": [
      /* param rows (see schema below) */
    ],
    "query": [
      /* param rows */
    ]
  },
  "request_body": {
    "type": "<Type>",
    "fields": [
      /* field rows */
    ]
  },
  "returns": {
    "type": "<Type>",
    "description": "…",
    "fields": [
      /* field rows */
    ]
  },
  "examples": {
    "request_json": {
      /* parsed JSON if present */
    },
    "response_json": {
      /* parsed JSON if present */
    }
  }
}
```

### Param / Field Row Schema (Used in `parameters.*`, `request_body.fields`, `returns.fields`)

```json
{
  "name": "FieldOrParamName",
  "type": "Type text as shown (e.g., Integer, Enumeration (required), <SomeType>)",
  "required": true,
  "description": "Human description text",
  "enum": [
    {
      "name": "json",
      "value": "json",
      "description": "Serialize responses into JSON."
    }
  ],
  "nested_fields": [
    {
      "name": "Latitude",
      "type": "Number",
      "description": "Latitude"
    }
  ]
}
```

> `enum` and `nested_fields` are optional; include them **only when present**.

---

## Step-by-Step Extraction

1. **Record the Source URL**

   - Read the first HTML comment at the top, e.g. `<!-- Source: https://… -->`.
   - Save the URL string to `source`. If missing, use `null`.

2. **Locate Title & Description**

   - `title` = text of the **first `<h1>`**.
   - `description` = text of the **first `<p>` immediately following** that `<h1>` (ignore whitespace-only nodes).

3. **Parse Core Metadata Table (First Table After Description)**
   For each table row `<tr>`, map `<th>` → label and the first `<td>` → value:

   - **URL** → `url`
   - **HTTP Method** → `method`
   - **Requires Authentication?** (“Yes/No”) → `authentication_required` (true/false)
   - **Permission Required** (`None` → null; otherwise string) → `permission_required`
   - **Supported Formats** (split by comma, trim) → `supported_formats` (array)
   - **Rate Limited?** (“Yes/No”) → `rate_limited` (true/false)

4. **URL / Path Parameters (`<table id="url_parameters">`)**

   - If absent, set `parameters.path = []`.
   - For each `<tr>`:
     - `name` = `<th>` text
     - `type` = **first** `<td>` text (e.g., `Enumeration (required)`)
     - `required` = **true** if `(required)` appears in `type` (case-insensitive), else **false**
     - `description` = **second** `<td>` text (if missing, `null`)
     - If `<tr>` has `data-enum-values='[...]'`: parse JSON → `enum` (array of `{name, value, description}`).
     - If `<tr>` has `data-nested-fields='[...]'`: parse JSON → `nested_fields` (array of `{field_name, field_type, description}`).
   - Append each row object to `parameters.path`.

5. **Query String Parameters (`<table id="querystring_parameters">`)**

   - If absent, set `parameters.query = []`.
   - Parse rows using **the same rules** as Step 4 and append to `parameters.query`.

6. **Ensure URL Placeholders Are Present**

   - From `url`, extract `{placeholders}` (e.g., `{listingId}`, `{file_format}`).
   - If any placeholder is **not** in `parameters.path`, append a minimal path param:
     ```json
     {
       "name": "placeholderName",
       "type": "path",
       "required": true,
       "description": null
     }
     ```

7. **POST Body (If Present)**

   - Find an `<h2>` with text **“POST Data”** (case-insensitive). If not found → `request_body = null`.
   - If found:
     - `request_body.type` = text of the **first `<p>`** after the header (verbatim; may look like `&lt;BidRequest&gt;`).
     - Parse **all consecutive `<table>`s** after this header **until the next `<h2>`** as field rows using the **row schema** from Step 4.
     - Store rows under `request_body.fields`.

8. **Returns Section**

   - Find an `<h2>` with text **“Returns”** (case-insensitive). If not found →
     ```json
     "returns": { "type": null, "description": null, "fields": [] }
     ```
   - If found:
     - **Type**: the first `<p>` _after the header_ that looks like an angled type (often starts with `&lt;`), e.g., `&lt;ListedItemDetail&gt;`. Store verbatim in `returns.type`.
     - **Description**: concatenate any additional `<p>` elements that follow (until a `<table>` or the next `<h2>`), separated by single spaces; trim. If none, `null`.
     - **Fields**: parse **all consecutive `<table>`s** after the header **until the next `<h2>`** using the **row schema** from Step 4. Append all rows to `returns.fields`.

9. **Examples (Optional)**

   - If example blocks exist (e.g., “Example JSON Request/Response”) and a `<pre><code>` contains JSON:
     - Try to parse as JSON; on success, set `examples.request_json` / `examples.response_json`.
     - If parsing fails, store the raw string.
   - If no examples: `examples = null`.

10. **Create `endpoint` & Keep Filename In-Place**

    - `endpoint` = title converted to **UpperCamelCase**, stripping non-alphanumeric characters (e.g., `Place a bid` → `PlaceABid`).
    - **Do not** rename or move the source file; write the generated JSON over the top of the source file location without changing the original filename.

11. **Normalize & Tidy**

    - Trim whitespace on strings.
    - Convert “Yes/No” → true/false.
    - Convert literal “None” → `null`.
    - Leave `type` strings as seen (you may normalize in a later pass).
    - Absent sections → `parameters.path = []`, `parameters.query = []`, `request_body = null`, `returns.fields = []`, `examples = null`.

12. **Final JSON Assembly (Field Order Matters)**

    1. `endpoint`, `title`, `description`, `source`
    2. `url`, `method`, `authentication_required`, `permission_required`, `rate_limited`, `supported_formats`
    3. `parameters` (with `path`, `query`)
    4. `request_body`
    5. `returns`
    6. `examples`

13. **Quick QA Checklist**
    - ✅ `title`, `description`, `source` present
    - ✅ URL/method/auth/permission/formats/rate parsed
    - ✅ `parameters.path` and `parameters.query` arrays exist
    - ✅ URL placeholders present in `parameters.path`
    - ✅ `request_body` null or object with `type`/`fields`
    - ✅ `returns` has `type` (if present), optional `description`, and `fields`
    - ✅ `examples` null or has request/response JSON/raw

---

## Special Handling for **Nested Tables** in the **Returns** Area

Some pages include **nested tables** directly under a specific field row within **Returns**. These nested tables either:

1. **Define the object type** returned by the **preceding field row** (sub-fields of that object).
2. **Define an enumeration** of valid values for the **preceding field row**.

### How to Detect & Attach Nested Tables

- While iterating **Returns** tables and rows:
  1. Parse the current `<tr>` into a field object (row schema).
  2. **Peek ahead** at the immediate siblings of this `<tr>`:
     - If the **next sibling is a `<table>`** (and not a new top-level Returns table), treat it as a **nested table belonging to the current field**.
     - Consume **all such consecutive nested tables** until you reach the next `<tr>`, a new parent `<table>`, or the next `<h2>`.

#### Case A — Nested **Object Definition**

- **Meaning**: The nested table lists sub-fields (name/type/description) for the current field’s object.
- **Action**: Parse rows using the **row schema** and attach them to the parent field as:
  ```json
  "nested_fields": [
    { "name": "SubFieldName", "type": "Type", "description": "…" }
  ]
  ```

#### Case B — Nested **Enumeration Values**

- **Meaning**: The nested table enumerates valid values (and their semantics) for the current field.
- **Action**: Map each nested row to an enum entry and attach as:
  ```json
  "enum": [
    { "name": "ValueName", "value": "RawValueIfPresent", "description": "Meaning of the value" }
  ]
  ```
  - If only display names are present, set both `name` and `value` to that string.

> **Prefer structured hints**: When a `<tr>` includes `data-enum-values` or `data-nested-fields`, use those first. Treat nested tables as a fallback when attributes are missing.

### Mini Examples

**Nested Object**

```json
{
  "name": "Dimensions",
  "type": "<Dimensions> or null",
  "required": false,
  "description": "Package dimensions.",
  "nested_fields": [
    { "name": "Height", "type": "Number", "description": "cm" },
    { "name": "Width", "type": "Number", "description": "cm" },
    { "name": "Depth", "type": "Number", "description": "cm" }
  ]
}
```

**Nested Enum**

```json
{
  "name": "ReserveState",
  "type": "Enumeration",
  "required": false,
  "description": "The reserve status.",
  "enum": [
    { "name": "None", "value": "0", "description": "No reserve." },
    { "name": "Met", "value": "1", "description": "Bid >= reserve." },
    { "name": "NotMet", "value": "2", "description": "Bid < reserve." }
  ]
}
```

---

## Batch Workflow (Folder of Files)

1. Iterate all `.html` files in the target folder.
2. Apply the **Step-by-Step Extraction** to each file.
3. Write JSON outputs to your designated output directory; **do not modify** the original filenames or locations of the HTML sources.
4. (Optional) Build an `index.json` for quick browsing.
5. Use the **QA Checklist** on a representative sample; fix any flagged files.

---

## Final Notes

- Keep outputs **consistent** with the field order above.
- **Don’t invent data**; use `null` or empty arrays when a section is absent.
- Log any ambiguities (e.g., nested table ownership) for manual review.
