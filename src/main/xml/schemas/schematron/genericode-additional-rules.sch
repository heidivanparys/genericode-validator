<?xml version="1.0" encoding="UTF-8"?>
<schema
    xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    queryBinding="xslt2">

    <ns
        prefix="dcterms"
        uri="http://purl.org/dc/terms/" />
    <ns
        prefix="gc"
        uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" />

    <pattern>
        <rule context="/">
            <!-- Other types of Genericode Document Types are column set documents and code list set documents,
            see also https://docs.oasis-open.org/codelist/genericode/v1.0/os/genericode-v1.0-os.html#S-GENERICODE-DOCUMENT-TYPES. -->
            <assert
                id="codelist"
                test="exists(gc:CodeList)">The document must be a code list document.</assert>
        </rule>
        <rule context="gc:CodeList">
            <!-- In the genericode specification, the Annotation is documented as "User annotation information".
            Here this element is described as containg "additional metadata", as the Identification element
            is described as "Identification and location information (metadata)". -->
            <assert
                id="codelist_additional_metadata"
                test="exists(Annotation/Description)">Additional metadata for the code list must be present.</assert>
            <assert
                id="codelist_language"
                test="count(Annotation/Description/dcterms:language) eq 1">The language of the code list must be present.</assert>
        </rule>
        <rule context="Version">
            <assert
                id="semver"
                test="matches(.,'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$')"
                diagnostics="nodeValue"
                see="https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string">The version must comply to the Semantic versioning specification.</assert>
        </rule>
    </pattern>

    <diagnostics>
        <diagnostic id="nodeValue">
            <value-of select="'Value in invalid node: ' || ." />
        </diagnostic>
    </diagnostics>

</schema>