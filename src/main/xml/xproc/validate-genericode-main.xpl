<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:gv="urn:uuid:54458f97-a354-46fe-b0ec-6d7a009d0e7a"
    name="create-validation-reports"
    version="3.1">

    <p:documentation>This step is the primary entry point to genericode-validator.
        It validates one or more genericode documents,
        provided via a file or
        directory path, against
        (1) the genericode XML schema,
        (2) the genericode document rules
        and (3) additional rules defined by KDS.
        For each
        genericode document, an overall HTML validation report is created and stored in the specified output directory.

        This step assumes that genericode files have extension .gc.
    </p:documentation>

    <p:import href="validate-genericode-html.xpl" />

    <p:option
        name="input-path"
        required="true" />

    <p:option
        name="output-directory"
        required="true" />

    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />

    <!-- E.g.:
        C:\path\to\codelist.gc
        C:\path\to\input-directory
	    https://example.org/codelist.gc
        -->
    <p:variable
        name="input-path-urified"
        select="p:urify($input-path)" />

    <!-- E.g. C:\path\to\output-directory -->
    <p:variable
        name="output-directory-urified"
        select="p:urify($output-directory)" />


    <p:choose name="get-file-metadata">
        <p:when test="starts-with($input-path-urified, 'file:')">
        
            <p:output
                port="result"
                primary="true"
                content-types="xml"
                sequence="true" />

            <p:file-info
                name="file-info-input-path-urified"
                message="Retrieve info about {$input-path-urified}"
                href="{$input-path-urified}" />

            <p:choose name="retrieve-file-info-gc-files">
                <p:when test="exists(/c:directory)">
                
                    <p:output
                        port="result"
                        primary="true"
                        content-types="xml"
                        sequence="true" />

                    <p:directory-list
                        name="directory-list"
                        message="Retrieve list of genericode files in directory {$input-path-urified}">
                        <p:with-option
                            name="path"
                            select="$input-path-urified" />
                        <p:with-option
                            name="max-depth"
                            select="'unbounded'" />
                        <p:with-option
                            name="include-filter"
                            select="'\.gc$'" />
                    </p:directory-list>

                    <p:for-each>
                        <p:with-input select="//c:file" />
                        <p:identity />
                    </p:for-each>
                </p:when>

                <p:when test="exists(/c:file)">
                    <p:output
                        port="result"
                        primary="true"
                        content-types="xml"
                        sequence="false" />

                    <p:identity message="Pass info about file {$input-path-urified}" />
                </p:when>

                <p:otherwise>
                    <p:output
                        port="result"
                        primary="true"
                        content-types="xml"
                        sequence="true">
                        <p:empty />
                    </p:output>

                    <p:sink message="Discard special object {$input-path-urified}" />
                </p:otherwise>
            </p:choose>
        </p:when>

        <!-- p:info is not guaranteed to be supported by a conformant processor for URIs whose scheme is not file.
        Therefore, construct a document containing a c:file element in this subpipeline. -->
        <p:when test="starts-with($input-path-urified, 'http') and ends-with($input-path-urified, '.gc')">
            <p:output
                port="result"
                primary="true"
                content-types="xml"
                sequence="false" />

            <p:identity
                name="file-info-http-input-path-urified"
                message="Construct info about {$input-path-urified}">
                <p:with-input port="source">
                    <p:inline
                        document-properties="map {'base-uri': $input-path-urified }"
                        exclude-inline-prefixes="#all">
                        <c:file
                            name="{replace($input-path-urified, '.*/([^/]+\.gc)$', '$1')}" />
                    </p:inline>
                </p:with-input>
            </p:identity>
            
            <!-- xml:base cannot specified by means of an attribute value template in an p:inline,
            see also https://github.com/xproc/3.0-specification/issues/1129 -->
            <p:add-attribute
                name="add-xml-base"
                attribute-name="xml:base"
                attribute-value="{$input-path-urified}" />
        </p:when>

        <!-- Otherwise: do nothing -->

    </p:choose>

    <p:group name="load-validate-store">

        <p:for-each>
            <p:with-input select="/c:file" />

            <p:store
                name="store-file-metadata"
                message="Store file metadata for debugging"
                href="{'../../../../target/store-file-metadata-' || format-time(current-time(),'[H01][m01][s01][f001]') || '.xml'}"
                serialization="map { 'indent': true() }"
                use-when="$debug" />
                
            <p:variable
                name="base-uri-gc"
                select="base-uri(.)" />

            <p:variable
                name="name-gc"
                select="c:file/@name" />
        
            <!-- Explicitly provide content-type: genericode files on the internet
            are not always provided with the application/xml content type, it can e.g. be
             'application/octet-stream'. Files with that content type will give errors
             in steps that require XML content to be provided. -->
            <p:load
                name="load-gc-file"
                message="Load {$base-uri-gc}"
                href="{$base-uri-gc}"
                content-type="application/xml" />

            <gv:validate-genericode-html
                name="validate-genericode-html"
                p:message="Validate and create HTML validation report for {$base-uri-gc}">
                <p:with-option
                    name="assert-valid"
                    select="false()" />
            </gv:validate-genericode-html>

            <p:variable
                name="report-path"
                select="$output-directory-urified || '/' || replace($name-gc, '(.+)\.gc$', '$1' || '-report.html')" />
                
            <p:store
                name="store-report"
                message="Store HTML validation report for {$name-gc} in {$report-path}"
                href="{$report-path}">
                <p:with-input port="source">
                    <p:pipe
                        step="validate-genericode-html"
                        port="report" />
                </p:with-input>
            </p:store>

        </p:for-each>

    </p:group>

</p:declare-step>