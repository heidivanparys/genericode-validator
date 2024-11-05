<p:declare-step
    name="validate-genericode-document"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    version="3.0">

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
        port="report-xsd-validation-xvrl"
        primary="false">
        <p:pipe
            step="validate-genericode-xsd"
            port="report" />
    </p:output>

    <p:output
        port="report-schematron-gc-document-rules-validation-svrl"
        primary="false">
        <p:pipe
            step="validate-genericode-document-rules"
            port="report" />
    </p:output>

    <p:output
        port="report-schematron-gc-document-rules-validation-html"
        primary="false">
        <p:pipe
            step="transform-validation-report-genericode-document-rules-to-html"
            port="result" />
    </p:output>
    
    <p:output
        port="report-schematron-gc-additional-rules-validation-svrl"
        primary="false">
        <p:pipe
            step="validate-genericode-additional-rules"
            port="report" />
    </p:output>

    <p:output
        port="report-schematron-gc-additional-rules-validation-html"
        primary="false">
        <p:pipe
            step="transform-validation-report-genericode-additional-rules-to-html"
            port="result" />
    </p:output>


    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />

    <p:identity
        name="create-copy-of-input"
        message="Create a copy of the input" />

    <p:validate-with-xml-schema
        name="validate-genericode-xsd"
        message="Validate the structure against the genericode XML schema">
        <p:with-input
            port="schema"
            href="../schemas/xsd/genericode.xsd" />
        <p:with-option
            name="assert-valid"
            select="false()" />
    </p:validate-with-xml-schema>

    <p:validate-with-schematron
        name="validate-genericode-document-rules"
        message="Validate the document rules defined by the genericode specification and implemented in Schematron">
        <p:with-input
            port="schema"
            href="../schemas/schematron/genericode-document-rules.sch" />
        <p:with-option
            name="assert-valid"
            select="false()" />
    </p:validate-with-schematron>
    
    <p:validate-with-schematron
        name="validate-genericode-additional-rules"
        message="Validate the additional rules defined by the Agency of Climate Data and implemented in Schematron">
        <p:with-input
            port="schema"
            href="../schemas/schematron/genericode-additional-rules.sch" />
        <p:with-option
            name="assert-valid"
            select="false()" />
    </p:validate-with-schematron>
    
    <!-- TODO: Combine all XVRL and SVRL into one HTML-page instead of several HTML-pages. -->

    <p:xslt
        name="transform-validation-report-genericode-document-rules-to-html"
        message="Transform the report of the validation of the document rules to a human-readable report">
        <p:with-input port="source">
            <p:pipe
                step="validate-genericode-document-rules"
                port="report" />
        </p:with-input>
        <p:with-input
            port="stylesheet"
            href="../xslt/svrl2html.xsl" />
    </p:xslt>
    
    <p:xslt
        name="transform-validation-report-genericode-additional-rules-to-html"
        message="Transform the report of the validation of the additional rules to a human-readable report">
        <p:with-input port="source">
            <p:pipe
                step="validate-genericode-additional-rules"
                port="report" />
        </p:with-input>
        <p:with-input
            port="stylesheet"
            href="../xslt/svrl2html.xsl" />
    </p:xslt>

</p:declare-step>