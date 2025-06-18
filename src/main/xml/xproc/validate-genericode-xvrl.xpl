<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:gv="urn:uuid:54458f97-a354-46fe-b0ec-6d7a009d0e7a"
    type="gv:validate-genericode-xvrl"
    version="3.0">

    <p:documentation>This step validates a genericode document against
        (1) the genericode XML schema, (2) the genericode document rules
        and (3) additional rules defined by KDS,
        and creates one overall XVRL validation report.
        
        The output from this step is a copy of the input,
        the XVRL validation report appears on the report port.
    </p:documentation>

    <p:import href="validate-with-schematron-xvrl.xpl" />
    
    <p:input
        port="source"
        primary="true"
        content-types="xml" />

    <p:output
        port="result"
        primary="true"
        content-types="xml">
        <p:pipe
            step="create-copy-of-input"
            port="result" />
    </p:output>

    <p:output
        port="report"
        primary="false"
        content-types="xml">
        <p:pipe
            step="add-metadata"
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
        name="base-uri-source"
        select="base-uri(/)" />

    <p:identity
        name="create-copy-of-input" />

    <p:validate-with-xml-schema
        name="validate-genericode-xsd"
        message="Validate structure against the genericode XML schema">
        <p:with-input
            port="schema"
            href="../schemas/xsd/genericode.xsd" />
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </p:validate-with-xml-schema>

    <gv:validate-with-schematron-xvrl
        name="validate-genericode-document-rules"
        p:message="Validate document rules defined by the genericode specification">
        <p:with-input
            port="schema"
            href="../schemas/schematron/genericode-document-rules.sch" />
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </gv:validate-with-schematron-xvrl>

    <gv:validate-with-schematron-xvrl
        name="validate-genericode-additional-rules"
        p:message="Validate additional rules">
        <p:with-input
            port="schema"
            href="../schemas/schematron/genericode-additional-rules.sch" />
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </gv:validate-with-schematron-xvrl>

    <p:wrap-sequence
        name="collect-reports"
        message="Collect all validation reports">
        <p:with-input port="source">
            <p:pipe
                step="validate-genericode-xsd"
                port="report" />
            <p:pipe
                step="validate-genericode-document-rules"
                port="report" />
            <p:pipe
                step="validate-genericode-additional-rules"
                port="report" />
        </p:with-input>
        <p:with-option
            name="wrapper"
            select="QName('http://www.xproc.org/ns/xvrl', 'reports')" />
    </p:wrap-sequence>

    <p:xslt
        name="add-metadata"
        message="Add metadata about report generation">
        <p:with-input
            port="stylesheet"
            href="../xslt/add-metadata-to-xvrl-report.xsl" />
        <p:with-option
            name="parameters"
            select="map {'timestamp' : current-dateTime(), 'document' : $base-uri-source }" />
    </p:xslt>
    
</p:declare-step>