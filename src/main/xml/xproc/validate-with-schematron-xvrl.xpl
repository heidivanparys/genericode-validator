<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:gv="urn:uuid:54458f97-a354-46fe-b0ec-6d7a009d0e7a"
    type="gv:validate-with-schematron-xvrl"
    version="3.0">

    <p:documentation>This step applies Schematron processing to the source document
        and creates a XVRL report using the svrl2xvrl.xsl stylesheet in this code base
        instead of using the XVRL report generation functionality of the used XProc processor.
        The names of the ports and the options use the same naming conventions as used 
        in the XProc Validation steps specification.
    </p:documentation>
    
    <p:input
        port="source"
        primary="true"
        content-types="xml" />

    <p:input
        port="schema"
        primary="false"
        content-types="xml" />

    <p:output
        port="result"
        primary="true"
        content-types="xml">
        <p:pipe
            step="validate-with-schematron-svrl"
            port="result" />
    </p:output>

    <p:output
        port="report"
        primary="false"
        content-types="xml">
        <p:pipe
            step="svrl-2-xvrl"
            port="result" />
    </p:output>

    <p:option
        name="assert-valid"
        select="true()"
        as="xsd:boolean" />

    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />
        
    <p:variable
        name="base-uri-schema"
        select="base-uri(/)" >
        <p:pipe port="schema" />
    </p:variable>

    <p:validate-with-schematron
        name="validate-with-schematron-svrl"
        message="{'Validate with Schematron schema ' || $base-uri-schema || ' and create SVRL report'}">
        <p:with-input port="schema">
            <p:pipe port="schema" />
        </p:with-input>
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </p:validate-with-schematron>

    <p:store
        name="store-svrl-report"
        message="Store SVRL document for debugging"
        href="{'../../../../target/validate-with-schematron-svrl-' || format-time(current-time(),'[H01][m01][s01][f001]') || '.svrl'}"
        serialization="map { 'indent': true() }"
        use-when="$debug">
        <p:with-input port="source">
            <p:pipe
                step="validate-with-schematron-svrl"
                port="report" />
        </p:with-input>
    </p:store>

    <p:xslt
        name="svrl-2-xvrl"
        message="Transform SVRL report to XVRL report">
        <p:with-input port="source">
            <p:pipe
                step="validate-with-schematron-svrl"
                port="report" />
        </p:with-input>
        <p:with-input
            port="stylesheet"
            href="../xslt/svrl2xvrl.xsl" />
        <p:with-option
            name="parameters"
            select="map {'schema-uri' : $base-uri-schema }" />
    </p:xslt>

</p:declare-step>