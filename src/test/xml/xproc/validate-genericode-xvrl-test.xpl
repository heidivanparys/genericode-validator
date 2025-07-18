<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:gv="urn:uuid:54458f97-a354-46fe-b0ec-6d7a009d0e7a"
    name="validate-genericode-xvrl-test"
    version="3.1">

    <p:documentation>
        This test step tests step validate-genericode-xvrl: it checks that the XVRL validation reports for all genericode files in this
        repository are actually valid XVRL reports.
    </p:documentation>

    <p:import href="../../../main/xml/xproc/validate-genericode-xvrl.xpl" />
    <p:import href="../../../main/xml/xproc/validate-xvrl-report.xpl" />

    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />

    <p:directory-list
        name="create-directory-list"
        message="Create directory list with all .gc files in this repository">
        <p:with-option
            name="path"
            select="'../../../'" />
        <p:with-option
            name="include-filter"
            select="'.*\.gc'" />
        <p:with-option
            name="max-depth"
            select="'unbounded'" />
    </p:directory-list>

    <p:for-each name="validate-gc-files">
        <p:with-input select="//c:file" />

        <p:variable
            name="base-uri-gc"
            select="base-uri(/c:file)" />

        <p:load
            href="{$base-uri-gc}"
            content-type="application/xml" />

        <gv:validate-genericode-xvrl
            name="validate-genericode-xvrl"
            p:message="Validate and create XVRL report for {$base-uri-gc}">
            <p:with-option
                name="assert-valid"
                select="false()" />
        </gv:validate-genericode-xvrl>

        <p:store
            name="store-xvrl-report"
            message="Store XVRL report for debugging"
            href="{'../../../../target/validate-genericode-xvrl-' || format-time(current-time(),'[H01][m01][s01][f001]') || '.xvrl'}"
            serialization="map { 'indent': true() }"
            use-when="$debug">
            <p:with-input port="source">
                <p:pipe
                    step="validate-genericode-xvrl"
                    port="report" />
            </p:with-input>
        </p:store>

        <gv:validate-xvrl-report
            name="validate-xvrl-report"
            p:message="Validate XVRL report">
            <p:with-input port="source">
                <p:pipe
                    step="validate-genericode-xvrl"
                    port="report" />
            </p:with-input>
            <p:with-option
                name="assert-valid"
                select="true()" />
        </gv:validate-xvrl-report>

    </p:for-each>

</p:declare-step>