#!/usr/bin/env node

/**
 * Trade Me JSON to OpenAPI Schema Generator
 * 
 * Converts Trade Me API JSON specifications to OpenAPI 3.1 component schemas
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

class OpenAPISchemaGenerator {
    constructor() {
        this.generatedSchemas = new Map();
        this.componentsDir = path.join(__dirname, '..', 'openapi', 'components', 'schemas');
        
        // Ensure components directory exists
        if (!fs.existsSync(this.componentsDir)) {
            fs.mkdirSync(this.componentsDir, { recursive: true });
        }
    }

    /**
     * Convert Trade Me field type to OpenAPI type
     */
    convertType(tradeMeType, fieldName = '') {
        if (!tradeMeType) return { type: 'string' };

        const typeStr = tradeMeType.toLowerCase();

        // Handle nullable types
        const isNullable = typeStr.includes(' or null');
        const baseType = typeStr.replace(' or null', '');

        let schema = {};

        // Basic type mappings
        if (baseType.includes('string')) {
            schema = { type: 'string' };
        } else if (baseType.includes('integer')) {
            schema = { type: 'integer' };
        } else if (baseType.includes('number') || baseType.includes('decimal')) {
            schema = { type: 'number' };
        } else if (baseType.includes('boolean')) {
            schema = { type: 'boolean' };
        } else if (baseType.includes('datetime')) {
            schema = { type: 'string', format: 'date-time' };
        } else if (baseType.includes('enumeration')) {
            schema = { type: 'string' }; // Will be enhanced with enum values
        } else if (baseType.startsWith('collection of')) {
            // Handle collections
            const itemType = this.extractCollectionType(baseType);
            schema = {
                type: 'array',
                items: this.convertType(itemType)
            };
        } else if (baseType.startsWith('<') && baseType.endsWith('>')) {
            // Handle object references like <Member>
            const refType = baseType.slice(1, -1);
            schema = { $ref: `#/components/schemas/${refType}` };
        } else {
            // Default to string for unknown types
            schema = { type: 'string' };
        }

        // Add nullable property if needed
        if (isNullable) {
            schema.nullable = true;
        }

        return schema;
    }

    /**
     * Extract type from collection syntax like "Collection of <Member>"
     */
    extractCollectionType(collectionType) {
        const match = collectionType.match(/collection of (.+)/i);
        return match ? match[1].trim() : 'string';
    }

    /**
     * Process enum values from field definition
     */
    processEnum(field) {
        if (!field.enum && !field.enum_values) return {};

        const enumList = field.enum || field.enum_values;
        const values = enumList.map(e => e.value || e.name);
        const descriptions = enumList.map(e => e.description || '');

        return {
            enum: values,
            'x-enum-descriptions': descriptions
        };
    }

    /**
     * Generate schema for nested fields
     */
    generateNestedSchema(fields, typeName) {
        if (!fields || fields.length === 0) return null;

        const properties = {};
        const required = [];

        for (const field of fields) {
            const fieldSchema = {
                ...this.convertType(field.field_type || field.type, field.field_name || field.name),
                description: field.description || ''
            };

            // Add enum values if present - check both enum and enum_values
            if (field.enum || field.enum_values) {
                const enumData = this.processEnum(field);
                Object.assign(fieldSchema, enumData);
                console.log(`Found enum for ${field.name}: ${JSON.stringify(enumData)}`);
            }

            // Handle nested fields recursively
            if (field.nested_fields) {
                const nestedTypeName = `${typeName}${field.field_name || field.name}`;
                const nestedSchema = this.generateNestedSchema(field.nested_fields, nestedTypeName);
                if (nestedSchema) {
                    this.generatedSchemas.set(nestedTypeName, nestedSchema);
                    fieldSchema.$ref = `#/components/schemas/${nestedTypeName}`;
                    delete fieldSchema.type; // Remove type when using $ref
                }
            }

            const fieldName = field.field_name || field.name;
            properties[fieldName] = fieldSchema;

            if (field.required) {
                required.push(fieldName);
            }
        }

        return {
            type: 'object',
            properties,
            ...(required.length > 0 && { required }),
            additionalProperties: true
        };
    }

    /**
     * Generate main schema from Trade Me JSON spec
     */
    generateSchema(jsonSpec) {
        const returns = jsonSpec.returns;
        if (!returns || !returns.fields) {
            throw new Error('No return fields found in JSON spec');
        }

        console.log(`Processing ${returns.fields.length} fields...`);

        const schema = this.generateNestedSchema(returns.fields, 'Listing');
        schema.description = returns.description || jsonSpec.description || 'Trade Me listing details';

        return schema;
    }

    /**
     * Write schema to YAML file
     */
    writeSchema(schemaName, schema) {
        const yamlContent = yaml.dump(schema, {
            indent: 2,
            lineWidth: -1,
            noRefs: true
        });

        const filePath = path.join(this.componentsDir, `${schemaName}.yaml`);
        fs.writeFileSync(filePath, yamlContent);
        console.log(`Generated: ${filePath}`);
    }

    /**
     * Main generation process
     */
    async generate(jsonFilePath) {
        console.log(`Reading JSON spec: ${jsonFilePath}`);
        
        const jsonContent = fs.readFileSync(jsonFilePath, 'utf8');
        const jsonSpec = JSON.parse(jsonContent);

        console.log(`Endpoint: ${jsonSpec.endpoint}`);
        console.log(`Description: ${jsonSpec.description}`);

        // Generate main schema
        const mainSchema = this.generateSchema(jsonSpec);
        this.writeSchema('Listing', mainSchema);

        // Write all generated nested schemas
        for (const [typeName, schema] of this.generatedSchemas) {
            this.writeSchema(typeName, schema);
        }

        console.log(`\nGenerated ${this.generatedSchemas.size + 1} schema files`);
        console.log(`Main schema: Listing.yaml`);
        console.log(`Nested schemas: ${Array.from(this.generatedSchemas.keys()).join(', ')}`);
    }
}

// Main execution
async function main() {
    const generator = new OpenAPISchemaGenerator();
    
    const jsonSpecPath = path.join(__dirname, '..', 'data', 'json-doc', 'listing-methods', 'retrieve-the-details-of-a-single-listing.json');
    
    try {
        await generator.generate(jsonSpecPath);
        console.log('\n✅ Schema generation completed successfully!');
    } catch (error) {
        console.error('❌ Error generating schemas:', error.message);
        process.exit(1);
    }
}

// Check if js-yaml is available
try {
    require.resolve('js-yaml');
} catch (error) {
    console.error('❌ js-yaml package not found. Please run: npm install js-yaml');
    process.exit(1);
}

if (require.main === module) {
    main();
}

module.exports = { OpenAPISchemaGenerator };