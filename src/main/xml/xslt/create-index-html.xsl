<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output
        method="html"
        html-version="5.0"
        include-content-type="no"
        omit-xml-declaration="yes" />

    <xsl:include href="common-html.xsl" />

    <xsl:variable
        name="exitSiteIcon"
        select="document($designsystemUrl || '/icons/exitsite.svg')" />

    <xsl:variable
        name="title"
        select="'Validation for genericode files'" />

    <xsl:variable
        name="repo"
        select="'https://github.com/SDFIdk/genericode-validator'" />

    <xsl:template name="start-template">
        <html lang="en">
            <head>
                <meta charset="utf-8" /><!-- See https://html.spec.whatwg.org/multipage/semantics.html#charset -->
                <meta
                    name="viewport"
                    content="width=device-width, initial-scale=1.0" /><!-- Nice view, also for narrow screen devices, see https://developer.mozilla.org/en-US/docs/Web/HTML/Viewport_meta_tag -->
                <title>
                    <xsl:value-of select="$title" />
                </title>
                <link rel="stylesheet">
                    <xsl:attribute
                        name="href"
                        select="$designsystemUrl || '/designsystem.css'" />
                </link>
                <link rel="icon">
                    <xsl:attribute
                        name="href"
                        select="$designsystemUrl || '/logo-small.svg'" />
                </link>
                <script type="module">
                    import {
                    DSLogo,
                    DSLogoTitle
                    } from
                    <xsl:value-of select="' '' ' || $designsystemUrl || '/designsystem.js '' '" />
                    customElements.define('ds-logo', DSLogo)
                    customElements.define('ds-logo-title', DSLogoTitle)
                </script>
            </head>
            <body>
                <header class="ds-header">
                    <div class="ds-container">
                        <ds-logo-title>
                            <xsl:attribute
                                name="title"
                                select="$title" />
                            <xsl:attribute
                                name="byline"
                                select="$organisation" />
                        </ds-logo-title>
                        <h1>
                            <xsl:value-of select="$title" />
                        </h1>
                    </div>
                </header>
                <main class="ds-container">
                    <section>
                        <p>
                            <a>
                                <xsl:attribute
                                    name="href"
                                    select="$repo" />
                                <xsl:text>Genericode-validator</xsl:text>
                            </a>
                            <xsl:text> provides functionality to validate a </xsl:text>
                            <xsl:call-template name="createExternalHyperLink">
                                <xsl:with-param
                                    name="url"
                                    select="'https://docs.oasis-open.org/codelist/genericode/v1.0/os/genericode-v1.0-os.html'" />
                                <xsl:with-param
                                    name="text"
                                    select="'genericode'" />
                            </xsl:call-template>
                            <xsl:text> file against several sets of rules:</xsl:text>
                        </p>
                        <ol>
                            <li>
                                <xsl:text>The XML schema that defines the XML structural constraints for a genericode file, see section </xsl:text>
                                <xsl:call-template name="createExternalHyperLink">
                                    <xsl:with-param
                                        name="url"
                                        select="'https://docs.oasis-open.org/codelist/genericode/v1.0/os/genericode-v1.0-os.html#S-GENERICODE-XML-SERIALIZATION'" />
                                    <xsl:with-param
                                        name="text"
                                        select="'3 Genericode XML Serialization'" />
                                </xsl:call-template>
                                <xsl:text> in the OASIS standard and see </xsl:text>
                                <a href="https://docs.oasis-open.org/codelist/genericode/v1.0/os/xsd/genericode.xsd">
                                    the XML schema itself
                                    <xsl:copy-of select="$exitSiteIcon" />
                                </a>
                                <xsl:text>;</xsl:text>
                            </li>
                            <li>
                                <xsl:text>The document rules for a genericode file, see section </xsl:text>
                                <xsl:call-template name="createExternalHyperLink">
                                    <xsl:with-param
                                        name="url"
                                        select="'https://docs.oasis-open.org/codelist/genericode/v1.0/os/genericode-v1.0-os.html#S-CATEGORY-DOCUMENT'" />
                                    <xsl:with-param
                                        name="text"
                                        select="'4.2 Category: document'" />
                                </xsl:call-template>
                                <xsl:text> in the OASIS standard and see the </xsl:text>
                                <xsl:call-template name="createExternalHyperLink">
                                    <xsl:with-param
                                        name="url"
                                        select="'./genericode-document-rules.html'" />
                                    <xsl:with-param
                                        name="text"
                                        select="'equivalent rules in genericode-validator'" />
                                </xsl:call-template>
                                <xsl:text>;</xsl:text>
                            </li>
                            <li>
                                <xsl:call-template name="createExternalHyperLink">
                                    <xsl:with-param
                                        name="url"
                                        select="'./genericode-additional-rules.html'" />
                                    <xsl:with-param
                                        name="text"
                                        select="'Additional rules'" />
                                </xsl:call-template>
                                <xsl:text> for a genericode file that are specified by </xsl:text>
                                <xsl:value-of select="$organisation" />
                                <xsl:text>.</xsl:text>
                            </li>
                        </ol>
                        <p>
                            <a>
                                <xsl:attribute
                                    name="href"
                                    select="$repo" />
                                <xsl:text>The repository itself</xsl:text>
                            </a>
                            <xsl:text> contains more information about how to use the tool and the implementation of the rules.</xsl:text>
                        </p>
                    </section>
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="createExternalHyperLink">
        <xsl:param
            name="url"
            required="true" />
        <xsl:param
            name="text"
            required="true" />
        <a
            target="_blank"
            rel="noreferrer noopener">
            <xsl:attribute
                name="href"
                select="$url" />
            <xsl:value-of select="$text" />
            <xsl:copy-of select="$exitSiteIcon" />
        </a>
    </xsl:template>

</xsl:stylesheet>