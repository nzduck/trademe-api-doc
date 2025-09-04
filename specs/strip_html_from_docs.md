## Main actions

1. Remove everything from the html document EXCEPT for the contents of the <section> element.
2. Remove the `<div class="xml-message">` element and its contents.
3. Remove the `<ul class="breadcrumbs">` element and its contents.
4. Remove the `<a class="switch-to-xml-link" href="#">(switch to XML)</a>` text.

## Other actions

1. Create the url for the original source of the document. This should be in the following format: {domain}/api-reference/{folder}/{filename} where:

- {domain} is 'https://developer.trademe.co.nz'
- {folder} is the name of the folder containing the file being processed e.g. 'address-methods' or 'branding-methods'
- {filename} is the name of the file being processes with '.html' removed e.g. 'search-by-address.html' becomes 'search-by-address'

2. Add the url created in the previous step as an html comment to the top of the file. The comment should be in the following format: `<!-- Source: {url} -->`.

3. Look for an instance of text surrounded by nested '<p>' elements like this `<p> <p>The details of the Buy Now request.</p> </p>`. Keep the text and the inner set of <p> elements, and remove the outer set of '<p>' elements. e.g. `<p> <p>The details of the Buy Now request.</p> </p>` should become `<p>The details of the Buy Now request.</p>`.
