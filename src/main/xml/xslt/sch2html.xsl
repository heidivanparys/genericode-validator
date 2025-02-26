<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all">
    
    <!-- 
    Stylesheet that convert a Schematron schema to an HTML file.
    -->

    <xsl:output
        method="html"
        html-version="5.0"
        omit-xml-declaration="yes"
        indent="yes"
        encoding="utf-8" />

    <xsl:mode on-no-match="shallow-copy" />

    <xsl:include href="common-html.xsl" />

    <xsl:template match="/sch:schema">
        <html lang="en">
            <head>
                <title>
                    <xsl:value-of select="sch:title" />
                </title>
                <meta
                    name="viewport"
                    content="width=device-width, initial-scale=1.0" /><!-- Nice view, also for narrow screen devices, see https://developer.mozilla.org/en-US/docs/Web/HTML/Viewport_meta_tag -->
                <link rel="stylesheet">
                    <xsl:attribute
                        name="href"
                        select="$designsystemUrl || '/designsystem.css'" />
                </link>
                <style>
                    section + section, section section {margin-top: var(--space-md)}
                    h2 span::first-letter{text-transform: uppercase}
                    h3
                    span::first-letter{text-transform: uppercase}
                </style>
            </head>
            <body>
                <header class="ds-header">
                    <div class="ds-container">
                        <h1>
                            <xsl:call-template name="addIdAndTitle" />
                        </h1>
                        <xsl:apply-templates select="sch:p" />
                    </div>
                </header>
                <main class="ds-container">
                    <xsl:apply-templates select="sch:pattern" />
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="sch:pattern">
        <section>
            <h2>
                <xsl:call-template name="addIdAndTitle" />
            </h2>
            <xsl:apply-templates select="sch:p" />
            <table>
                <thead>
                    <tr>
                        <th>Severity</th>
                        <th>Rule</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="sch:rule">
                        <xsl:variable
                            name="context"
                            select="@context" />
                        <xsl:for-each select="sch:assert|sch:report">
                            <tr>
                                <xsl:call-template name="addId" />
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="exists(@role)">
                                            <xsl:value-of select="@role" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'error'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                                <td>
                                    <xsl:value-of select="." />
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:for-each>
                </tbody>
            </table>
        </section>
    </xsl:template>

    <xsl:template match="sch:p">
        <p>
            <xsl:apply-templates select="@*|node()" />
        </p>
    </xsl:template>

    <xsl:template name="addIdAndTitle">
        <xsl:call-template name="addId" />
        <xsl:choose>
            <xsl:when test="exists(sch:title)">
                <xsl:value-of select="sch:title" />
            </xsl:when>
            <xsl:otherwise>
                <!-- Add span so that ::first-letter can be used, even if the surrounding HTML element has CSS styling display:flex -->
                <span>
                    <xsl:value-of select="local-name() || ' ' || position()" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>