<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:gv="urn:uuid:54458f97-a354-46fe-b0ec-6d7a009d0e7a"
    xmlns:xvrl="http://www.xproc.org/ns/xvrl"
    type="gv:validate-xvrl-report"
    version="3.0">

    <p:documentation>This step checks the validity of a XVRL report
        against the XVRL RELAX NG schema.
        The names of the ports and the options use the same naming conventions as used 
        in the XProc Validation steps specification.
    </p:documentation>

    <p:input
        port="source"
        primary="true"
        content-types="xml" />

    <p:output
        port="result"
        primary="true"
        content-types="xml">
        <p:pipe
            step="validate-xvrl-relaxng"
            port="result" />
    </p:output>

    <p:output
        port="report"
        primary="false"
        content-types="xml">
        <p:pipe
            step="validate-xvrl-relaxng"
            port="report" />
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
        
    <p:validate-with-relax-ng
        name="validate-xvrl-relaxng"
        message="Validate XVRL report with RELAX NG schema">
        <p:with-input
            port="schema"
            href="../schemas/relaxng/xvrl.rnc" />
        <p:with-option
            name="assert-valid"
            select="$assert-valid" />
    </p:validate-with-relax-ng>

</p:declare-step>