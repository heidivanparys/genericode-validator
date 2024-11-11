<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns="http://www.xproc.org/ns/xvrl"
    xmlns:xvrl="http://www.xproc.org/ns/xvrl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all">

    <xsl:param
        name="document"
        required="true" />
    <xsl:param
        name="timestamp"
        required="true" />
        
    <xsl:output indent="true" />

    <xsl:mode on-no-match="shallow-copy" />
    
    <xsl:template match="/xvrl:reports">
        <xsl:copy>
            <metadata>
                <title>
                    <xsl:value-of select="'Validation report'" />
                </title>
                <document>
                    <xsl:value-of select="$document" />
                </document>
                <timestamp>
                    <xsl:value-of select="$timestamp" />
                </timestamp>
            </metadata>
            <!-- Copy any reports inside xvrl:reports -->
            <xsl:apply-templates select="*" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>