<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:p1="urn:uuid:54458f97-a354-46fe-b0ec-6d7a009d0e7a"
    xmlns:p2="urn:uuid:5b27ab71-7824-48c1-a739-a5f6e0cea60f"
    type="p2:validate-genericode-xvrl"
    version="3.0">

    <p:documentation>This step validates a genericode document against
        (1) the genericode XML schema, (2) the genericode document rules
        and (3) additional rules defined by KDS,
        and creates one overall XVRL validation report.
    </p:documentation>

    <p:import href="validate-with-schematron-xvrl.xpl" />

    <p:input
        port="source"
        primary="true" />

    <p:output
        port="result"
        primary="true">
        <p:pipe
            step="create-copy-of-input"
            port="result" />
    </p:output>

    <p:output
        port="report"
        primary="false">
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

    <p:variable
        name="content-type-source"
        select="p:document-property(/, 'content-type')" />

    <p:identity
        name="create-copy-of-input"
        message="Create copy of input" />

    <p:if
        test="not($content-type-source eq 'application/xml') and starts-with(lower-case($base-uri-source), 'http')"
        message="Check if source should be retrieved via HTTP">

        <!-- If this is not done, the following error will be thrown by p:validate-with-xml-schema
        for .gc documents on e.g. GitHub:
        Document with mediatype 'application/octet-stream' is not accepted by port 'source'. -->
        <p:http-request message="{'Requesting resource via HTTP on URL ' || $base-uri-source}">
            <p:with-option
                name="href"
                select="$base-uri-source" />
            <p:with-option
                name="headers"
                select="map {'concent-type' : 'application/xml'}" />
            <p:with-option
                name="parameters"
                select="map {'override-content-type' : 'application/xml'}" />
        </p:http-request>

    </p:if>

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

    <p1:validate-with-schematron-xvrl
        name="validate-genericode-document-rules"
        p:message="Validate document rules defined by the genericode specification">
        <p:with-input
            port="schema"
            href="../schemas/schematron/genericode-document-rules.sch" />
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </p1:validate-with-schematron-xvrl>

    <p1:validate-with-schematron-xvrl
        name="validate-genericode-additional-rules"
        p:message="Validate additional rules">
        <p:with-input
            port="schema"
            href="../schemas/schematron/genericode-additional-rules.sch" />
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </p1:validate-with-schematron-xvrl>

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