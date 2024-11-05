<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- html-version: see:
	       https://www.saxonica.com/documentation12/index.html#!xsl-elements/output
	       https://www.w3.org/TR/xslt-30/ -->
    <xsl:output
        method="xhtml"
        html-version="5.0"
        omit-xml-declaration="yes"
        indent="yes" />

    <xsl:mode on-no-match="shallow-copy" />

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Validation report</title>
                <!-- Quick and simple styling, see https://simplecss.org/ -->
                <link
                    rel="stylesheet"
                    href="https://cdn.simplecss.org/simple.min.css" />
                <!-- Allow for wide content
                See https://github.com/kevquirk/simple.css/issues/48#issuecomment-1175885375 -->
                <style>
                    body {
                    grid-template-columns: 0fr 90% 0fr;
                    place-content: center;
                    }
                </style>
            </head>
            <body>
                <header>
                    <div>
                        <h1>Validation report</h1>
                    </div>
                </header>
                <main>
                    <section>
                        <table>
                            <caption>Failed asserts</caption>
                            <thead>
                                <tr>
                                    <th>Number</th>
                                    <th>Assert id</th>
                                    <th>Assert text</th>
                                    <th>Location</th>
                                    <th>Diagnostics</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//svrl:failed-assert">
                                    <tr>
                                        <td>
                                            <xsl:value-of select="position()" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="if (@id) then @id else '(assert without id)'" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="svrl:text" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="@location" />
                                        </td>
                                        <td>
                                            <xsl:if test="exists(svrl:diagnostic-reference)">
                                                <ul>
                                                    <xsl:for-each select="svrl:diagnostic-reference">
                                                        <li>
                                                            <xsl:value-of select="svrl:text" />
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </xsl:if>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="5">
                                        <xsl:value-of select="count(.//svrl:failed-assert)" />
                                        failed asserts in total
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </section>
                </main>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>