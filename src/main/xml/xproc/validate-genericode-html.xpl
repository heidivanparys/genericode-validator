<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:p2="urn:uuid:5b27ab71-7824-48c1-a739-a5f6e0cea60f"
    name="validate-genericode-html"
    version="3.0">

    <p:documentation>This step validates a genericode document against
        (1) the genericode XML schema, (2) the genericode document rules
        and (3) additional rules defined by KDS,
        and creates one overall HTML validation report.
    </p:documentation>

    <p:import href="validate-genericode-xvrl.xpl" />

    <p:input
        port="source"
        primary="true"
        content-types="xml" />

    <p:output
        port="result"
        primary="true"
        content-types="html">
    </p:output>

    <p:option
        name="assert-valid"
        select="false()"
        as="xsd:boolean" />

    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />

    <p2:validate-genericode-xvrl
        name="validate-genericode-xvrl"
        p:message="Validate genericode document and create XVRL report">
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </p2:validate-genericode-xvrl>

    <p:store
        name="store-xvrl-report"
        message="Store XVRL document for debugging"
        href="{'../../../../target/validate-genericode-html-store-xvrl-report-' || format-time(current-time(),'[H01][m01][s01][f001]') || '.xvrl'}"
        serialization="map { 'indent': true() }"
        use-when="$debug">
        <p:with-input port="source">
            <p:pipe
                step="validate-genericode-xvrl"
                port="report" />
        </p:with-input>
    </p:store>

    <p:xslt
        name="xvrl-2-html"
        message="Transform XVRL report to HTML report">
        <p:with-input port="source">
            <p:pipe
                step="validate-genericode-xvrl"
                port="report" />
        </p:with-input>
        <p:with-input
            port="stylesheet"
            href="../xslt/xvrl2html.xsl" />
    </p:xslt>

</p:declare-step>