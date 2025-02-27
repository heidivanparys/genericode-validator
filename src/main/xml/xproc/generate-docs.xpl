<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    name="generate-docs"
    version="3.0">

    <p:documentation>This step creates HTML pages containing documentation of the validation rules in folder docs in this repository. The output of
        this step should only be present in the branch from which the documentation is published on the web.
    </p:documentation>

    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />

    <p:group name="index-file">
        <p:variable
            name="index-file-uri"
            select="resolve-uri('../../../../docs/index.html')" />

        <p:xslt
            name="create-index"
            message="Create {$index-file-uri}">
            <p:with-input port="source">
                <p:empty />
            </p:with-input>
            <p:with-input
                port="stylesheet"
                href="../xslt/create-index-html.xsl" />
            <p:with-option
                name="template-name"
                select="'start-template'" />
        </p:xslt>

        <p:store
            name="store-index-html"
            message="Store {$index-file-uri}"
            href="{$index-file-uri}" />

        <p:sink />
    </p:group>

    <p:group name="document-rules">
        <p:variable
            name="document-rules-uri"
            select="resolve-uri('../../../../docs/genericode-document-rules.html')" />

        <p:xslt
            name="convert-document-rules"
            message="Create {$document-rules-uri}">
            <p:with-input
                port="source"
                href="../schemas/schematron/genericode-document-rules.sch" />
            <p:with-input
                port="stylesheet"
                href="../xslt/sch2html.xsl" />
        </p:xslt>

        <p:store
            name="store-document-rules"
            message="Store {$document-rules-uri}"
            href="{$document-rules-uri}" />

        <p:sink />
    </p:group>

    <p:group name="additional-rules">
        <p:variable
            name="additional-rules-uri"
            select="resolve-uri('../../../../docs/genericode-additional-rules.html')" />

        <p:xslt
            name="convert-additional-rules"
            message="Create {$additional-rules-uri}">
            <p:with-input
                port="source"
                href="../schemas/schematron/genericode-additional-rules.sch" />
            <p:with-input
                port="stylesheet"
                href="../xslt/sch2html.xsl" />
        </p:xslt>

        <p:store
            name="store-additional-rules"
            message="Store {$additional-rules-uri}"
            href="{$additional-rules-uri}" />

        <p:sink />
    </p:group>

</p:declare-step>