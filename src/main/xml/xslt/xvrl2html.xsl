<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xvrl="http://www.xproc.org/ns/xvrl"
    exclude-result-prefixes="#all">
  
    <xsl:output
        method="html"
        html-version="5.0"
        omit-xml-declaration="yes"
        indent="yes" />

    <xsl:mode on-no-match="shallow-copy" />
    
    <xsl:param
        name="designsystemVersion"
        select="'8'" />

    <xsl:param
        name="designsystemUrl"
        select="'https://cdn.dataforsyningen.dk/assets/designsystem/v' || $designsystemVersion" />

    <xsl:template match="/xvrl:reports">
        <html lang="en">
            <head>
                <title>
                    <xsl:value-of select="xvrl:metadata/xvrl:title || ' for ' || tokenize(xvrl:metadata/xvrl:document, '/')[last()]" />
                </title>
                <meta charset="utf-8" /><!-- See https://html.spec.whatwg.org/multipage/semantics.html#charset -->
                <meta
                    name="viewport"
                    content="width=device-width, initial-scale=1.0" /><!-- Nice view, also for narrow screen devices, see https://developer.mozilla.org/en-US/docs/Web/HTML/Viewport_meta_tag -->
                <link rel="stylesheet">
                    <xsl:attribute
                        name="href"
                        select="$designsystemUrl || '/designsystem.css'" />
                </link>
            </head>
            <body>
                <header class="ds-header">
                    <div class="ds-container">
                        <!-- It is on purpose that no logo is shown, as this is just a validation report, not a for use on a website -->
                        <h1>
                            <xsl:value-of select="xvrl:metadata/xvrl:title" />
                        </h1>
                    </div>
                </header>
                <main>
                    <xsl:apply-templates
                        select="."
                        mode="summary" />
                    <xsl:apply-templates select="xvrl:report" />
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template
        match="xvrl:reports"
        mode="summary">
        <section class="ds-container">
            <h2>Summary</h2>
            <table>
                <tr>
                    <th scope="row">Document</th>
                    <td>
                        <a>
                            <xsl:attribute
                                name="href"
                                select="xvrl:metadata/xvrl:document" />
                            <xsl:value-of select="xvrl:metadata/xvrl:document" />
                        </a>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Timestamp</th>
                    <td>
                        <xsl:value-of select="xvrl:metadata/xvrl:timestamp" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Total number of detections</th>
                    <td>
                        <xsl:value-of select="count(xvrl:report/xvrl:detection)" />
                    </td>
                </tr>
            </table>
        </section>
    </xsl:template>

    <xsl:template match="xvrl:report">
        <section class="ds-container">
            <h2>
                <xsl:choose>
                    <xsl:when test="exists(xvrl:metadata/xvrl:title)">
                        <xsl:value-of select="xvrl:metadata/xvrl:title" />
                    </xsl:when>
                    <xsl:when test="xvrl:metadata/xvrl:schema[@schematypens eq 'http://purl.oclc.org/dsdl/schematron']">
                        <xsl:value-of select="'Schematron validation'" />
                    </xsl:when>
                    <xsl:when test="xvrl:metadata/xvrl:schema[@schematypens eq 'http://www.w3.org/2001/XMLSchema']">
                        <xsl:value-of select="'XML Schema validation'" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'Report ' || position()" />
                    </xsl:otherwise>
                </xsl:choose>
            </h2>
            <table>
                <xsl:if test="exists(xvrl:metadata/xvrl:schema/@href)">
                    <tr>
                        <th scope="row">Schema</th>
                        <td>
                            <a>
                                <xsl:attribute
                                    name="href"
                                    select="xvrl:metadata/xvrl:schema/@href" />
                                <xsl:value-of select="xvrl:metadata/xvrl:schema/@href" />
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="exists(xvrl:metadata/xvrl:summary)">
                    <tr>
                        <!-- In the XVRL specification,
                        the summary element is defined as 
                        "An abstract of a report, a reports collection, or an individual detection."
                        Therefore the term "Abstract" in the HTML report -->
                        <th scope="row">Abstract</th>
                        <td>
                            <xsl:value-of select="xvrl:metadata/xvrl:summary" />
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <th scope="row">Timestamp</th>
                    <td>
                        <xsl:value-of select="xvrl:metadata/xvrl:timestamp" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Number of detections</th>
                    <td>
                        <xsl:value-of select="count(xvrl:detection)" />
                    </td>
                </tr>
            </table>
            <table>
                <thead>
                    <tr>
                        <th scope="col">Severity</th>
                        <xsl:if test="exists(xvrl:detection/xvrl:category)">
                            <th scope="col">Category</th>
                        </xsl:if>
                        <th scope="col">Message</th>
                        <th scope="col">Location</th>
                        <th scope="col">Supplemental information</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="xvrl:detection">
                        <tr>
                            <td>
                                <xsl:value-of select="@severity" />
                            </td>
                            <xsl:if test="exists(xvrl:category)">
                                <td>
                                    <xsl:value-of select="xvrl:category" />
                                </td>
                            </xsl:if>
                            <td>
                                <xsl:value-of select="xvrl:message" />
                            </td>
                            <td>
                                <xsl:if test="exists(xvrl:location/@*)">
                                    <ul>
                                        <xsl:for-each select="xvrl:location/@*">
                                            <li>
                                                <xsl:value-of select="local-name() || ': ' || ." />
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>
                            </td>
                            <td>
                                <xsl:if test="exists(xvrl:supplemental)">
                                    <ul>
                                        <xsl:for-each select="xvrl:supplemental">
                                            <li>
                                                <xsl:value-of select="text()" />
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </section>
    </xsl:template>

</xsl:stylesheet>